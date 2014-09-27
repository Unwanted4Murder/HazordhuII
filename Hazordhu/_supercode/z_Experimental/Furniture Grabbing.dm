//	variables

mob
	var tmp/obj/Built/dragging_built

obj/Built
	var tmp/can_drag = FALSE	//	can players drag this around?
	var secured = FALSE			//	has this been secured, made unable to be dragged around?
	var tmp/min_draggers = 1	//	if this can be dragged, it needs this many people to do so
	var tmp/draggers[]			//	a list of people dragging this

	var can_rotate = FALSE		//	can players rotate this?

//	procs and functionality
#if FURN_GRAB
mob
	can_interact() return !dragging_built && ..()

	is_running() return !dragging_built && ..()

	key_down(k)
		if(k == "g")
			if(boat || mount)
				aux_output("You can't do that right now.")
				return

			if(dragging_built)
				ungrab_built()

			else
				for(var/obj/Built/o in front(2))
					if(o.can_drag())
						if(grab_built(o))
							return
		else ..()

	player/PreLogout()
		if(dragging_built) ungrab_built()
		..()

	proc/grab_built(obj/Built/o)
		if(dragging_built) return
		if(length(o.draggers))
			return aux_output("[o] is already being dragged.")
		aux_output("You start dragging \the [o].")
		if(!o.draggers)
			o.draggers = list(src)
		else o.draggers += src
		dragging_built = o
		return TRUE

	proc/ungrab_built()
		if(!dragging_built) return
		aux_output("You let go of \the [dragging_built].")
		if(dragging_built.draggers.len == 1)
			dragging_built.draggers = null
		else dragging_built.draggers -= src
		dragging_built = null
		return TRUE

obj/Built
	Cross(mob/m)
		if(istype(m) && src == m.dragging_built)
			step(src, m.dir, m.step_size)
		return ..()

	proc/can_drag()			//	here for conditional-ness
		return can_drag

	proc/be_secured(mob/securer)
		if(secured) return
		secured = TRUE
		return TRUE

	Chair/can_drag = TRUE
	Stool/can_drag = TRUE
	Target/can_drag = TRUE
	Nest/can_drag = TRUE
/*
	Anvil/can_drag = TRUE
	Forge/can_drag = TRUE
	Barrel/can_drag = TRUE
	Bed/can_drag = TRUE
	Bookshelf/can_drag = TRUE
	Cauldron/can_drag() return !filled && ..()
	Garbage/can_drag = TRUE
	Grinding_Platform/can_drag = TRUE
	Grinding_Stone/can_drag = TRUE
	Oven/can_drag = TRUE
	firepit/can_drag = TRUE
*/
#endif

mob
	proc/rotate_built(obj/Built/o)
		if(o.can_rotate)
			o.be_rotated(src)

obj/Built
	proc/be_rotated(mob/rotator)
		set_dir(turn(dir, 90))

obj/Built
	Chair
		can_rotate = TRUE
		interact_right(mob/m) m.rotate_built(src)
		set_dir()
			..()
			update_layer()
		update_layer()
			if(dir == NORTH)
				bottom_offset = -4
			else bottom_offset = 0
			..()

	Counter
		can_rotate = TRUE
		interact_right(mob/m) if(dirdiff(dir, get_dir(src, m)) == 90) m.rotate_built(src)

		SET_TBOUNDS("1,9 to 32,18")
		set_dir()
			..()
			if(dir & 3)
				SET_TBOUNDS("1,9 to 32,18")
			else SET_TBOUNDS("8,1 to 25,32")

		map_loaded()
			..()
			set_dir(dir)

	Sink/can_rotate = FALSE

	Target
		can_rotate = TRUE
		interact_right(mob/m) m.rotate_built(src)

	Bed
		can_rotate = TRUE
		interact(mob/m) m.rotate_built(src)
		set_dir()
			..()
			if(!loc) return
			for(var/obj/Item/Tailoring/t in obounds())
				if(istype(t, /obj/Item/Tailoring/Mattress) || istype(t, /obj/Item/Tailoring/Blanket) || istype(t, /obj/Item/Tailoring/Pillow))
					t.dir = dir