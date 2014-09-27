//	Kaiochao
//	11 Jan 2014 (Last Modified: 4 May 2014)
//	Mouse

//	This provides a datum attached to a client that can be used to get information about
// where the player's mouse is in the screen.

/*	Example of use

client
	MouseMoved()
		mob.transform = matrix(mouse.angle, MATRIX_ROTATE)

*/

mouse
	var
		//	Is the mouse currently over the map?
		on_map = FALSE

		//	The pixel position of the mouse in the screen (1,1 is the bottom-left)
		pixel_x = 0
		pixel_y = 0

		//	The movement of the mouse in pixels since the previous update
		move_x = 0
		move_y = 0

		//	The position of the mouse relative to the screen's center
		//	Think of it as a vector from the center to the mouse
		delta_x = 0
		delta_y = 0

		//	Angle from the center to the mouse (clock-wise from NORTH)
		angle = 0

	proc
		UpdatePosition(client:client, screen_loc)
			var colons[0]
			var colon_found
			var colon_start = 1
			for()
				colon_found = findtext(screen_loc, ":", colon_start)
				if(colon_found)
					colon_start = colon_found + 1
					colons += colon_found
				else break

			if(!colons.len) return

			var start = 1

			if(colons.len >= 3)
				start = colons[1] + 1
				colons.Cut(1, 2)

			var comma = findtext(screen_loc, ",")

			var new_pixel_x = (text2num(copytext(screen_loc,     start, colons[1])) - 1) * tile_width()  + text2num(copytext(screen_loc, colons[1] + 1, comma))
			var new_pixel_y = (text2num(copytext(screen_loc, comma + 1, colons[2])) - 1) * tile_height() + text2num(copytext(screen_loc, colons[2] + 1))

			move_x = new_pixel_x - pixel_x
			move_y = new_pixel_y - pixel_y

			pixel_x = new_pixel_x
			pixel_y = new_pixel_y

		UpdateDeltas(center_x, center_y)
			if(istype(center_x, /client))
				var client:c = center_x
				center_x = c.MouseCenterX()
				center_y = c.MouseCenterY()
			delta_x = pixel_x - center_x
			delta_y = pixel_y - center_y

			//	atan2
			angle = (delta_x || delta_y) && (delta_x >= 0 ? arccos(delta_y / sqrt(delta_x * delta_x + delta_y * delta_y)) : 360 - arccos(delta_y / sqrt(delta_x * delta_x + delta_y * delta_y)))



client
	proc/MouseMoved()




//	Don't worry about the implementation below!

client
	//	This is so the mouse is detected in void areas
	//	(opacity shadow, off the edge of the map)
	New()
		. = ..()
		var obj/bg = new
		bg.icon = null
		bg.mouse_opacity = 2
		bg.screen_loc = "SOUTHWEST to NORTHEAST"
		bg.layer = -1000
		bg.name = ""
		screen += bg

	MouseEntered(o, l, c, p)
		mouse.on_map = TRUE
		MouseUpdate(params2list(p)["screen-loc"])
		..()

	MouseExited()
		mouse.on_map = FALSE
		..()

	MouseMove(o, l, c, p)
		MouseUpdate(params2list(p)["screen-loc"])
		..()

	MouseDrag(so, oo, sl, ol, sc, oc, p)
		MouseUpdate(params2list(p)["screen-loc"])
		..()

	proc
		MouseUpdate(screen_loc)
			if(!screen_loc) return
			mouse.UpdatePosition(src, screen_loc)
			mouse.UpdateDeltas(src)
			MouseMoved()

		//	These determine where the center of the screen is.
		//	By default, it halves the client's view size in pixels.
		MouseCenterX() return ViewWidthPx() / 2
		MouseCenterY() return ViewHeightPx() / 2