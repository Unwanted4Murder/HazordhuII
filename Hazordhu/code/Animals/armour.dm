obj
	Item
		Armour
			Animal
				icon = 'animal_armour.dmi'

				use(mob/m) if(loc == m)
					var mob/Animal/a = locate() in m.front(16)
					if(!a) return ..()
					if(!istype(a, /mob/Animal/Stoof)) return
					if(locate(type) in a) return

					Move(a)

					overlayo = icon(icon, icon_state)
					a.overlays += overlayo

				stoof_plate
					name = "Stoof Plate"
					icon_state = "stoof plate"
				stoof_helm
					name = "Stoof Helmet"
					icon_state = "stoof helm"
				stoof_cloak
					name = "Stoof Cloak"
					icon_state = "stoof cloak"
					can_color = TRUE

mob/Animal/Stoof
	die()
		for(var/obj/Item/Armour/Animal/armor in src)
			armor.Move(loc, 0, step_x, step_y)
		..()