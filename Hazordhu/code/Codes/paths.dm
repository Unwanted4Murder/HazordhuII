obj/Built/Path
	icon = 'code/Icons/Path.dmi'
	icon_state = "11"
	layer = TURF_LAYER + 1
	density = FALSE
	base_health = 300

	Sand
		icon='code/Icons/Sand Path.dmi'
		icon_state = "11"
		Cobblestone
			icon = 'code/Icons/Sand Cobblestone.dmi'

	Cobblestone
		icon = 'code/Icons/Cobblestone.dmi'

	Farm
		icon = 'code/Farming/FarmPath.dmi'
		destroyed_by()
			new /obj/Built/Path (loc)
			..()

	interact(mob/humanoid/m)
		if(m.Locked) return
		if(type == /obj/Built/Path)
			if(m.is_equipped(/obj/Item/Tools/Hoe))
				for(var/turf/Environment/Sand/S in m.nearby_turfs())
					m.aux_output("You can't farm near sand.")
					return
				m.emote("starts plowing the path")
				m._do_work(30)
				m.emote("finishes plowing the path")
				new /obj/Built/Path/Farm (loc)
				m.used_tool()
				del src

	New()
		..()
		PathCheck()

	map_loaded()
		..()
		PathCheck()

	Del()
		var old_loc = loc
		set_loc()
		PathCheck(old_loc)
		..()

var PathDirConvert[] = list(7, 8, 1, 9, 6, 4, 15, 10, 5, 3, 13, 2, 12, 14, 16)
obj/Built/Path
	proc/PathCheck(t = loc)
		for(var/obj/Built/Path/p in range(1, t))
			p.auto_join()

	proc/auto_join()
		var d = 0
		for(var/dir in list(1, 2, 4, 8))
			var/turf/t = get_step(src, dir)
			if(locate(/obj/Built/Path) in t)
				var/no

				for(var/obj/cliff_border/c in t)
					if(c.icon_state == "[get_dir(src, get_step_away(src, get_step(src, dir)))]" && c.density)
						no = TRUE
				for(var/obj/cliff_border/c in loc)
					if(c.icon_state == "[dir]" && c.density)
						no = TRUE

				if(!no) d |= dir
		icon_state = "[d && PathDirConvert[d] || 11]"

obj
	Reef
		icon = 'code/Turfs/Opaq Reef.dmi'
		density = 1
		icon_state = "11"
		layer = TURF_LAYER + 1

		Trans
			icon = 'code/Turfs/Trans Reef.dmi'
			density = 0



		var
			Checked
		proc/PathCheck()
			var/obj/Reef/N
			var/obj/Reef/S
			var/obj/Reef/E
			var/obj/Reef/W
			for(var/obj/Reef/O in range(1,src))if(O.icon)
				if(get_dir(src,O)==NORTH)
					N=O
				if(get_dir(src,O)==EAST)
					E=O
				if(get_dir(src,O)==WEST)
					W=O
				if(get_dir(src,O)==SOUTH)
					S=O
			if(N&&!S&&!E&&!W)
				src.icon_state="7"
			if(!N&&S&&!E&&!W)
				src.icon_state="8"
			if(!N&&!S&&E&&!W)
				src.icon_state="9"
			if(!N&&!S&&!E&&W)
				src.icon_state="10"

			if(N&&!S&&E&&!W)
				src.icon_state="6"
			if(N&&!S&&!E&&W)
				src.icon_state="5"
			if(!N&&S&&E&&!W)
				src.icon_state="4"
			if(!N&&S&&!E&&W)
				src.icon_state="3"

			if(N&&S&&E&&!W)
				src.icon_state="15"
			if(N&&S&&!E&&W)
				src.icon_state="13"
			if(!N&&S&&E&&W)
				src.icon_state="14"
			if(N&&!S&&E&&W)
				src.icon_state="12"

			if(N&&S&&E&&W)
				src.icon_state="16"

			if(N&&S&&!E&&!W)
				src.icon_state="1"
			if(!N&&!S&&E&&W)
				src.icon_state="2"
			if(N||S||W||E)
				src.Checked=1
			if(N)
				if(N.Checked==1)
					src.Checked=0
					return 0
				N.PathCheck()
			if(S)
				if(S.Checked==1)
					src.Checked=0
					return 0
				S.PathCheck()
			if(E)
				if(E.Checked==1)
					src.Checked=0
					return 0
				E.PathCheck()
			if(W)
				if(W.Checked==1)
					src.Checked=0
					return 0
				W.PathCheck()
			src.Checked=0
