
/*
	Mouse state reading ---------------------------------------------------------------------
*/
/*

	Every time a player moves his mouse (within the map screen)
	that player's client is updated for the variables:
		mouse.apos		-	the mouse's absolute location on the map
		mouse.spos		-	the mouse's location relative to the bottom-left of the screen
		mouse.pos		-	the mouse's location relative to the center of the screen
		mouse.angle
		mouse.bearing

	The clicked state of the mouse is also stored in:
		mouse.left
		mouse.right
		mouse.middle
*/
/*
mob
	Login()
		..()
		client.track_mouse(1, 1, 105 + EFFECTS_LAYER)
*/
obj/mouse_tracker
	name = "Mouse Tracker"
	screen_loc = "SOUTHWEST to NORTHEAST"

	update(params[])
		if(!params) return
		params = params2list(params)

		var pos = params["screen-loc"]
		if(!pos) return

		var first_colon = findtext(pos, ":")
		var map_control = copytext(pos, 1, first_colon)
		if(!text2num(map_control))
			pos = copytext(pos, first_colon + 1)

		var a[] = split(pos, ",")

		var x[] = text2dim(a[1], ":")
		var y[] = text2dim(a[2], ":")

		client.MouseUpdate(x[1], x[2], y[1], y[2])


mouse
	var
		spos[]		=	vec2(0, 0)
		pos[]		=	vec2(0, 0)
		angle		=	0

		left		=	0
		right		=	0
		middle		=	0

		tracking	=	0

		//	an atom the mouse is over
		atom/over

client
	var mouse/mouse = new

	MouseDown(o, l, c, pa)
		var p[] = params2list(pa)
		mouse.left		|=	(text2num(p["left"])	|| 0)
		mouse.right		|=	(text2num(p["right"])	|| 0)
		mouse.middle	|=	(text2num(p["middle"])	|| 0)
		..()

	MouseUp(o, l, c, pa)
		var p[] = params2list(pa)
		mouse.left		&=	~(text2num(p["left"])	|| 0)
		mouse.right		&=	~(text2num(p["right"])	|| 0)
		mouse.middle	&=	~(text2num(p["middle"])	|| 0)
		..()

	MouseEntered(over_object)
		mouse.over = over_object
		..()

	MouseExited()
		mouse.over = null
		..()

	MouseDrag(src_object, over_object)
		mouse.over = over_object
		..()

	var center[]
	var _view
	MouseUpdate(tx, px, ty, py)
		if(_view != view)
			if(isnum(view))
				var v = view * 2 + 1
				view_size = vec2(v, v)
			else view_size = text2dim(view)
			center = vec2(
				tile_width()  * view_size[1] / 2,
				tile_height() * view_size[2] / 2)

		mouse.spos = vec2(
			(tx - 1) * tile_width()  + px,
			(ty - 1) * tile_height() + py)
		mouse.pos = vec2_sub(mouse.spos, center)
		mouse.angle = vec2_angle(mouse.pos)
		mouse.tracking = TRUE

	track_mouse(track = TRUE, resolution = 4, layer = 10000)
		. = ..()
		if(!track) mouse.tracking = 0