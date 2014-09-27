obj/Item
	//	Food's cook_icon is 10 states of gradually getting darker
	var cook_icon
	proc/cook_icon()
		if(!cook_icon)
			var icon/i = icon(initial(icon), initial(icon_state))
			for(var/t in 0 to 10)
				var icon/darkness = icon(initial(icon), initial(icon_state))
				var intensity = 1 - 0.05 * t
				darkness.SetIntensity(intensity)
				i.Insert(darkness, "[t]")
			cook_icon = fcopy_rsc(i)
		return cook_icon

	//	Food is cooked well if cooked > 5
	var can_be_cooked = FALSE
	var cooked = 0
	Food/Meat/can_be_cooked = TRUE

	Read()
		..()
		if(cooked)
			icon = cook_icon()
			icon_state = "[round(cooked)]"

	map_loaded()
		..()
		if(cooked)
			icon = cook_icon()
			icon_state = "[round(cooked)]"

	var goes_on_range = FALSE
	var range_state = "range"
	Tools/Pan/goes_on_range = TRUE
	Metal/Pot/goes_on_range = TRUE

	MouseDrop(obj/Built/cooker)
		if(loc == usr && istype(cooker) && bounds_dist(usr, cooker) <= 16)
			if(can_be_cooked)
				if(cooker.add_food(usr, src))
					return

			if(goes_on_range)
				var obj/Built/Range/r = cooker
				if(istype(r))
					r.add_container(usr, src)
		..()

obj/Built
	var can_cook
	var obj/Item/Food/Meat/cooking

	Range
		map_loaded()
			for(var/obj/Item/item in src)
				if(item.goes_on_range)
					add_container(null, item)
					break
			..()

		add_food(mob/humanoid/m)
			if(!container)
				return ..()

		MouseDrop(mob/player/p)
			if(container && istype(p) && bounds_dist(src, p) <= 24)
				remove_container(p)

		proc/add_container(mob/m, obj/Item/item)
			if(container)
				if(m) m.aux_output("Something else is already on the range.")
				return
			if(m)
				if(!m.is_equipped(item) || m.unequip(item))
					m.aux_output( "You put the [item] onto the range.")
				else return

			container = item.type
			item.Move(src)

			var image/i = image(initial(item.icon), item.range_state, layer = FLOAT_LAYER)
			i.pixel_y = 4
			overlays += i

			return

		proc/remove_container(mob/m)
			var obj/Item/item = locate(container) in src
			if(item)
				m.aux_output("You take the [item] off of the range.")
				item.Move(m)
				overlays.Cut()
				container = null

	interact(mob/humanoid/m)
		if(cooking && m.has_pan())
			m.used_tool()
			remove_food(m)
		..()

	proc/cook_tick()
		if(cooking)
			overlays -= cooking
			cooking.Stackable = FALSE
			cooking.cooked += 0.1
			if(cooking.cooked >= 10)
				ohearers(src) << "[cooking.name] burned into nothing."
				del cooking

			else
				cooking.icon_state = "[round(cooking.cooked)]"
				overlays += cooking

	proc/remove_food(mob/humanoid/m)
		if(!can_cook) return
		if(cooking)
			if(!m.has_pan()) return
			cooking.Stackable = FALSE
			cooking.Move(m)
			overlays.Cut()
			cooking.layer = initial(cooking.layer)

			m.aux_output("You remove [cooking.name] from the [src].")
			cooking = null
			m.used_tool()
			return TRUE

	proc/add_food(mob/humanoid/m, obj/Item/Food/Meat/food)
		if(!can_cook) return

		if(!m.has_pan()) return

		if(cooking)
			if(!remove_food(m))
				return

		if(food.Stacked > 1)
			food.Stack_Check(1)
			food = new food.type
			food.Stackable = FALSE
		food.Move(src)
		food.icon = food.cook_icon()
		food.layer = FLOAT_LAYER
		overlays += food
		cooking = food

		m.aux_output("You add [cooking.name] to the [src].")
		m.used_tool()
		return TRUE