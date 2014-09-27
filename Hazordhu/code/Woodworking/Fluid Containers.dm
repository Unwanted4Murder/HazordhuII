obj/Item
	Canteen
		Water
			drinks = 5
			thirst = 10

	Bowl
		Water
			drinks = 1
			thirst = 10

	Bucket
		Water
			drinks = 3
			thirst = 40

		Mylk
			drinks = 3
			thirst = 30
			hunger = 20

obj/Built
	proc/can_fill(obj/Item/Container/container, mob/m)
		return contains_liquid()

	proc/contains_liquid()

	proc/fill_container(obj/Item/Container/container, mob/m)

	Barrel
		fill_container(container, mob/m) deplete(m)
		Water/contains_liquid() return "Water"
		Beer/contains_liquid() return "Beer"
		Wine/contains_liquid() return "Wine"
	Fountain/contains_liquid() return "Water"
	Well/contains_liquid() return "Water"
	Sink/contains_liquid() return is_on() && "Water"

mob
	proc/can_drink(o)
		return !Locked

	proc/fill(obj/Item/Container/container)
		if(!Locked && container.loc == src)
			var ahead[] = front()

			var atom/filler
			var frozen = FALSE
			var liquid = "Water"

			var turf/Environment/Water/water
			for(water in ahead)
				var covered = locate(/obj/Built) in water
				if(!covered)
					if(water.is_frozen())
						frozen = TRUE
					else
						frozen = FALSE
						break

			if(frozen) aux_output("The water is frozen solid!")

			else if(!water)
				var obj/Built/b
				for(b in ahead)
					liquid = b.can_fill(container, src)
					if(container.liquid2path(liquid))
						filler = b
						break

			if(water || filler)
				aux_output("You fill the [container] with [liquid].")
				container.filled(src, liquid)
				if(istype(filler, /obj/Built))
					var obj/Built/b = filler
					b.fill_container(container, src)

			else aux_output("There's nothing ahead to fill this with.")

	proc/drink_from(obj/Item/Container/container)
		if(container.loc == src && can_drink(container))
			if(!Thirst)
				aux_output("You're not thirsty enough to drink.")

			else
				Locked = TRUE
				status_overlay("thirst", container.thirst)
				emote("starts drinking [initial(container.name)] from the [container.container]")

				while(container.thirst > 0 && Thirst > 0)
					container.thirst --
					Thirst --
					sleep 1

				Hunger -= container.hunger

				container.drinks --
				container.rename()

				emote("finishes drinking [initial(container.name)] from the [container.container]")
				status_overlay_remove("thirst")
				Locked = FALSE

				container.thirst = initial(container.thirst)
				if(container.drinks <= 0)
					container.drinks = initial(container.drinks)
					container.rename()

					new container.parent_type (src)
					del container

obj/Item
	Container
		var container
		var thirst
		var hunger
		var drinks

		Read()
			..()
			rename()

		proc/liquid2path(liquid)
			. = text2path("[type]/[liquid]")
			. = ispath(.) && .

		proc/filled(mob/m, liquid)
			var path = liquid2path(liquid)
			if(path)
				var obj/Item/Container/filled = new path (m)
				filled.rename()
				del src

		proc/is_filled()
			return name != container

		proc/rename()
			if(is_filled())
				src.name = "[initial(src.name)] ([src.drinks] drink\s left)"

		proc/mylk(mob/humanoid/m)
			if(loc == m && !m.Locked)
				var mob/Animal/Mur/mur, found_male = FALSE
				for(mur in m.front(8))
					if(mur.gender == FEMALE)
						break
					else found_male = TRUE
				if(mur)
					m.emote("attempts to mylk the mur")
					mur.Locked = TRUE
					m._do_work(30)
					mur.Locked = FALSE
					mur.milked = TRUE
					if(prob(75))
						m.emote("mylks the mur")
						filled(m, "Mylk")
					else
						m.emote("fails to mylk the mur")
						if(!mur.rider) step_away(mur, m)
					return TRUE
				else if(found_male) m.aux_output("You can't mylk this male mur!")

		use(mob/m) if(loc == m)
			if(drinks && is_filled())
				m.drink_from(src)
			else if(!mylk(m)) m.fill(src)
			..()

	Glass_Cup
		parent_type = /obj/Item/Container
		icon = 'code/smithing/glass_cup.dmi'
		name = "Glass"
		container = "Glass"
		drinks = 3
		thirst = 6

		Water
			Stackable = FALSE
			icon_state = "Water"
			name = "Water"

		Mylk
			Stackable = FALSE
			icon_state = "mylk"
			hunger = 4
			name = "Mylk"

		Beer
			Stackable = FALSE
			icon_state = "beer"
			name = "Beer"

		Wine
			Stackable = FALSE
			icon_state = "wine"
			name = "Wine"

	Canteen
		parent_type = /obj/Item/Container
		container = "Canteen"
		Water/Stackable = FALSE

	Bowl
		parent_type = /obj/Item/Container
		container = "Bowl"
		Water/Stackable = FALSE

	Bucket
		parent_type = /obj/Item/Container
		container = "Bucket"
		Water/Stackable = FALSE
		Mylk/Stackable = FALSE

		/*	Mylking
		use_alt(mob/humanoid/m)
			if(!is_filled())
				return mylk(m)

		proc/mylk(mob/humanoid/m)
			if(loc == m && !m.Locked)
				var mob/Animal/Mur/mur, found_male = FALSE
				for(mur in m.front(8))
					if(mur.gender == FEMALE)
						break
					else found_male = TRUE
				if(mur)
					m.emote("attempts to mylk the mur")
					mur.Locked = TRUE
					m._do_work(30)
					mur.Locked = FALSE
					mur.milked = TRUE
					if(prob(75))
						m.emote("mylks the mur")
						filled(m, "Mylk")
					else
						m.emote("fails to mylk the mur")
						if(!mur.rider) step_away(mur, m)
					return TRUE
				else if(found_male) m.aux_output("You can't mylk this male mur!")*/