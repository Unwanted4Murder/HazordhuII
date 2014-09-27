builder/brewing
	icon = 'code/Woodworking/Barrel.dmi'
	skill = COOKING

	condition(mob/player/m)
		if(!m.isSubscriber)
			m.aux_output("Only subscribers can brew.")
			return
		return TRUE

	valid_loc(turf/t)
		for(var/obj/Built/Barrel/b in t)
			if(b.icon_state == "water")
				return TRUE

	spawn_product(mob/m, turf/t)
		for(var/obj/Built/Barrel/b in t)
			if(b.icon_state == "water")
				del b
				return ..()

	beer
		name = "Beer"
		icon_state = "beer"
		req = list(	/obj/Item/Farming/crop/Yeese	=	1,
					/obj/Item/Farming/crop/Huff		=	1,
					/obj/Item/Farming/crop/Kurn		=	1)
		desc = "It's what your right arm is for<br />\
				1 Yeese<br />\
				1 Huff<br />\
				1 Kurn"
		tooltipRows = 4
		built = /obj/Built/Barrel/Beer
		mat_fail(mob/m) m.aux_output("You do not have the right ingredients to make beer.")

	wine
		name = "Wine"
		icon_state = "wine"
		req = list(	/obj/Item/Farming/crop/Yeese	=	2,
					/obj/Item/Food/Berry			=	10,
					/obj/Item/Farming/seed			=	1)
		desc = "Satisfy your taste for adventure!<br />\
				2 Yeese<br />\
				10 Berry<br />\
				1 Seed"
		tooltipRows = 4
		built = /obj/Built/Barrel/Wine
		mat_fail(mob/m) m.aux_output("You do not have the right ingredients to make wine.")