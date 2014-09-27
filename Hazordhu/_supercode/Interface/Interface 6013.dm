var const
	//	Default controls
	DMF_WINDOW = "default"
	DMF_MAP = "map"
	DMF_INPUT = "input"

var controls_to_hide[] = list(
	"chat_channel",
	"set_language", "learn_language",
	"item_button", "character_button"
)

client
	set_keys()
		. = ..()
		keys |= list("z", "c", "escape")

mob/player
	verb/toggle_menu()
		set hidden = TRUE
		if("false" == winget(src, "main_menu", "is-visible"))
			map_focus()
			client.center_window("main_menu")
			winshow(src, "main_menu")
		else winshow(src, "main_menu", 0)

	verb/swap_panes()
		set hidden = TRUE
		var new_splitter = 100 - text2num(winget(src, "child_main", "splitter"))
		if("chat" == winget(src, "child_main", "left"))
			winset(src, null, "child_main.left=screen; child_main.right=chat; child_main.splitter=[new_splitter]")
		else winset(src, null, "child_main.left=chat; child_main.right=screen; child_main.splitter=[new_splitter]")

	verb/set_icon_size(n as num)
		set hidden = TRUE
		client.icon_size = n
		client.update_view_size()

	proc/toggle_items()
		if("false" == winget(src, "child_left", "is-visible"))
			show_items()
		else hide_items()

	proc/show_items()
		if(AtTitleScreen) return
		winshow(src, "child_left")

	proc/hide_items()
		winshow(src, "child_left", 0)
		if(storage) stop_storage()

	proc/toggle_crafting()
		if("false" == winget(src, "child_right", "is-visible"))
			show_crafting()
		else hide_crafting()

	proc/show_crafting()
		if(AtTitleScreen) return
		winshow(src, "child_right")

	proc/hide_crafting()
		winshow(src, "child_right", 0)

	key_down(k)
		switch(k)
			if("z") toggle_items()
			if("c")	toggle_crafting()
			if("escape") toggle_menu()
			else ..()

	proc/PostLogin()
	proc/PreLogout()
	proc/set_title_screen()
	proc/set_game_screen()

	set_title_screen()
		var params[0]
		params["[DMF_WINDOW].pos"] = "0,0"
		params["[DMF_WINDOW].size"] = "10000x10000"
		params["[DMF_WINDOW].is-maximized"] = "true"
		params["[DMF_WINDOW].titlebar"] = "true"
		params["[DMF_INPUT].command"] = "!Say \""
		params["input.command"] = "!OOC \""

		for(var/control in controls_to_hide)
			params["[control].is-visible"] = "false"

		winset(src, null, list2params(params))
		client.update_view_size()
		client.center_window(DMF_WINDOW)
		..()

	set_game_screen()
		var params[0]
		params["[DMF_WINDOW].titlebar"] = "true"
		params["input.command"] = "!Say \""
		for(var/control in controls_to_hide)
			params["[control].is-visible"] = "true"

		winset(src, null, list2params(params))

		client.update_view_size()
		..()

client
	var icon_size = 64

	verb/update_view_size()
		set hidden = TRUE

		resolution = text2dim(winget(src, DMF_MAP, "size"), "x")

		var max_width = 19
		var max_height = 19
		var min_width = 15
		var min_height = 13

		if(!icon_size)
			view_size = vec2(max_width, max_height)

		else
			view_size = vec2(min_width, min_height)

			var icon_size = src.icon_size
			var tile_size = icon_size
			var width = resolution[1] / tile_size
			var height = resolution[2] / tile_size

			if(width <  min_width)
				icon_size = 0
				tile_size = min(tile_size, resolution[1] / min_width)

			if(height < min_height)
				icon_size = 0
				tile_size = min(tile_size, resolution[2] / min_height)

			width = min(max_width, resolution[1] / tile_size)
			height = min(max_height, resolution[2] / tile_size)

			if(width >  min_width * src.icon_size / tile_size)
				view_size[1] = round(width)

			if(height > min_height * src.icon_size / tile_size)
				view_size[2] = round(height)

			view_size[1] = round(view_size[1], 2) + 1
			view_size[2] = round(view_size[2], 2) + 1

		winset(src, DMF_MAP, "icon-size=[icon_size]")

		view = "[view_size[1]]x[view_size[2]]"

		var mob/player/p = mob
		if(p.info_bar)
			p.info_bar.maptext_width = view_size[1] * 32
			p.info_bar.set_text()