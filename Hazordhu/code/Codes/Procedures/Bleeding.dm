mob/NPC
	Bleed() return

mob/Animal
	Troll/Bleed() return
	Olihant/Bleed() return
	Flargl/Bleed() return

mob/mortal
	proc/Bleed()
		set waitfor = FALSE
		if(!GodMode && !Bleeding)
			for(var/bleeding in 1 to rand(5, 10))
				if(prob(25)) continue

				Blood -= rand(1, 3)

				var obj/Blood/b = new (loc)
				b.set_step(step_x, step_y)
				BloodCheck(src)

				for(var/n in 1 to rand(4, 8))
					status_overlay("bleed", 10)
					sleep 10

					if(Dead) return