var const
	//	Default controls
	DMF_WINDOW	= "default"
	DMF_MAP		= "map"
	DMF_INPUT	= "input"

client
	set_keys()
		. = ..()
		keys |= list("z", "x", "c", "v")

	var map_tile_size = 32
	verb/fill_view()
		set hidden = TRUE
		var min_view_width = 23
		var min_view_height = 15

		resolution = text2dim(winget(src, DMF_MAP, "size"), "x")

		if(resolution[1] / 64 > min_view_width && resolution[2] / 64 > min_view_height)
			map_tile_size = 64
			view_size = vec2(
				round(max(min_view_width, resolution[1] / 64)),
				round(max(min_view_height, resolution[2] / 64)))
		else
			if(resolution[1] / 32 > min_view_width && resolution[2] / 32 > min_view_height)
				map_tile_size = 32
			else map_tile_size = 0
			view_size = vec2(
				round(max(min_view_width, resolution[1] / 32)),
				round(max(min_view_height, resolution[2] / 32)))
		winset(src, DMF_MAP, "icon-size=[map_tile_size]")
		view_size[1] = round(view_size[1], 2) + 1
		view_size[2] = round(view_size[2], 2) + 1
		view = "[view_size[1]]x[view_size[2]]"

		var mob/player/p = mob
		if(p.info_bar)
			p.info_bar.maptext_width = view_size[1] * 32
			p.info_bar.set_text()

mob/player
	key_down(k)
		switch(k)
			if("z") menu_button.toggle()
			if("x") inventory_button.toggle()
			if("c") crafting_button.toggle()
			else ..()

	Login()
		client.fill_view()
		..()

	proc/PostLogin()
		client.fill_view()

	proc/PreLogout()