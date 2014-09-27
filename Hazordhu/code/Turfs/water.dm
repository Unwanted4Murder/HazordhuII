proc/iswater(turf/Environment/t) return istype(t) && t.is_water
proc/islava(turf/Environment/t) return istype(t) && t.is_lava
proc/is_water(t) return iswater(t)
proc/is_lava(t) return islava(t)

turf/Environment
	var is_water = FALSE
	var is_lava = FALSE

	var tmp/is_deep_water = FALSE

	proc/is_frozen() return is_water && icon == 'code/Turfs/ice.dmi' && icon_state != "chipped"
	proc/is_bridged() return locate(/obj/Built/Floors) in src
	proc/is_flowing() return icon_state == "river"

	Lava/is_lava = TRUE

	Enter(o)
		if(!is_water && !is_lava) return ..()
		if(istype(o, /ray/interact)) return TRUE
		if(istype(o, /mob/title)) return FALSE

		density = TRUE

		if(is_bridged())// || is_water && icon == 'code/turfs/water.dmi' && (istype(o, /obj/Built/Boat) || (is_frozen() && icon_state != "Fall")))
			density = FALSE
			return ..()

		else if(is_frozen() && icon_state != "Fall")
			density = FALSE
			return ..()

		else if(is_water && istype(o, /obj/Built/Boat))
			if(icon == 'code/turfs/ice.dmi' && icon_state == "Fall")
				return FALSE
			density = FALSE
			return ..()

		else if(is_humanoid(o))
			var mob/humanoid/m = o

			if(m.GodMode)
				return TRUE

			else if(m.boat)
				density = FALSE
				return ..()

			else if(m.Waterwalk && icon == 'code/Turfs/Water.dmi' && icon_state != "Fall")
				density = FALSE
				return ..()

		else return ..()

	Water
		is_water = TRUE
		is_deep_water = null

		interact(mob/m) m._gather(src)
		interact_right(mob/m) m._drink(src)

		Entered(mob/mortal/m)
			if(istype(m) && icon_state == "chipped")
				if(m.GodMode) return
				if(prob(50)) m.die("falling through the ice")

	Ocean
		is_water = TRUE
		is_deep_water = null

	water_rock
		parent_type = /obj
	//	is_water = TRUE

	proc/is_deep_water()
		if(isnull(is_deep_water))
			is_deep_water = FALSE
			if(is_water)
				is_deep_water = TRUE
				var nearby[] = nearby_turfs(2)
				for(var/index in 1 to nearby.len)
					var turf/Environment/t = nearby[index]
					if(!t.is_water)
						is_deep_water = FALSE
						break
		return is_deep_water