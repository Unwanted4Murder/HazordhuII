mob/player
	var tmp/hud/bar
		health/health_bar
		energy/energy_bar
		hunger/hunger_bar
		thirst/thirst_bar

	Stat()
		..()
		if(Made)
			if(!health_bar)
				health_bar = new (src)
				energy_bar = new (src)
				hunger_bar = new (src)
				thirst_bar = new (src)

			var bars[] = list(
				health = health_bar,
				energy = energy_bar,
				hunger = hunger_bar,
				thirst = thirst_bar)

			var percents[] = list(
				health = Health / MaxHealth,
				energy = Stamina / MaxStamina,
				hunger = 1 - Hunger / 100,
				thirst = 1 - Thirst / 100)

			var force_show = has_key("x")

			for(var/stat in bars)
				var hud/bar/stat/bar = bars[stat]

				if(force_show || percents[stat] < 0.7)
					bar.FadeIn()
				else bar.FadeOut()

				bar.set_value(percents[stat])

#if !THIN_SKIN
	proc/show_statbars() for(var/hud/bar/stat/bar in list(health_bar, energy_bar, hunger_bar, thirst_bar)) bar.FadeIn()
	proc/hide_statbars() for(var/hud/bar/stat/bar in list(health_bar, energy_bar, hunger_bar, thirst_bar)) bar.FadeOut()

	key_down(k)
		if(k == "x")
			show_statbars()
		else ..()

	key_up(k)
		if(k == "x")
			hide_statbars()
		else ..()
#endif
hud/bar
	stat
		build_parts()
			..()
			for(var/hud/bar/part/part in parts)
				part.alpha = 100

		var fade = FALSE

		proc/FadeIn()
			if(!fade) return
			fade = FALSE
			for(var/hud/bar/part/part in parts)
				animate(part, alpha = 200, time = 1)

		proc/FadeOut()
			if(fade) return
			fade = TRUE
			for(var/hud/bar/part/part in parts)
				animate(part, alpha = 100, time = 1)


	health
		parent_type = /hud/bar/stat
		name = "health"
		x = "CENTER-3"
		y = "NORTH-2"

	energy
		parent_type = /hud/bar/stat
		name = "energy"
		x = "CENTER+1"
		y = "NORTH-2"
		px = 16

	hunger
		parent_type = /hud/bar/stat
		name = "hunger"
		x = "CENTER-3"
		y = "SOUTH+2"

	thirst
		parent_type = /hud/bar/stat
		name = "thirst"
		x = "CENTER+1"
		y = "SOUTH+2"
		dir = EAST
		px = 16