builder/food_prep
	main_tool = /obj/Item/Tools/Spoon
	skill = COOKING

	condition(mob/m)
		if(!m.loc) return
		var obj/Built/Counter/counter = locate(/obj/Built/Counter) in obounds(m, 16)
		if(!counter)
			m.aux_output("You need to be by a counter.")
			return FALSE
		return TRUE

	dough
		name = "Dough"
		icon = 'code/Cooking/Recipes.dmi'
		icon_state = "dough"

		desc = "Used for making pastries<br />\
				1 Bowl of Flour<br />\
				1 Bucket of Water<br />\
				3 Yeese"
		tooltipRows = 4

		req = list(	/obj/Item/Bowl/Flour			=	1,
					/obj/Item/Bucket/Water			=	1,
					/obj/Item/Farming/crop/Yeese	=	3)
		built = /obj/Item/Food/Prep/Dough
		extras = list(	/obj/Item/Bowl,
						/obj/Item/Bucket)

	sandwich
		name = "Sandwich"
		icon = 'code/Cooking/Recipes.dmi'
		icon_state = "sandwich"

		desc = "Food between two slices of bread<br />\
				1 Bread<br />\
				1 Chopped Lettif<br />\
				1 Meat<br />\
				1 Cheese"
		tooltipRows = 5

		req = list(	/obj/Item/Food/Cooking/Bread		=	1,
					/obj/Item/Food/Prep/Chopped_Lettif	=	1,
					/obj/Item/Food/Meat					=	1,
					/obj/Item/Food/Cooking/Cheese		=	1)
		built = /obj/Item/Food/Cooking/Sandwich

	tumeta_pasta
		name = "Tumeta Pasta"
		icon = 'code/Masonry/Plate.dmi'
		icon_state = "Pasta Tumeta"

		desc = "Pasta covered with Tumeta Sauce!<br />\
				1 Plate of Pasta<br />\
				1 Bowl of Tumeta Sauce"
		tooltipRows = 3

		req = list(	/obj/Item/Plate/Pasta				=	1,
					/obj/Item/Bowl/Food/Tumeta_Sauce	=	1)
		built = /obj/Item/Plate/Tumeta_Pasta

		extras = list(/obj/Item/Bowl)

	alfredo_pasta
		name = "Alfredo Pasta"
		icon = 'code/Masonry/Plate.dmi'
		icon_state = "Pasta Alfredo"

		desc = "Pasta covered with Alfredo Sauce!<br />\
				1 Plate of Pasta<br />\
				1 Bowl of Alfredo Sauce"
		tooltipRows = 3

		req = list(	/obj/Item/Plate/Pasta				=	1,
					/obj/Item/Bowl/Food/Alfredo_Sauce	=	1)
		built = /obj/Item/Plate/Alfredo_Pasta

		extras = list(/obj/Item/Bowl)

	salad
		name = "Salad"
		icon = 'code/Masonry/Plate.dmi'
		icon_state = "Salad"

		desc = "Going on a diet?<br />\
				1 Plate<br/>\
				1 Chopped Lettif<br />\
				1 Sliced Tumeta<br />\
				1 Sliced Karet"
		tooltipRows = 5

		req = list(	/obj/Item/Plate						=	1,
					/obj/Item/Food/Prep/Chopped_Lettif	=	1,
					/obj/Item/Food/Prep/Sliced/Tumeta	=	1,
					/obj/Item/Food/Prep/Sliced/Karet	=	1)
		built = /obj/Item/Plate/Salad

	ice_cream
		name = "Ice Cream"
		icon = 'code/Masonry/Bowl.dmi'
		icon_state = "Ice Cream"

		desc = "A delicious cold treat<br />\
				1 Bucket of Mylk<br />\
				1 Bowl of Shurger<br />\
				1 Bowl"
		tooltipRows = 4

		req = list(	/obj/Item/Bucket/Mylk	=	1,
					/obj/Item/Bowl/Shurger	=	1,
					/obj/Item/Bowl			=	1)
		built = /obj/Item/Bowl/Food/Ice_Cream
		extras = list(	/obj/Item/Bucket,
						/obj/Item/Bowl)