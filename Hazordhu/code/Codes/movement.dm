var looper/move_loop = new ("move tick")

client
	set_macros()
		keys = list()
		set_keys()
		move_loop.add(mob)
		return ..()

	set_keys()
		. = ..()
		keys.Add("w", "s", "d", "a", "north", "south", "east", "west")
		keys.Add("e", "x", "g", "tab", "alt", "ctrl", "shift", "r")
		keys.Add("escape", "return", "space")
		keys.Add("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=")

	proc/has_key()
		if(istype(keys))
			for(var/k in args)
				if(keys[k])
					return TRUE

	//	Disable normal movement
	Move()

mob
	var tmp/mob/dragging_body
	proc/start_dragging(mob/m)
		if(dragging_body)
			stop_dragging()

		if(bounds_dist(src, m) < 8)
			dragging_body = m
			emote("starts dragging the body")

	proc/stop_dragging()
		if(dragging_body)
			walk(dragging_body, 0)
			dragging_body = null
			emote("stops dragging the body")

	MouseDrop(mob/m)
		if(m == usr)
			if(Dead || KO)
				if(usr.dragging_body)
					if(usr.dragging_body == src)
						usr.stop_dragging()
						return
					usr.stop_dragging()
				usr.start_dragging(src)
		..()

	var tmp/running
	proc/moved(d, cause)
	var tmp/moved

	player/moved(d, cause)
		if(cause == src)
			if(running && !GodMode)
				lose_stamina(0.05)
		..()

	var tmp/_next_move

	proc/move_tick()
		moved = FALSE

#if PIXEL_MOVEMENT
		var move_speed = move_speed() * 30 / global.fps
		var move_input[] = move_input()
		if(!vec2_iszero(move_input)) move_input = vec2_scale(move_input, move_speed)
#else
		if(world.time < _next_move) return
		var move_input[] = move_input()
		if(!vec2_iszero(move_input))
			var diagonal = move_input[1] && move_input[2]
			var distance_factor = diagonal ? sqrt(2) : 1
			glide_size = round(distance_factor * move_speed(), 1)
			var move_delay =  32 * distance_factor * world.tick_lag / (glide_size || 1)
			_next_move = world.time + move_delay
#endif

		var d = move_input && offset2dir(move_input)

		if(dragging_body)
			if(!(dragging_body.KO || dragging_body.Dead) || bounds_dist(src, dragging_body) > 8)
				stop_dragging()
			else step_to(dragging_body, src, 0, step_size)

		if(dragging_built)
			move_input = vec2_scale(move_input, 0.5)
			SET_STEP_SIZE(step_size * 0.5)
			var old_dir = dragging_built.dir
			dragging_built.step_size = step_size

			//	do some kind of movement
			//	if the object fails to move, so does the dragger
			//	if the dragger fails to move, so does the object

			dragging_built.dir = old_dir

		var obj/Built/driving_boat
		if(boat)
			var driver = boat.get_driver()

			if(src == driver || !driver)
				if(!boat.on_land())
				#if PIXEL_MOVEMENT
					var water_force[] = vec2_zero
					if(is_water(boat.cloc()))
						if(prob(10)) water_force[1] = pick(-1, 1)
						if(prob(10)) water_force[2] = pick(-1, 1)
					for(var/turf/Environment/Water/w in boat.locs)
						switch(w.icon_state)
							if("Fall") water_force[2] = -5
							if("river") switch(w.dir)
								if(1) water_force[2] =  1
								if(2) water_force[2] = -1
								if(4) water_force[1] =  1
								if(8) water_force[1] = -1
					boat.Move(boat.loc, boat.dir, boat.step_x + water_force[1], boat.step_y + water_force[2])
				#else
					for(var/turf/Environment/Water/w in boat.locs)
						if(w.icon_state == "Fall")
							step(boat, SOUTH)
							break
				#endif

			if(src == driver)
				driving_boat = boat
			else return

		if(d)
			if(has_key("ctrl"))
				dir = d
				return

			var atom/movable/mover = src
			if(mount) mover = mount
			if(driving_boat) mover = driving_boat

			. = mover.move(move_input)

			if(!(combat_mode && blocking && client && !client.mouse.over))
				if(is_cardinal(d) || dirdiff(d, mover.dir) > 45)
					mover.dir = d

			if(.)
				moved = TRUE

				if(mover != src)
					dir = mover.dir
					step_size = mover.step_size
					set_loc(mover.loc, mover.step_x, mover.step_y)

					moved(., mover)

					update_layer()

					if(mount)
						if(dir == SOUTH)
							mount.layer = layer + 1e-5
						else mount.layer = layer - 1e-5

				if(hascall(mover, "moved"))
					call(mover, "moved")(., src)

				if(pulling_cart)
					var mob/puller = mount || src
					var dist = bounds_dist(puller, pulling_cart)
					if(dist > 32) stop_pulling_cart()
					else if(dist > 4) step_to(pulling_cart, puller, 0, step_size)

			if(mount) dir = mount.dir

			if(dragging_built) dir = get_dir(src, dragging_built)

			//	boat drivers face the rear
			if(driving_boat) dir = turn(driving_boat.dir, 180)

			if(dragging_body) dir = get_dir(src, dragging_body) || dir

			if(dragging_built)
				if(moved_h)
					var dh = d & HORI
					if(!step(dragging_built, dh, moved_h))
						var dx = dh == 8 ? moved_h : -moved_h
						Move(loc, dir, step_x + dx, step_y)

				if(moved_v)
					var dv = d & VERT
					if(!step(dragging_built, dv, moved_v))
						var dy = dv == 2 ? moved_v : -moved_v
						Move(loc, dir, step_x, step_y + dy)

	proc/has_key()
		if(client)
			return client.has_key(arglist(args))

	proc/can_move() return !Locked

	proc/move_input()
	player/move_input()
		return can_move() && vec2(has_key("east" , "d") - has_key("west" , "a"), has_key("north", "w") - has_key("south", "s"))

	//	Holding shift generally makes you go faster.
	proc/is_running()
		var mob/humanoid/h = src
		if(istype(h))
			if(h.mount || h.boat) return FALSE
			if(h.pulling_cart) return FALSE
			if(h.dragging_body) return FALSE

		if(has_key("shift")) if(Stamina > 5) return TRUE

	proc/move_speed()

mob
#if PIXEL_MOVEMENT
	var walk_speed = 2
	var run_speed = 4
	var god_speed = 32
#else
	var walk_speed = 2
	var run_speed = 4
	var god_speed = 32
#endif
	move_speed()
		if(mount)
			if(!has_key("shift"))
				return min(walk_speed, mount.mountSpeed)
			else return mount.mountSpeed

		else if(boat)
			if(has_key("shift") && !boat.on_land())
				return boat.speed
			else return walk_speed

		else
			if(GodMode)
				if(has_key("shift"))
					return god_speed
				return walk_speed

			else
				running = is_running()
				if(running)
					return run_speed
				else return walk_speed