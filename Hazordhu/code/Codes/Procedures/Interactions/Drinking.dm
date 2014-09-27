
/*
	Drinking ----------------------------------------------------------------------------------------
*/
mob/proc
	has_chisel() return is_equipped(/obj/Item/Tools/Chisel)

	_chisel_ice(turf/Environment/Water/ice)
		if(istype(ice) && icon_state != "Fall" && icon_state != "chipped" && has_chisel() && !ice.is_bridged())
			used_tool()
			var save_state = ice.icon_state
			aux_output("You chip away the ice.")
			ice.icon_state = "chipped"
			spawn(300) if(get_season() == WINTER) ice.icon_state = save_state

	_drink(atom/water)
		if(!is_drinkable(water))
			if(get_season() == WINTER && water.icon_state != "chipped") _chisel_ice(water)
			return
		if(Locked) return
		if(Thirst < 1) return aux_output("You don't need to drink.")
		Locked = TRUE
		emote("begins drinking water.")
		while(Thirst > 0)
			status_overlay("thirst", 1)
			Thirst --
			sleep 1
		emote("finishes drinking water.")
		Locked = FALSE
		return TRUE

	is_drinkable(atom/o)
		if(!istype(o)) return FALSE
		if(istype(o, /turf/Environment/Water))
			if(locate(/obj/Built) in o) return FALSE
			if(!istype(o, /turf/Environment/Water/noF) && get_season() == WINTER)
				if(o.icon_state == "chipped") return TRUE
				return FALSE
			return TRUE
		if(istype(o, /obj/Built/Fountain))
			if(get_season() == WINTER) return FALSE
			return TRUE
