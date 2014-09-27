var const/HORI = EAST  |  WEST
var const/VERT = NORTH | SOUTH

atom
	proc/width() return tile_width()
	proc/height() return tile_height()

	proc/px(p) return z && tile_width()  * (x - 1) + (p && p * width())
	proc/py(p) return z && tile_height() * (y - 1) + (p && p * height())

	movable
		width() return bound_width
		height() return bound_height

		px(p) return z && ..() + bound_x + step_x
		py(p) return z && ..() + bound_y + step_y

atom
	proc/cx() return px(0.5)
	proc/cy() return py(0.5)

	//	turf located at the center of its bounding box
	proc/cloc() return z && (locate(/turf) in bounds(cx(), cy(), 1, 1, z))

	proc/pos() return vec2(px(), py())
	proc/center() return vec2(cx(), cy())

	var tmp/pos[]

	proc/reset_pos() pos = pos()

	proc/bumped(atom/movable/bumper, bump_dir)


mob/wall_slides = TRUE

atom
	movable
		proc/set_step(sx = 0, sy = 0)
			#if PIXEL_MOVEMENT
			step_x = sx
			step_y = sy
			#endif

		proc/move_to(atom/new_loc, new_step_x = 0, new_step_y = 0, new_dir = 0)
			return Move(new_loc, new_dir, new_step_x, new_step_y)

		proc/set_loc(atom/new_loc, new_step_x = 0, new_step_y = 0)
			loc = new_loc
			#if PIXEL_MOVEMENT
			step_x = new_step_x
			step_y = new_step_y
			#endif
			reset_pos()

		proc/set_pos(px, py, z)
			if(isvec2(px))
				z = py
				py = px[2]
				px = px[1]
			if(isnull(pos)) reset_pos()
			return set_loc(locate(x || 1, y || 1, z), step_x + px - pos[1], step_y + py - pos[2])

		proc/set_center(cx, cy, z)
			if(isvec2(cx))
				z = cy
				cy = cx[2]
				cx = cx[1]
			return set_pos(cx - width()  / 2, cy - height() / 2, z)

		//	bump_dir and bumped will have reliable values right after a call to move()
		var tmp/bumped		//	what was bumped in the last move
		var tmp/bump_dir	//	direction to bumped

		//	how many pixels moved in the last move() in each axis
		var tmp/moved_h
		var tmp/moved_v

		Bump(atom/o)
			if(pixel_moving)
				var d = get_dir(src, o)
				if(d & d - 1) d = pick(d & 3, d & 12)
				bumped = o
				bump_dir = d
				o.bumped(src, get_dir(o, src))
				bump(bump_dir, o)
			..()

		var tmp/pixel_moving = FALSE
		Move()
			. = ..()
			. && !pixel_moving && reset_pos()

		//	called when move() fails in a certain direction
		proc/bump(d)

		//	will the mover slide along walls if movement fails in one axis?
		//	if not, the movement will stop at the instant of collision.
		var wall_slides = FALSE

		proc/move(v[])
			if(isnull(pos)) reset_pos()
			if(isnum(v)) v = vec2(args[1], args[2])
			if(vec2_iszero(v)) return

		#if !PIXEL_MOVEMENT
			var dh = v[1] && (v[1] > 0 ? EAST : WEST)
			var dv = v[2] && (v[2] > 0 ? NORTH : SOUTH)
			if(dh && step(src, dh))
				if(dv) step(src, dv)
				return TRUE
			if(dv && step(src, dv))
				if(dh) step(src, dh)
				return TRUE

		#else
			//	pos is the real position, with decimals included
			//	pos() is calculated only from the built-in variables
			var new_pos[] = vec2_add(pos, v)
			new_pos[1] = clamp(new_pos[1], 0, world.maxx * tile_width() - width())
			new_pos[2] = clamp(new_pos[2], 0, world.maxy * tile_height() - width())

			//	moving from the current rounded pixel position to the next
			var movement[] = vec2(round(new_pos[1] - px()), round(new_pos[2] - py()))
			var move_dir = offset2dir(movement)
			if(vec2_iszero(movement))
				pos = new_pos
				return move_dir

			var abs_movement[] = vec2(abs(movement[1]), abs(movement[2]))

			//	reset movement wrapper variables
			var pre_step_size = step_size
			step_size = max(abs_movement[1], abs_movement[2])
			pixel_moving = TRUE
			bump_dir = 0
			bumped = 0
			moved_h = 0
			moved_v = 0

			var moved = Move(loc, dir, step_x + movement[1], step_y + movement[2])

			if(bumped)
				. = 0

				//	moved without bumping horizontally (bumped vertically)
				if(!(bump_dir & HORI))
					. = move_dir & HORI
					if(wall_slides && movement[1])
						Move(loc, dir, step_x + movement[1] - moved * sign(movement[1]), step_y)

				else if(!wall_slides) reset_pos()

				//	moved without bumping vertically (bumped horizontally)
				if(!(bump_dir & VERT))
					. = move_dir & VERT
					if(wall_slides && movement[2])
						Move(loc, dir, step_x, step_y + movement[2] - moved * sign(movement[2]))

				else if(!wall_slides) reset_pos()

			//	moved without bumping anything
			else
				pos = new_pos
				. = move_dir

			if(!(bump_dir & HORI))
				moved_h = v[1]
				pos[1] = new_pos[1]

			else
				var px = px()
				moved_h = px - pos[1]
				pos[1] = px

			if(!(bump_dir & VERT))
				moved_v = v[2]
				pos[2] = new_pos[2]

			else
				var py = py()
				moved_v = py - pos[2]
				pos[2] = py

			pixel_moving = FALSE
			step_size = pre_step_size
#endif