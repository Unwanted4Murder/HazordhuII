atom/movable
	var tmp/obj/Built/Boat/boat

mob/mortal
	interact(mob/player/p)
		if(KO && boat)
			if(boat.take_off(src))
				p.emote("takes the body off of the [boat]")
		else ..()

	MouseDrop(obj/Built/Boat/b)
		if(istype(b) && bounds_dist(src, usr) <= 16 && bounds_dist(src, b) <= 16)
			if(!usr.Locked && KO && b.put_on(src))
				usr.emote("puts the body on the [b]")
		..()

obj/Built/Storage
	MouseDrop(obj/Built/Boat/b)
		if(istype(b) && bounds_dist(src, usr) <= 16 && bounds_dist(src, b) <= 16)
			if(!usr.Locked && b.put_on(src))
				if(src == usr.pulling_cart)
					usr.stop_pulling_cart()
				usr.emote("puts the [src] on the [b]")
		..()

mob/Animal
	MouseDrop(obj/Built/Boat/b)
		if(istype(b) && bounds_dist(src, usr) <= 16 && bounds_dist(src, b) <= 16)
			if(!usr.Locked && ((is_harnessed() && (!rider || rider == usr)) || (locate(/obj/Item/Tailoring/Collar) in src)) && b.put_on(src))
				usr.emote("puts the [src] on the [b]")
		..()

turf/Environment/water_rock
	SET_TBOUNDS("9,9 to 24,24")
	Bumped(obj/Built/Boat/boat)
		if(istype(boat))
			boat.sink(src, "The sharp rocks damage your boat! Get to land quickly before your boat sinks!")
		..()

obj/Built
	Bridge/Cross(obj/Built/Boat/boat) return istype(boat) || ..()
	Sandstone_Bridge/Cross(obj/Built/Boat/boat) return istype(boat) || ..()
	Stone_Bridge/Cross(obj/Built/Boat/boat) return istype(boat) || ..()

var looper/boat_sink_loop = new ("sink tick", 1)

