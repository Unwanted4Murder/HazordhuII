var const
	footprint_life = HOUR / 2

turf
	proc/gets_footprint()
	Environment
		Grass/gets_footprint()		return (get_season() == WINTER && !(locate(/obj/Built) in src))
		Grass/jungle/gets_footprint() return FALSE
		Riverbank/gets_footprint()	return (get_season() == WINTER && !(locate(/obj/Built) in src))
		Snowy_Riverbank/gets_footprint()		return !(locate(/obj/Built) in src)
		Sand/gets_footprint()		return !(locate(/obj/Built) in src)
		Desert/gets_footprint()		return !(locate(/obj/Built) in src)
		Snow/gets_footprint()		return !(locate(/obj/Built) in src)

atom/movable
	var footprint_state
	proc/footprint_state() return footprint_state

	proc/gives_footprint() return footprint_state()
	proc/make_footprint()
		var turf/t = loc
		if(isturf(t) && gives_footprint() && t.gets_footprint())
			for(var/obj/footprint/f in obounds(src))
				return

				if(f.stale) del f
				else return

			new /obj/footprint (src)

mob
	Animal/footprint_state() return name
	NPC/Baby/footprint_state = "Baby"

	humanoid/gives_footprint()
		if(GodMode) return FALSE
		if(mount) return FALSE
		if(boat) return FALSE
		return TRUE

	title/gives_footprint() return FALSE

	Move()
		. = ..()
		if(.) make_footprint()

obj
	Built/Storage/Cart
		gives_footprint() return TRUE
		footprint_state = "Cart"


obj/footprint
	icon = 'code/Icons/Footprint.dmi'
	layer = TURF_LAYER + 0.8

	New(atom/movable/m)
		printer = m
		icon_state = m.footprint_state()
		set_loc(m.loc, m.step_x, m.step_y - 8)
		dir = m.dir
		spawn(footprint_life + 600 * randn(-3, 3))
			set_loc()

	var tmp/printer
	var stale = FALSE
	Uncrossed(atom/movable/o)
		if(o == printer)
			stale = TRUE
			SET_BOUNDS(8, 8, 16, 16)
		..()