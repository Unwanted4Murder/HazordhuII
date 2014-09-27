
mob/Admin/verb
	change_season(t as null|anything in list("Shiverstide", "Frostmelt", "Bloomstide", "Harvestfall"))
		if(!t) t = input("What season will you change it to?", "Season Change", get_season())as null|anything in list("Shiverstide", "Frostmelt", "Bloomstide", "Harvestfall")
		if(!t) return
		if(!calendar) return
		calendar.season_change(t)

var looper/calendar_loop

proc/season_save_path() return "Data/Map/season.sav"
var calendar/calendar

world/New()
	calendar_loop = new
	calendar = new
	..()

proc
	get_season()
		if(calendar)
			if(calendar.season)
				return calendar.season.name

	get_aeon()
		if(calendar)
			return calendar.aeon

	get_moon()
		if(calendar)
			return calendar.moon

season
	var
		name
		temperature

	shiverstide
		name = "Shiverstide"
		temperature = -25

	frostmelt
		name = "Frostmelt"
		temperature = 5

	bloomstide
		name = "Bloomstide"
		temperature = 15

	harvestfall
		name = "Harvestfall"
		temperature = -10

calendar
	var
		aeon = 500
		moon = 0
		season/season = null
		seasons[]

		//	Every 4 seasons the aeon changes
		aeon_length = 4

		//	Every 2 moons the season changes
		season_length = 2

		//	Every 12 hours (midnight and noon) the moon changes
		moon_length = 12

	proc
		load()
			if(!fexists(season_save_path())) return
			var savefile/s = new (season_save_path())
			s["aeon"] >> aeon
			s["moon"] >> moon

			var old_season
			s["season"] >> old_season
			season_change(old_season)

		save()
			fdel(season_save_path())
			var savefile/s = new (season_save_path())
			s["aeon"] << get_aeon()
			s["moon"] << get_moon()
			s["season"] << get_season()

	New()
		seasons = newlist(
			/season/shiverstide,
			/season/frostmelt,
			/season/bloomstide,
			/season/harvestfall)

		calendar = src

		load()

		if(!season)
			season_change(1)

		calendar_loop.add(src)

	Del()
		save()
		..()

	var last_changed
	proc/tick()
		if(world.time - last_changed <= HOUR) return
		last_changed = world.time

		var hour = text2num(time2text(world.timeofday, "hh"))
		if(!(hour % moon_length))
			next_moon()
			save()

	proc
		next_moon()
			moon ++
			world << "New Moon: [moon]"
			if(!(moon % season_length))
				next_season()

		next_aeon()
			aeon ++
			moon = 0
			world << "New Aeon: [aeon]"

		next_season()
			var next = seasons.Find(season) + 1
			if(next > seasons.len)
				next_aeon()
				next = 1
			season_change(next)

		season_change(n)
			if(isnum(n))
				season = seasons[n]

			else if(istext(n))
				var season/s
				for(s in seasons)
					if(s.name == n)
						break
				season = s

			else if(n)
				season = n
			else n = season

			world_temperature = season.temperature

			save()

			world << "New Season: [get_season()]"

		warn_season() switch(season.name)
			if(AUTUMN) world << "Snow is beginning to fall..."
			if(WINTER) world << "The snow is beginning to melt..."
			if(SPRING) world << "The world is warming up..."
			if(SUMMER) world << "The leaves are turning orange..."

mob/player
	PostLogin()
		..()
		season_update()
/*
	#if !THIN_SKIN
	set_title_screen()
		..()
	#endif
*/
atom
	var initialized = FALSE
	var apparent_season
	var season_updates = TRUE

	//	called when in range of a client for the first time per season
	proc/season_update(season = get_season()) apparent_season = season

	//	called the very first time this atom is in range of a client
	proc/initialize()

