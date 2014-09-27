
obj/Built/Water_Wheel
	var powered = FALSE
	proc/is_powered()
		var turf/Environment/Water/water = loc
		powered = is_water(water) && !water.is_frozen() && water.is_flowing() && (dir & HORI && water.dir & VERT || dir & VERT && water.dir & HORI)
		icon_state = powered ? "working" : ""
		return powered

	New()
		..()
		if(istype(loc, /turf/Environment/Water))
			if(loc.dir == WEST) dir = SOUTH
			else if(loc.dir == EAST) dir = NORTH
			else for(var/turf/Environment/g in cardinals(src))
				if(istype(g, /turf/Environment/Water)) continue
				if(istype(g, /turf/Environment/Ocean)) continue
				dir = get_dir(src, g)

		if(is_powered())
			for(var/obj/Built/Grinding_Stone/g in cardinals(src))
				g.power_check()

	Del()
		for(var/obj/Built/Grinding_Stone/g in cardinals(src))
			g.power_check(src)
		..()

	season_update()
		set waitfor = FALSE
		..()
		if(is_powered())
			for(var/obj/Built/Grinding_Stone/g in cardinals(src))
				g.power_check()

obj/Built/Grinding_Stone
	var spinning = FALSE
	var powered = FALSE

	New()
		..()
		power_check()

	season_update()
		set waitfor = FALSE
		..()
		sleep
		power_check()

	proc/power_check(exclude)
		powered = FALSE
		for(var/obj/Built/Water_Wheel/wheel in cardinals(src))
			if(wheel == exclude) continue
			if(wheel.is_powered())
				powered = TRUE
				game_loop.add(src)
		return powered

	interact() return spin()

	proc/spin()
		spinning = 300
		game_loop.add(src)
		return TRUE

	proc/tick()
		if(powered)
			spinning = 1

		if(spinning > 0)
			icon_state = "spin"
			if(!powered) spinning --

		else
			icon_state = "stone"
			spinning = FALSE
			game_loop.remove(src)

obj/Grinding
	icon = null

	DblClick()
		if(usr.Locked) return

		var obj/Built/Grinding_Stone/g = locate() in view(1)
		if(!g) return

		usr.dir = get_dir(usr, g)

		if(!g.spinning)
			usr.aux_output("The stone isn't spinning.")

		else action(usr)

	proc/action()

	Sharpen_Main
		action(mob/humanoid/m)
			var obj/Item/Weapons/weapon = m.is_weapon_equipped()
			if(weapon)
				if(weapon.Sharpness >= 50)
					m.aux_output("You cannot sharpen that weapon any further.")
					return

				play_sharpening_sound()

				m.emote("begins sharpening [m.gender == MALE ? "his" : "her"] [weapon]")
				m._do_work(30)
				m.emote("finishes sharpening [m.gender == MALE ? "his" : "her"] [weapon]")

				weapon.Sharpness ++

		proc/play_sharpening_sound()
			set waitfor = FALSE

			//	play sharpening sound
			for(var/n in 1 to 5)
				var sound/s = sound('code/Sounds/sharpening.wav')
				s.frequency = 1 + rand(-10, 10) / 100
				for(var/mob/h in hearers(src)) if(h.client)
					s.volume = 100 - get_dist(src, h) * 10
					s.status = SOUND_UPDATE
					h.hear_sound(s)
				sleep SECOND

	Flour
		icon		=	'code/Masonry/Bowl.dmi'
		icon_state	=	"Flour"

		action(mob/humanoid/m)
			var obj/Item/Bowl/bowl
			for(bowl in m) if(!bowl.is_filled()) break
			var obj/Item/Farming/crop/Kurn/kurn	=	locate() in m
			if(bowl && kurn)
				m.lose_item(bowl)
				m.lose_item(kurn)

				m.emote("begins grinding some flour")
				m._do_work(30)
				m.emote("finishes grinding some flour")

				m.get_item(/obj/Item/Bowl/Flour)

			else m.aux_output("You need Kurn and a Bowl to make Flour.")

	Shurger
		icon		=	'code/Masonry/Bowl.dmi'
		icon_state	=	"Sugar"

		action(mob/humanoid/m)
			var obj/Item/Bowl/bowl
			for(bowl in m) if(!bowl.is_filled()) break
			var obj/Item/Farming/crop/Shurgercane/shurgercane	=	locate() in m
			if(bowl && shurgercane)
				m.lose_item(bowl)
				m.lose_item(shurgercane)

				m.emote("begins grinding some shurger")
				m._do_work(30)
				m.emote("finishes grinding some shurger")

				m.get_item(/obj/Item/Bowl/Shurger)

			else m.aux_output("You need a Shurgercane and a Bowl to make Shurger.")