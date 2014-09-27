
/*
	Farming ---------------------------------------------------------------------------
*/
mob/proc
	is_path(obj/Built/o)
		if(o.type == /obj/Built/Path) return TRUE
		return FALSE

	has_hoe()
		if(is_equipped(/obj/Item/Tools/Hoe)) return TRUE
		return FALSE

	_plow_path(obj/Built/Path/path) if(is_path(path) && has_hoe())
		for(var/turf/Environment/Sand/S in oview(1, path))
			return aux_output("You can't farm near sand.")

		if(is_water(path.loc))
			return aux_output("You can't farm on water.")

		emote("begins to plow the path")
		_do_work(30)
		emote("finishes plowing the path")

		new /obj/Built/Path/Farm (path.loc)
		del path

		used_tool()

		return TRUE


/*
	Harvesting -----------------------------------------------------------------------
*/
mob/proc
	_harvest(obj/Item/Farming/plant/o) if(istype(o))

		if(Locked) return

		if(o.wild && o.invisibility >= 99) return

		if(!o.has_seed && !o.has_crop)
			return aux_output("The [o.name] has no seeds or crop.")

		else
			emote("begins to harvest \an [o]")
			_do_work(30)
			if(!o) return
			emote("finishes harvesting \an [o]")

			var obj/Built/Path/Farm/farm = locate() in o.loc

			if((!o.wild || prob(20)) && o.has_crop)
				var crop = text2path("/obj/Item/Farming/crop/[o.name]")
				if(ispath(crop))
					for(var/n in 1 to (o.has_seed ? 1 : 2))
						var obj/Item/Farming/crop/c = new crop (o.loc)
						if(is_player(src))
							var mob/player/p = src
							var skill_level/farming/f = locate() in p.skill_levels
							if(f)
								f.apply(c)
								if(!o.has_crop)
									f.apply(c)

			if((!o.wild || prob(10)) && o.has_seed)
				var seed = text2path("/obj/Item/Farming/seed/[o.name]")
				if(ispath(seed))
					for(var/n in 1 to (o.stage < o.stages ? 1 : rand(1, 3)))
						new seed (o.loc)

			del o

			if(farm)
				new /obj/Built/Path (farm.loc)
				del farm

			return TRUE