obj/tree_part
	icon = 'code/Turfs/Leaves.dmi'
	layer = 1.101

	New()
		dir = pick(1, 2, 4, 8)
		pixel_x = rand(-8, 8)
		pixel_y = rand(-8, 8)

	leaves
		icon_state = "leaves"

		season_update(season)
			if(apparent_season) set_loc()
			else if(season == WINTER) set_loc()
			else if(season == AUTUMN && !istype(loc, /turf/Environment/Grass/jungle))
				icon_state = "leaves autumn"
				..()

	roots
		icon_state = "roots"

		season_update(season)
			..()
			if(season == WINTER)
				invisibility = 100
			else invisibility = FALSE

		var tmp/obj/Woodcutting/tree
		New(obj/Woodcutting/tree)
			..()
			if(!tree)
				del src

			src.tree = tree
			var turfs[] = tree.nearby_turfs(3, /turf/Environment/Grass)
			if(!turfs.len) del src

			set_loc(pick(turfs))
			tree.roots ++
			season_update(get_season())

		Del()
			if(tree) tree.roots --
			..()

	reeds
		icon = 'code/Turfs/details.dmi'
		icon_state = "water1"
		season_update(season)
			if(season == WINTER && !istype(loc, /turf/Environment/Water/noF)) set_loc()

	rocks
		icon = 'code/Turfs/details.dmi'
		icon_state = "water2brown"
		season_update(season)
			..()
			if(season == WINTER && !istype(loc, /turf/Environment/Water/noF))
				invisibility = 100
			else
				invisibility = FALSE

	mossy_rocks
		icon = 'code/Turfs/details.dmi'
		icon_state = "moss rocks"
		season_update(season)
			..()
			if(season == WINTER && !istype(loc, /turf/Environment/Grass/jungle))
				invisibility = 100
			else
				invisibility = FALSE

	details
		icon = 'code/Turfs/details.dmi'

		var tmp/obj/Woodcutting/tree
		New(obj/Woodcutting/tree)
			..()
			if(!tree)
				del src

			src.tree = tree
			var turfs[] = tree.nearby_turfs(3, /turf/Environment/Grass)
			if(!turfs.len) del src
			set_loc(pick(turfs))

			season_update(get_season())

		fern
			icon_state = "fern"

			season_update(season)
				if(season == WINTER) set_loc()
				else if(season == AUTUMN && !istype(loc, /turf/Environment/Grass/jungle))
					icon_state = "fern fall"
				else
					icon_state = "fern"

		sticks
			icon_state = "sticks"

		branch
			icon_state = "branch"

