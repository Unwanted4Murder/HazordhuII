var looper/fuel_loop = new ("fuel tick", 1)

obj/Item
	MouseDrop(obj/Built/to_fuel)
		if(loc == usr && istype(to_fuel) && bounds_dist(usr, to_fuel) <= 16)
			if(to_fuel.add_fuel(usr, src))
				return
		..()

obj/Built
	var takes_fuel
	var fuel_life
	var fuel_with_tongs = TRUE
	firepit
		fuel_with_tongs = FALSE
		fuel_time(o)
			. = ..()
			if(.) return . + 100

		fuel_tick_stop()
			..()
			new /obj/Item/Coal (loc)
			del src

	var lit_state = "lit"
	var unlit_state = ""

	var lit_brightness = 4

	New()
		..()
		if(takes_fuel)
			if(fuel_life)
				burning()
			else icon_state = unlit_state

	proc/burning()
		fuel_loop.add(src)

	proc/fuel_tick_start()
		icon_state = lit_state
		set_light(lit_brightness)

	proc/fuel_tick_stop()
		icon_state = unlit_state
		set_light(0)

	proc/fuel_tick()
		if(fuel_life <= 0)
			fuel_life = 0
			fuel_loop.remove(src)
		else
			fuel_life --
			if(can_cook)
				cook_tick()

	proc/fuel_time(o)
		if(istype(o, /obj/Item/Wood/Log)) return 600
		if(istype(o, /obj/Item/Wood/Board)) return 400
		if(istype(o, /obj/Item/Coal)) return 300
		return FALSE

	proc/add_fuel(mob/humanoid/m, obj/Item/fuel)
		if(!takes_fuel) return

		var fuel_time = fuel_time(fuel)
		if(!fuel_time) return

		if(fuel_with_tongs)
			if(!m.has_tongs() && !m.equip(/obj/Item/Tools/Tongs)) return
			m.used_tool()

		if(fuel_life)
			m.aux_output("You add [fuel] to the [src].")
		else m.aux_output("You light the [src] with [fuel].")

		fuel_life += fuel_time
		m.lose_item(fuel)

		burning()
		return TRUE