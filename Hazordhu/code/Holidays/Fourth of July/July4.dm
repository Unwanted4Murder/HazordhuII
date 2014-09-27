mob
//	newlands
//		New()
//			..()
//			overlays += 'Sam Hat.dmi'
	Animal
		Stoof
			Uncle_Sam
				icon = 'Sam_Stoof.dmi'
				can_harness = FALSE
				attackable = FALSE
obj
	fourth_of_july
		banner
			layer = 50
			icon = '4oj_turfs.dmi'
			icon_state = "banner"

			left
				icon_state = "bannerl"

			right
				icon_state = "bannerr"
		booth
			layer = 50
			icon = '4oj_turfs.dmi'
			icon_state = "booth"

	Item
		Clothing
			Helmet
				Uncle_Sam_Hat
					icon = 'Sam Hat.dmi'

		fireworks
			icon = 'Fireworks.dmi'
			icon_state = "Cracker"
			rightClick()
				if(src in view(1,usr.loc))
					usr << "You set off the fireworks!"
					icon_state = ""
					new /obj/fireworks(loc)
					sleep(10)
					new /obj/fireworks(loc)
					sleep(10)
					new /obj/fireworks(loc)
					sleep(10)
					new /obj/fireworks(loc)
					sleep(10)
					new /obj/fireworks(loc)
					del(src)

	fireworks
		icon = 'fireworks.dmi'
		pixel_y = 64
		layer = 100
		mouse_opacity = 0
		New()
			..()
			icon_state = pick("1","2")
			pixel_y += rand(-10,10)
			pixel_x = rand(-15,15)
			var/r = rand(125,255)
			var/g = rand(125,255)
			var/b = rand(125,255)
			dir = pick(NORTH, EAST, SOUTH, WEST)
			src.icon += rgb(r,g,b)
			spawn(100)
				del(src)