obj/Woodcutting
	var has_roots = FALSE
	var has_foliage = FALSE
	var has_detail = FALSE
	var roots = 0

	Tree
		has_roots = TRUE
		has_foliage = TRUE
		has_detail = TRUE

	Tree2
		has_roots = TRUE
		has_foliage = TRUE
		has_detail = TRUE

	Dead
		has_foliage = TRUE
		Thin_Tree/has_foliage = FALSE
		Bush/has_foliage = FALSE

	Jungle
		has_foliage = TRUE
		has_detail = TRUE
		Thin_Tree/has_foliage = FALSE
		Thin_Tree/has_detail = FALSE
		Bush/has_foliage = FALSE
		Bush/has_detail = FALSE
		Tree/has_roots = TRUE
		Tree2/has_roots = TRUE
		Tree3/has_roots = TRUE

	season_update(season)
		..()
		if(has_roots)
			if(!roots || roots < 2 && season == SPRING)
				var attempts
				while(roots < 3 && attempts++ < 5)
					new /obj/tree_part/roots (src)
		if(has_detail)
			var details
			for(details = rand(0,3), details > 0, details--)
				new /obj/tree_part/details/fern (src)
				new /obj/tree_part/details/sticks (src)
			if(prob(50))
				new /obj/tree_part/details/branch (src)

	initialize()
		..()
		pixel_x += rand(-1, 1)
		pixel_y += rand(-1, 1)

		var season = get_season()

		if(has_foliage)
			has_foliage = FALSE

			var tree_type = /obj/Woodcutting/Thin_Tree
			var bush_type = /obj/Woodcutting/Bush
			var tree_min = 0, tree_max = 3
			var bush_min = 0, bush_max = 3

			if(istype(src, /obj/Woodcutting/Dead))
				tree_type = /obj/Woodcutting/Dead/Thin_Tree
				bush_type = /obj/Woodcutting/Dead/Bush

			else if(istype(src, /obj/Woodcutting/Jungle))
				tree_type = /obj/Woodcutting/Jungle/Thin_Tree
				bush_type = /obj/Woodcutting/Jungle/Bush
				tree_max = 5
				bush_max = 5

			for(var/n in 1 to rand(bush_min, bush_max))
				var obj/Woodcutting/bush
				#if PIXEL_MOVEMENT
				bush = new bush_type (loc)
				. = (!bush.Move(loc, 0,
					step_x + rand(-96, 96),
					step_y + rand(-96, 96)) || (locate(/obj/Built) in bush.loc))
				if(!.)
					for(var/turf/t in bush.locs)
						if(!istype(t, loc.type))
							. = 1
							break
				. && bush.set_loc()
				#else
				var turfs[0]
				for(var/turf/t in orange(3, loc))
					if(t.type == loc.type && !(locate(/obj/Built) in t) && !(locate(/obj/Woodcutting) in t))
						turfs += t
				if(turfs.len)
					bush = new bush_type (pick(turfs))
				#endif
				if(bush) bush.season_update(season)

			for(var/n in 1 to rand(tree_min, tree_max))
				var obj/Woodcutting/tree
				#if PIXEL_MOVEMENT
				tree = new tree_type (loc)
				. = (!tree.Move(loc, 0,
					step_x + rand(-96, 96),
					step_y + rand(-96, 96)) || (locate(/obj/Built) in tree.loc))
				if(!.)
					for(var/turf/t in tree.locs)
						if(!istype(t, loc.type))
							. = 1
							break
				. && tree.set_loc()
				#else
				var turfs[0]
				for(var/turf/t in orange(3, loc))
					if(t.type == loc.type && !(locate(/obj/Built) in t) && !(locate(/obj/Woodcutting) in t))
						turfs += t
				if(turfs.len)
					tree new tree_type (pick(turfs))
				#endif
				if(tree) tree.season_update(season)

