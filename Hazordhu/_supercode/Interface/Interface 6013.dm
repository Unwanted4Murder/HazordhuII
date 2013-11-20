var const
	//	Default controls
	DMF_WINDOW = "default"
	DMF_MAP = "map"
	DMF_INPUT = "input"

var controls_to_hide[] = list(
//	"status",
	"chat_channel",
//	"health_icon", "health_bar",
//	"stamina_icon", "stamina_bar",
//	"blood_icon", "blood_bar",
//	"hunger_icon", "hunger_bar",
//	"thirst_icon", "thirst_bar",
//	"heat_icon", "heat_bar",
	"set_language", "learn_language",
	"item_button", "character_button"
)

client
	var resolution[] = vec2_zero
	var view_size[] = vec2_zero

	var apparent_season
	var turf/_virtual_turf	//	previous
	var turf/virtual_turf	//	current

	//	returns true when the eye moved
	proc/move_tick()
		var season = get_season()
		virtual_turf = turf_of(virtual_eye)
		if(apparent_season != season || virtual_turf != _virtual_turf)
			apparent_season = season
			_virtual_turf = virtual_turf
			if(!virtual_turf) return
			if(!season) return
			for(var/atom/a in range("[view_size[1] + 6]x[view_size[2] + 6]", virtual_turf))
				if(!a.initialized)
					a.initialize()
					a.initialized = true
				if(a.season_updates && a.apparent_season != season) a.season_update(season)
			return true

client
	set_keys()
		. = ..()
		keys |= list("z", "c", "escape")

mob/player
	verb/toggle_menu()
		set hidden = true
		if("false" == winget(src, "main_menu", "is-visible"))
			map_focus()
			client.center_window("main_menu")
			winshow(src, "main_menu")
		else winshow(src, "main_menu", 0)

	verb/swap_panes()
		set hidden = true
		var new_splitter = 100 - text2num(winget(src, "child_main", "splitter"))
		if("chat" == winget(src, "child_main", "left"))
			winset(src, null, "child_main.left=screen; child_main.right=chat; child_main.splitter=[new_splitter]")
		else winset(src, null, "child_main.left=chat; child_main.right=screen; child_main.splitter=[new_splitter]")

	verb/set_icon_size(n as num)
		set hidden = true
		client.icon_size = n
		update_view_size()

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
		update_view_size()
		client.center_window(DMF_WINDOW)
		..()

	set_game_screen()
		var params[0]
		params["[DMF_WINDOW].titlebar"] = "true"
		params["input.command"] = "!Say \""
		for(var/control in controls_to_hide)
			params["[control].is-visible"] = "true"

		winset(src, null, list2params(params))

		update_view_size()
		..()

client
	var icon_size = 64

mob/player
	verb/update_view_size()
		set hidden = true
		client.resolution = text2dim(winget(src, DMF_MAP, "size"), "x")

		var max_width = 19
		var max_height = 19
		var min_width = 15
		var min_height = 13
		client.view_size = vec2(min_width, min_height)

		var icon_size = client.icon_size
		var tile_size = icon_size
		var width = client.resolution[1] / tile_size
		var height = client.resolution[2] / tile_size

		if(width <  min_width)
			icon_size = 0
			tile_size = min(tile_size, client.resolution[1] / min_width)

		if(height < min_height)
			icon_size = 0
			tile_size = min(tile_size, client.resolution[2] / min_height)

		width = min(max_width, client.resolution[1] / tile_size)
		height = min(max_height, client.resolution[2] / tile_size)

		if(width >  min_width * client.icon_size / tile_size)
			client.view_size[1] = round(width)

		if(height > min_height * client.icon_size / tile_size)
			client.view_size[2] = round(height)

		winset(src, DMF_MAP, "icon-size=[icon_size]")

		client.view = "[client.view_size[1]]x[client.view_size[2]]"

		if(info_bar)
			info_bar.maptext_width = client.view_size[1] * 32
			info_bar.set_text()