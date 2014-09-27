builder/baking
	icon = 'code/Cooking/Recipes.dmi'
	skill = COOKING

	condition(mob/m)
		if(!m.loc) return
		var obj/Built/Oven/oven = locate(/obj/Built/Oven) in obounds(m, 16)
		if(!oven)
			m.aux_output("You need to be by an oven.")
			return FALSE
		if(oven.icon_state != "lit")
			m.aux_output("The oven needs to be lit.")
			return FALSE
		return TRUE

	bread
		name = "Bread"
		icon_state = "bread"

		desc = "A staple food of any society<br />\
				1 Dough"
		tooltipRows = 2

		req = list(	/obj/Item/Food/Prep/Dough	=	1)
		built = /obj/Item/Food/Cooking/Bread
		experience = 2

	cake
		name = "Cake"
		icon_state = "cake"

		desc = "A tasty, large pastry<br />\
				2 Doughs<br />\
				2 Eggs<br />\
				1 Bucket of Mylk<br />\
				1 Bowl of Shurger"
		tooltipRows = 5

		req = list(	/obj/Item/Food/Prep/Dough	=	2,
					/obj/Item/Food/Egg			=	2,
					/obj/Item/Bucket/Mylk		=	1,
					/obj/Item/Bowl/Shurger		=	1)
		built = /obj/Item/Food/Cooking/Cake
		extras = list(	/obj/Item/Bucket,
						/obj/Item/Bowl)
		experience = 5

	pie
		name = "Pie"
		icon_state = "pie"

		desc = "It smells delicious!<br />\
				10 Berries<br />\
				1 Dough"
		tooltipRows = 3

		req = list(	/obj/Item/Food/Berry		=	10,
					/obj/Item/Food/Prep/Dough	=	1)
		built = /obj/Item/Food/Cooking/Pie
		experience = 3

	muffin
		name = "Muffin"
		icon_state = "muffin"

		desc = "5 tasty muffins<br />\
				1 Dough<br />\
				1 Bucket of Mylk<br />\
				1 Egg"
		tooltipRows = 4

		req = list(	/obj/Item/Food/Prep/Dough	=	1,
					/obj/Item/Bucket/Mylk		=	1,
					/obj/Item/Food/Egg			=	1)
		built = /obj/Item/Food/Cooking/Muffin
		build_amount = 5
		extras = list(/obj/Item/Bucket)

	cookie
		name = "Cookie"
		icon_state = "cookie"

		desc = "5 tasty cookies<br />\
				1 Dough<br />\
				1 Bucket of Mylk<br />\
				1 Bowl of Shurger<br />\
				1 Egg"
		tooltipRows = 5

		req = list(	/obj/Item/Food/Prep/Dough	=	1,
					/obj/Item/Bucket/Mylk		=	1,
					/obj/Item/Bowl/Shurger		=	1,
					/obj/Item/Food/Egg			=	1)
		built = /obj/Item/Food/Cooking/Cookie
		build_amount = 5
		extras = list(	/obj/Item/Bucket,
						/obj/Item/Bowl)