turf/Environment
	Grass/season_update(season)
		..()
		var is_jungle = istype(src, /turf/Environment/Grass/jungle)
		if(!is_jungle)
			switch(season)
				if(WINTER) icon_state = "Winter"
				if(SPRING) icon_state = "Spring"
				if(SUMMER) icon_state = "Summer"
				if(AUTUMN) icon_state = "Fall"
		dir = pick(1, 2, 4, 8)
		if(!gets_footprint()) for(var/obj/footprint/footprint in src) footprint.set_loc()

		if((season != WINTER || is_jungle) && prob(is_jungle ? 50 : (season == AUTUMN ? 80 : 10)) && (locate(/obj/Woodcutting) in orange(3, src)))
			var obj/tree_part/leaves/l = new (src)
			l.season_update(season)

		var/turf/Environment/Water/w = locate() in orange(3, src)
		if(prob(5) && ((w && w.name == "River") || (locate(/turf/Environment/Cliffs) in orange(5, src))))
			var obj/tree_part/mossy_rocks/m = new(src)
			m.season_update(season)

	Riverbank/season_update(season)
		..()
		if(!gets_footprint()) for(var/obj/footprint/footprint in src) footprint.set_loc()
		switch(season)
			if(SUMMER) icon_state = "summer"
			if(WINTER) icon_state = "winter"
			if(AUTUMN) icon_state = "autumn"
			if(SPRING) icon_state = "spring"

	Snow/season_update()
		..()
		dir = pick(1, 2, 4, 8)

	Cliffs
		var frozen

		season_update(season)
			..()
			if(type == /turf/Environment/Cliffs && !frozen)
				if(dir == 2) dir = pick(1, 4)
				if(season == WINTER)
					icon_state = "winter"
				else icon_state = ""

	Sand/season_update(season)
		if(season == WINTER)
			icon_state = "winter"
		else icon_state = ""
		dir = pick(1, 2, 4, 8)
		..()

	Desert/season_update()
		..()
		dir = pick(1, 2, 4, 8)

	water_rock/season_update(season)
		..()
		if(season == WINTER)
			if(istype(src, /turf/Environment/water_rock/nofreeze)) return
			var no_freeze
			for(var/turf/t in oview(1, src))
				if(t.name == "Ocean")
					no_freeze = 1
					break
			if(!no_freeze) icon = 'code/Turfs/Ice.dmi'
		else icon = 'code/Turfs/water_rock.dmi'

	Water
		initialize()
			if(name != "River")
				var cliffs = 0
				for(var/obj/cliff_border/b in orange(1, src)) cliffs |= get_dir(src, b)
				for(var/turf/Environment/t in nearby_turfs())
					if(cliffs & get_dir(src, t)) continue
				//	if(cliffs & get_dir(t, src)) continue
				//	if(cliff_borders & get_dir(src, t)) continue
				//	if(cliff_borders & get_dir(t, src)) continue
				//	if(t.cliff_borders & get_dir(src, t)) continue
				//	if(t.cliff_borders & get_dir(t, src)) continue
					if(istype(t, /turf/Environment/Water)) continue
					if(istype(t, /turf/Environment/Grass))
						if(istype(t, /turf/Environment/Grass/jungle))
							new /turf/Environment/Jungle_Riverbank (t)
						else new /turf/Environment/Riverbank (t)
					else if(istype(t, /turf/Environment/Snow))
						new /turf/Environment/Snowy_Riverbank (t)
			..()

		var save_state
		season_update(season)
			if(season == WINTER)
				if(istype(src, /turf/Environment/Water/noF)) return
				icon = 'code/Turfs/Ice.dmi'
				if(icon_state != "Fall") density = FALSE

			else
				icon = 'code/Turfs/Water.dmi'
				if(!is_bridged())
					density = TRUE
					for(var/mob/mortal/m in src)
						if(istype(m, /mob/Corpse)) del m
						else if(!m.GodMode && !m.Waterwalk && !m.boat && !istype(m, /mob/Animal/Peek))
							m.take_damage(m.Health, "drowning")
					for(var/mob/Corpse/corpse in src)
						corpse.set_loc()
				if((istype(src, /turf/Environment/Water/River) || istype(src, /turf/Environment/Water/noF/River)) && prob(15))
					new /obj/tree_part/rocks (src)
				else if(!istype(src, /turf/Environment/Water/River) && !istype(src, /turf/Environment/Water/noF/River) && prob(25) && z == 1)
					var turfs[] = nearby_turfs(2, /turf/Environment/Grass)
					if(turfs.len)
						new /obj/tree_part/reeds (src)

			..()

obj
	edge
		New()
			..()
			season_update(get_season())

		sand
			season_update(season)
				..()
				if(season == WINTER)
					icon_state = "edge winter"
				else icon_state = "edge"

		riverbank_snow
			icon_state = "winter edge"
		riverbank_jungle
			icon_state = "summer edge"
		riverbank
			season_update(season)
				..()
				switch(season)
					if(SUMMER) icon_state = "summer edge"
					if(AUTUMN) icon_state = "autumn edge"
					if(WINTER) icon_state = "winter edge"
					if(SPRING) icon_state = "spring edge"

	Woodcutting
		season_update(season)
			..()
			if(!istype(src, /obj/Woodcutting/Jungle) && !istype(src, /obj/Woodcutting/Dead))
				if(season == SPRING || season == SUMMER) icon_state = "Summer"
				if(season == WINTER) icon_state = "Winter"
				if(season == AUTUMN) icon_state = "Fall"

		Desert/season_update(season)

	Built
		Fountain/season_update(season)
			..()
			if(season == WINTER)
				icon_state = "winter"
			else icon_state = ""

mob
	Animal
		Sty/season_update(season)
			..()
			if(season == WINTER) sheared = FALSE

		Mur/season_update(season)
			if(apparent_season == WINTER) milked = FALSE
			..()