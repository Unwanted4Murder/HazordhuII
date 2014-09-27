obj/Item/Tailoring
	Flammable = TRUE

	proc/bed_check()
		if(!loc) return
		var obj/Built/Bed/bed = locate() in obounds()
		if(bed)
			icon_state = "on_bed"
			layer = bed.layer + 0.1
			set_dir(bed.dir)
			set_loc(bed.loc, bed.step_x, bed.step_y)
		else icon_state = ""

	Thread
		icon = 'code/Tailoring/Thread.dmi'
	Rope
		icon = 'code/Tailoring/Rope.dmi'

	Mattress
		icon = 'code/Tailoring/Matress.dmi'
		New()
			..()
			bed_check()
		dropped_by() bed_check()
		grabbed_by() icon_state = ""
		map_loaded()
			set waitfor = FALSE
			sleep
			bed_check()

	Pillow
		icon = 'code/Tailoring/Pillow.dmi'
		New()
			..()
			bed_check()
		dropped_by() bed_check()
		grabbed_by() icon_state = ""
		map_loaded()
			set waitfor = FALSE
			sleep
			bed_check()

	Blanket
		icon = 'blanket.dmi'
		can_color = TRUE
		New()
			..()
			bed_check()
		dropped_by() bed_check()
		grabbed_by() icon_state = ""
		map_loaded()
			set waitfor = FALSE
			sleep
			bed_check()

	Cushion
		icon = 'code/Tailoring/Cushion.dmi'
	Rug

	Flag
		icon = 'code/Flags/Flags.dmi'
		icon_state = "Neutral"
		Stackable = FALSE

		use(mob/m)
			var flag_name
			for()
				flag_name = input(m,
					"Name your flag. Names must be less than 4 words long, \
					and less than 25 characters.", "Flag Name", "[usr]'s Flag") as null|text
				if(!flag_name) return
				if(length(flag_name) >= 25) continue
				if(wordcount(flag_name) >= 4) continue
				break

			if(locate(/obj/Flag) in loc)
				m.aux_output("There is already a flag here.")
				return

			m.aux_output("You place the flag at your location.")
			var obj/Flag/Neutral/flag = new (m.loc)
			flag.name = flag_name
			del src

	Curtains
	Banner
	Carpet
		icon='code/Tailoring/Carpet.dmi'
		can_color = TRUE
		Stackable = FALSE
		layer = TURF_LAYER + 2

		#if PIXEL_MOVEMENT
		dropped_by()
			var ax = cx()
			var ay = cy()
			var bx = round(ax - 16, 32) + 16
			var by = round(ay - 16, 32) + 16
			pixel_x = ax - bx
			pixel_y = ay - by
			set_center(bx, by, z)
			animate(src, pixel_x = 0, pixel_y = 0, time = 2)
		#endif

	Coat_of_Arms