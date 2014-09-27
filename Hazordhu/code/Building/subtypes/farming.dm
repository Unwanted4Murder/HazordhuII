builder/farming
	main_tool = /obj/Item/Tools/Shovel
	skill = FARMING
	icon = 'code/Farming/Farming.dmi'

	valid_loc(turf/t)
		if(locate(/obj/Built/Path/Farm) in t)
			if(locate(/obj/Item/Farming/plant) in t)
				return FALSE
			return TRUE

	//	plant grows 15 seconds faster per farming level
	crafted(obj/Item/Farming/plant/plant, mob/player/farmer)
		var level = farmer.skill_level("farming")
		plant.growth_rate += (level - 1) * 0.25

	karet
		name = "Karet"
		icon_state = "Karet"

		desc = "Plants a tasty Karet seed<br />\
				1 Karet Seed"
		tooltipRows = 2

		req = list(	SEED_KARET	=	1)
		built = /obj/Item/Farming/plant/Karet

	lettif
		name = "Lettif"
		icon_state = "Lettif"
		desc = "Plants a cool Lettif seed<br>1 Lettif Seed"
		req = list(	SEED_LETTIF	=	1)
		built = /obj/Item/Farming/plant/Lettif

	shurgercane
		name = "Shurgercane"
		icon_state = "Shurgercane"
		desc = "Plants a sweet Shurgercane seed<br>1 Shurgercane Seed"
		req = list(	SEED_SHURGERCANE	=	1)
		built = /obj/Item/Farming/plant/Shurgercane

	tumeta
		name = "Tumeta"
		icon_state = "Tumeta"

		desc = "Plants a delicious Tumeta seed<br />\
				1 Tumeta Seed"
		tooltipRows = 2

		req = list(	SEED_TUMETA	=	1)
		built = /obj/Item/Farming/plant/Tumeta

	phluf
		name = "Phluf"
		icon_state = "Phluf"

		desc = "Plants a useful Phluf seed<br />\
				1 Phluf Seed"
		tooltipRows = 2

		req = list(	SEED_PHLUF	=	1)
		built = /obj/Item/Farming/plant/Phluf

	kurn
		name = "Kurn"
		icon_state = "Kurn"

		desc = "Plants a delectable Kurn seed<br />\
				1 Kurn Seed"
		tooltipRows = 2

		req = list(	SEED_KURN	=	1)
		built = /obj/Item/Farming/plant/Kurn

	huff
		name = "Huff"
		icon_state = "Huff"

		desc = "Plants a tempting Huff seed<br />\
				1 Huff Seed"
		tooltipRows = 2

		req = list(	SEED_HUFF	=	1)
		built = /obj/Item/Farming/plant/Huff

	puteta
		name = "Puteta"
		icon_state = "Puteta"

		desc = "Plants an appealing Puteta seed<br />\
				1 Puteta Seed"
		tooltipRows = 2

		req = list(	SEED_PUTETA	=	1)
		built = /obj/Item/Farming/plant/Puteta

	murshum
		name = "Murshum"
		icon_state = "Murshum"

		desc = "Plants a Murshum seed. They only grow underground!<br />\
				1 Murshum"
		tooltipRows = 2

		req = list(	SEED_MURSHUM =	1)
		built = /obj/Item/Farming/plant/Murshum

	yeese
		name = "Yeese"
		icon_state = "Yeese"

		desc = "Plants a Yeese seed. They only grow underground!<br />\
				1 Yeese"
		tooltipRows = 2

		req = list(	SEED_YEESE	=	1)
		built = /obj/Item/Farming/plant/Yeese