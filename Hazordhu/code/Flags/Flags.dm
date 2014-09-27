obj
	Flag
		parent_type = /obj/Built
		icon = 'code/Flags/Flags.dmi'
		density = TRUE

		SET_TBOUNDS("15,11 to 17,13")
		pixel_y = 10
		layer = OBJ_LAYER + 2
		attackable = TRUE

		var capturable = TRUE
		var access[0]

		New()
			..()
			for(var/obj/Flag/F in loc)
				if(F == src) continue
				del F

		Human
			icon_state = "Human"
			attackable = FALSE
			Settal
				icon_state = "Settal"
				can_color = FALSE

		Orc
			icon_state = "Orc"
			attackable = FALSE

		Neutral
			icon_state = "Neutral"
			Settal
				icon_state = "Settal"
				can_color = FALSE

		Bandit_Camp
			icon_state = "Undead"
			capturable = FALSE
			can_color = FALSE