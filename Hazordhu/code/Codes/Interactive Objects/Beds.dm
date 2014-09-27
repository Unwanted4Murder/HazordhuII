var looper/rest_loop = new ("rest tick")

mob
	var last_act
	proc/act()
		last_act = world.time

	moved()
		. = ..()
		act()

mob/player
	var rest_time = MINUTE / 4
	var sleep_time = MINUTE
	var tmp/resting = FALSE
	PostLogin()
		..()
		rest_loop.add(src)

	proc/rest_tick()
		var inactivity = world.time - last_act
		if(inactivity > rest_time && Hunger < 90 && Thirst < 90)
			if(resting)
				if(inactivity > sleep_time)
					status_overlay("tired", 1)
				gain_stamina(0.2)

			else if(Sleeping)
				status_overlay("tired", 1)
				gain_stamina(1)
				drunk = max(0, drunk - 2 / MINUTE)

			else if(inactivity > sleep_time)
				var obj/Built/Bed/bed
				if(loc) for(bed in bounds())
					if(bed.bed_is_made())
						break
				if(bed)
					bed.Sleep(src)
				else
					resting = TRUE
		else
			resting = FALSE
			if(Sleeping) Sleeping.WakeUp()

	//	Bed
	var tmp/obj/Built/Bed/Sleeping

	Logout()
		if(Sleeping)
			Sleeping.WakeUp()
		..()

	moved()
		. = ..()
		if(Sleeping)
			Sleeping.WakeUp()

obj/Built/Bed
	var tmp/mob/player/Sleeper

	Del()
		if(Sleeper)
			WakeUp()
		..()

	Sleeping_Bag
		bed_is_made()
			return TRUE

	proc
		bed_is_made()
			return (locate(/obj/Item/Tailoring/Mattress) in loc) && (locate(/obj/Item/Tailoring/Pillow) in loc)

		rest_tick()
			if(Sleeper && !Sleeper.Sleeping) Sleeper = null
			if(!Sleeper) rest_loop.remove(src)

		Sleep(mob/player/m)
			if(m.Sleeping)
				WakeUp()
				return

			if(Sleeper)
				m.aux_output("[m.nameShown(Sleeper)] is already sleeping in the [src].")
				return

			m.set_loc(loc, step_x - 2, step_y + 3)

			var angle
			switch(dir)
				if(1) angle = 180
				if(2) angle = 0
				if(4) angle = 270
				if(8) angle = 90

			m.icon_turn(angle)
			m.dir = EAST
			m.emote("falls asleep on the [src]")
			m.Sleeping = src
			Sleeper = m
			m.icon_state += " sleep"
			rest_loop.add(src)

		WakeUp(mob/player/m = Sleeper)
			m.Sleeping = null
			m.emote("wakes up")
			m.icon_turn(0)
			Sleeper = null