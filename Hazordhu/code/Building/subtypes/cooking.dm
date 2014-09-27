builder/cooking
	main_tool = /obj/Item/Tools/Spoon
	skill = COOKING
	var container // pot or pan

	condition(mob/m)
		. = 0
		if(!m.loc) return
		var/obj/Built/Range/range = locate(/obj/Built/Range) in obounds(m, 16)
		if(!range)
			m.aux_output("You need to be by a range.")
		else if(range.icon_state != "Cook lit")
			m.aux_output("The range needs to be lit.")
		else if(range.container != container)
			if(container == /obj/Item/Metal/Pot)
				m.aux_output("You need a pot on the range to cook this.")
			else if(container == /obj/Item/Tools/Pan)
				m.aux_output("You need a pan on the range to cook this.")
		else . = 1

	stew
		name = "Stew"
		icon = 'code/Masonry/Bowl.dmi'
		icon_state = "Stew"

		desc = "Not grand but satisfying<br />\
				2 Diced Karets<br />\
				2 Diced Putetas<br />\
				1 Meat<br />\
				1 Bowl of Water"
		tooltipRows = 5

		req = list(	/obj/Item/Food/Prep/Diced/Karet		=	2,
					/obj/Item/Food/Prep/Diced/Puteta	=	2,
					/obj/Item/Food/Meat					=	1,
					/obj/Item/Bowl/Water				=	1)
		built = /obj/Item/Bowl/Food/Stew

		container = /obj/Item/Metal/Pot

	tumeta_sauce
		name = "Tumeta Sauce"
		icon = 'code/Masonry/Bowl.dmi'
		icon_state = "Tumeta Sauce"

		desc = "Sauce made from a Tumeta!<br />\
				3 Tumetas<br />\
				1 Bowl"
		tooltipRows = 2

		req = list(	/obj/Item/Farming/crop/Tumeta	=	3,
					/obj/Item/Bowl					=	1)
		built = /obj/Item/Bowl/Food/Tumeta_Sauce

		container = /obj/Item/Metal/Pot

	alfredo_sauce
		name = "Alfredo Sauce"
		icon = 'code/Masonry/Bowl.dmi'
		icon_state = "Alfredo Sauce"

		desc = "A creamy and rich sauce<br />\
				1 Bucket of Mylk<br />\
				1 Cheese<br />\
				1 Huff<br />\
				1 Bowl"
		tooltipRows = 5

		req = list(	/obj/Item/Bucket/Mylk			=	1,
					/obj/Item/Food/Cooking/Cheese	=	1,
					/obj/Item/Farming/crop/Huff		=	1,
					/obj/Item/Bowl					=	1)
		built = /obj/Item/Bowl/Food/Alfredo_Sauce
		extras = list(/obj/Item/Bucket)

		container = /obj/Item/Metal/Pot

	pasta
		name = "Pasta"
		icon = 'code/Masonry/Plate.dmi'
		icon_state = "Pasta"

		desc = "Noodles that would go well with sauce<br />\
				1 Dough<br />\
				1 Plate"
		tooltipRows = 3

		req = list(	/obj/Item/Food/Prep/Dough	=	1,
					/obj/Item/Plate				=	1)
		built = /obj/Item/Plate/Pasta

		container = /obj/Item/Metal/Pot

	bacon
		name = "Bacon"
		icon = 'code/Cooking/Recipes.dmi'
		icon_state = "bacon"

		desc = "Tasty, crispy meat <br />\
				1 Meat"
		tooltipRows = 2

		req = list(	/obj/Item/Food/Meat	=	1)
		built = /obj/Item/Food/Cooking/Bacon
		build_amount = 3

		container = /obj/Item/Tools/Pan

	fried_egg
		name = "Fried Egg"
		icon = 'code/Masonry/Plate.dmi'
		icon_state = "Fried Egg"

		desc = "An egg that has been fried on a range<br />\
				1 Egg<br />\
				1 Plate"
		tooltipRows = 3

		req = list(	/obj/Item/Food/Egg	=	1,
					/obj/Item/Plate		=	1)
		built = /obj/Item/Plate/Fried_Egg

		container = /obj/Item/Tools/Pan

	cheese
		name = "Cheese"
		icon = 'code/Cooking/Recipes.dmi'
		icon_state = "cheese"

		desc = "A mur's love as a solid<br />\
				1 Bucket of Mylk<br />\
				1 Yeese"
		tooltipRows = 3

		req = list(	/obj/Item/Bucket/Mylk			=	1,
					/obj/Item/Farming/crop/Yeese	=	1)
		built = /obj/Item/Food/Cooking/Cheese
		extras = list(/obj/Item/Bucket)

		container = /obj/Item/Metal/Pot