obj/Built
	Boat
		icon = 'code/Ship System/Boat.dmi'
		overlays = list(/obj/Overlays/Boat/Top, /obj/Overlays/Boat/Right, /obj/Overlays/Boat/Left, /obj/Overlays/Boat/Bottom)

		var
			tmp
				passengers[0]
				Locked

			need_paddles = TRUE
			max_passengers = 2

			speed = 4

		layer = OBJ_LAYER
		SET_STEP_SIZE(2)
		density = TRUE

		map_loaded()
			..()
			density = TRUE
			if(icon_state == "damage")
				sink(, "The boat is sinking! Repair it quickly!")

		Cross(mob/m)
			return can_ride(m) || ..()

		Del()
			if(passengers.len)
				for(var/obj/Built/b in passengers) fall_off(b)
				for(var/mob/m in passengers) fall_off(m)
			..()

		Move()
			. = ..()
			. && update_passengers()

		interact(mob/humanoid/m)
			return m._fix_boat(src) || m._exit_boat(src) || m._enter_boat(src)

		proc/can_ride(o)
			if(is_mortal(o)) return TRUE
			if(istype(o, /obj/Built/Storage/Cart)) return TRUE
			if(istype(o, /obj/Built/Storage/Chest)) return TRUE

		proc/can_drive(o)
			if(is_player(o)) return TRUE

		proc/moved()
			update_passengers()

		proc/update_passengers()
			if(passengers.len < 1) return
			var mob/a = passengers[1]
			if(a)
				var dx, dy
				switch(dir)
					if(NORTH)
						dy += 24
					if(SOUTH)
						dy -= 4
					if(EAST, NORTHEAST, SOUTHEAST)
						dx += 13
						dy += 10
					if(WEST, NORTHWEST, SOUTHWEST)
						dx -= 13
						dy += 10
				#if PIXEL_MOVEMENT
				a.set_loc(loc, step_x, step_y)
				a.step_x += dx
				a.step_y += dy
				#else
				a.loc = loc
				a.pixel_x = dx
				a.pixel_y = dy
				#endif
				a.update_layer()

			if(passengers.len < 2) return
			var mob/b = passengers[2]
			if(b)
				var dx, dy
				switch(dir)
					if(NORTH)
						dy += 14
					if(SOUTH)
						dy += 8
					if(EAST, NORTHEAST, SOUTHEAST)
						dx -= 4
						dy += 10
					if(WEST, NORTHWEST, SOUTHWEST)
						dx += 4
						dy += 10
				#if PIXEL_MOVEMENT
				b.set_loc(loc, step_x, step_y)
				b.step_x += dx
				b.step_y += dy
				#else
				b.loc = loc
				b.pixel_x = dx
				b.pixel_y = dy
				#endif
				b.update_layer()

		interact_right(mob/m)
			return repair(m)

		var damaged = FALSE
		proc/repair(mob/humanoid/m)
			if(damaged && !(m in passengers))
				var hammer = m.has_hammer()
				var board = locate(/obj/Item/Wood/Board) in m
				var nail = locate(/obj/Item/Metal/Nails) in m
				if(!(hammer && board && nail)) m.aux_output("You need to hammer a board and a nail on to the boat to fix it!")
				else if(is_water(cloc())) m.aux_output("You need to be on land to repair the boat!")
				else
					del board
					del nail
					m.emote("starts repairing the damaged boat")
					m._do_work(30)
					m.emote("finishes repairing the boat")
					boat_sink_loop.remove(src)
					return TRUE

		var tmp/leaking
		proc/sink(atom/sinker, message)
			if(damaged) return
			passengers << message
			boat_sink_loop.add(src)

		proc/sink_tick_start()
			leaking = 0

		proc/sink_tick_stop()
			icon_state = ""
			damaged = FALSE
			leaking = 0

		proc/sink_tick()
			damaged = TRUE
			icon_state = "damage"

			if(!is_water(cloc()))
				leaking = 0

			else if(++leaking > 150)
				ohearers(src) << "<b>The [src] sinks</b>"
				for(var/atom/a in passengers)
					if(is_mortal(a)) fall_off(a)
					else if(isobj(a)) del a
				del src

		proc/on_land()
			var turf/Environment/c = cloc()
			if(!is_water(c)) return TRUE
			if(c.is_frozen()) return TRUE
			if(c.is_bridged()) return TRUE
			return FALSE

		proc/get_on(atom/movable/m) if(istype(m))
			var mob/humanoid/h = is_humanoid(m) && m
			if(h && h.mount)
				if(!h.dismount_animal())
					return FALSE

			var mob/Animal/a = is_animal(m) && m
			if(a && a.rider)
				if(!a.rider.dismount_animal())
					return FALSE

			if(add_rider(m))
				if(is_player(m) && damaged)
					var mob/player/p = m
					p.aux_output("The [src] is damaged! It will only last 15 seconds on the water.")
				return TRUE

		proc/get_off(atom/movable/m) if(istype(m))
			if(on_land())
				if(remove_rider(m))
					m.set_loc(cloc())
					return TRUE

		proc/put_on(atom/movable/o) if(istype(o))
			return get_on(o)

		proc/take_off(atom/movable/o) if(istype(o))
			return get_off(o)

		proc/fall_off(atom/movable/o) if(istype(o))
			if(remove_rider(o))
				if(!on_land())
					if(is_mortal(o))
						var mob/mortal/m = o
						m.die("drowning")
				return TRUE

		proc/remove_rider(atom/movable/o) if(istype(o))
			if(o.boat == src && (o in passengers))
				o.boat = null
				o.pixel_x = 0
				o.pixel_y = 0
				o.set_loc(loc)

				passengers -= o

				if(is_humanoid(o))
					var mob/humanoid/h = o
					h.Gethair()
				return TRUE

		proc/add_rider(atom/movable/o) if(istype(o))
			if(!o.boat && !(o in passengers))
				if(passengers.len >= max_passengers)
					var mob/player/p = is_player(o) && o
					if(p) p.aux_output("The [src] can't hold any more passengers!")
					return

				o.boat = src
				passengers += o
				update_passengers()
				return TRUE

		proc/get_driver()
			for(var/mob/humanoid/m in passengers)
				if(m.has_paddle())
					return m

		Canoe
			icon = 'Canoe.dmi'
			overlays = list(/obj/Overlays/Canoe/Top,/obj/Overlays/Canoe/Right,/obj/Overlays/Canoe/Left,/obj/Overlays/Canoe/Bottom)

obj/Overlays
	layer = OBJ_LAYER
	Boat
		icon='code/Ship System/Boat.dmi'
		Top
			icon_state = "Top"
			pixel_y = 32
		Right
			icon_state = "Right"
			pixel_x = 32
		Left
			icon_state = "Left"
			pixel_x = -32
		Bottom
			icon_state = "Bottom"
			pixel_y = -32
	Canoe
		icon='code/Ship System/Canoe.dmi'
		Top
			icon_state = "Top"
			pixel_y = 32
		Right
			icon_state = "Right"
			pixel_x = 32
		Left
			icon_state = "Left"
			pixel_x = -32
		Bottom
			icon_state = "Bottom"
			pixel_y = -32

mob/player
	PostLogin()
		..()
		if(!GodMode)
			if(is_water(loc))
				var turf/Environment/Water/w = loc
				var obj/Built/Boat/b = locate(/obj/Built/Boat) in loc
				if(b && !b.add_rider(src)) b = null
				if(!b && !(locate(/obj/Built) in loc) && !(istype(w) && w.is_frozen()))
					die("drowning")

	PreLogout()
		if(boat) boat.remove_rider(src)
		..()

obj/Item/Tools/Paddle
	icon = 'code/Ship System/Paddle.dmi'