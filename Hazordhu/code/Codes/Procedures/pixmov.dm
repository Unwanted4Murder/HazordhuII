//	return values of movable.move()
var const
	HORI = 12
	VERT =  3

atom
	//	2D position coordinate (center of the bounding box)
	var pos[]
	proc/pos() return vec2(cx(), cy())

	movable
		//	decimal part of fractional movements (shouldn't be touched)
		var _dec[2]

		var tmp/px, tmp/py

		//	d = displacement (vector)
		proc/move(d[])
			if(!istype(d)) d = args

		#if PIXEL_MOVEMENT
			if(density && (abs(d[1]) > bound_width || abs(d[2]) > bound_height))
				d = vec2_scale(d, 0.5)
				return move(d) | move(d)

			var di[] = vec2(round(d[1]), round(d[2]))
			_dec = vec2_add(_dec, vec2_sub(d, di))

			while(_dec[1] >  0.5) {_dec[1]--; di[1]++}
			while(_dec[1] < -0.5) {_dec[1]++; di[1]--}
			while(_dec[2] >  0.5) {_dec[2]--; di[2]++}
			while(_dec[2] < -0.5) {_dec[2]++; di[2]--}

			. = 0
			var move_dir = offset2dir(di)
			if(d[1] && !di[1] || step(src, move_dir & HORI, abs(di[1]))) . |= HORI
			if(d[2] && !di[2] || step(src, move_dir & VERT, abs(di[2]))) . |= VERT
			if(.) pos = pos()
		#endif


atom
	proc
		px() return (x - 1) * 32
		py() return (y - 1) * 32
		cx() return px() + 16
		cy() return py() + 16

	movable
	#if PIXEL_MOVEMENT
		px() return ..() + step_x + bound_x + _dec[1]
		py() return ..() + step_y + bound_y + _dec[2]
		cx() return px() + bound_width  / 2
		cy() return py() + bound_height / 2
	#endif

		//	turf located at the center of its bounding box
		proc/cloc() return loc && (locate(/turf) in bounds(cx(), cy(), 1, 1, z))

		proc/set_step(sx, sy)
		#if PIXEL_MOVEMENT
			if(isnull(sx)) sx = step_x
			if(isnull(sy)) sy = step_y
			step_x = sx
			step_y = sy
		#endif

atom/movable
	proc/bounds_step(dir, dist = 16)
		if(!loc) return
		if(isnull(dir)) dir = src.dir

		var px = px()
		var py = py()
		var width
		var height

		if(dir & EAST)
			if(!dist) dist = bound_width
			width = dist
			height = bound_height
			px += bound_width

		if(dir & WEST)
			if(!dist) dist = bound_width
			width = dist
			height = bound_height
			px -= dist

		if(dir & NORTH)
			if(!dist) dist = bound_height
			width = bound_width
			height = dist
			py += bound_height + 1

		if(dir & SOUTH)
			if(!dist) dist = bound_height
			width = bound_width
			height = dist
			py -= dist

		return bounds(px, py, width, height)