
/*
	Gathering ------------------------------------------------------------------------------------
*/
mob/proc
	has_hatchet() return is_equipped(/obj/Item/Tools/Hatchet)
	has_pickaxe() return is_equipped(/obj/Item/Tools/Pickaxe)
	has_knife() return is_equipped(/obj/Item/Tools/Knife)
	has_rod() return is_equipped(/obj/Item/Tools/Fishing_Rod)

	_gather(atom/movable/r)
		if(istype(r, /obj/Resource))
			var obj/Resource/R = r
			if(R.resources <= 0) return FALSE

		if(istype(r, /obj/Woodcutting) && has_hatchet()) return _chop(r)
		else if(istype(r, /obj/Woodcutting)) return _pickfruit(r)
		if(istype(r, /obj/Mining) && has_pickaxe()) return _mine(r)
		if(istype(r, /mob/Corpse) && (has_knife() || has_hatchet())) return _skin(r)
		if(is_fishable(r) && has_rod()) return _fish(r)

	_chop(obj/Woodcutting/o) if(istype(o)) return Chop(o)
	_mine(obj/Mining/o) if(istype(o)) return Mine(o)
	_skin(mob/Corpse/o) if(istype(o)) return o.Skin(src)
	_pickfruit(obj/Woodcutting/o) if(istype(o)) return o.pick_fruit(src)

	is_fishable(o)
		if(istype(o, /turf/Environment/Water))
			var turf/Environment/Water/water = o
			if(water.is_frozen())
				return FALSE
			return TRUE

		if(istype(o, /turf/Environment/Ocean))
			return FALSE

	_fish(turf/Environment/Water/o)
		used_tool()
		emote("starts fishing")
		_do_work(80)
		if(prob(40))
			emote("fails to catch anything")
		else
			emote("catches a fish")
			new /obj/Item/Food/Meat/Fish (loc)
		return TRUE