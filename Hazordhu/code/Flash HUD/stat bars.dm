mob/player
	var tmp/hud/bar
		health/health_bar
		energy/energy_bar
		hunger/hunger_bar
		thirst/thirst_bar

	var tmp/statbars[]

	Stat()
		..()
		update_statbars()

	proc/make_statbars()
		health_bar = new (src)
		energy_bar = new (src)
		hunger_bar = new (src)
		thirst_bar = new (src)
		statbars = list(
			health_bar, energy_bar,
			hunger_bar, thirst_bar)

	proc/update_statbars() if(Made)
		if(!statbars) make_statbars()

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

			//	if the stat is below 70%, force it visible
			if(force_show || percents[stat] < 0.7)
				bar.FadeIn()
			else bar.FadeOut()

			bar.set_value(percents[stat])

	proc/show_statbars()
		for(var/hud/bar/stat/bar in statbars)
			bar.FadeIn()

	proc/hide_statbars()
		for(var/hud/bar/stat/bar in statbars)
			bar.FadeOut()

	key_down(k)	k == "x" ? update_statbars() : ..()
	key_up(k)	k == "x" ? update_statbars() : ..()

hud/bar
	stat
		var faded = false
		proc/FadeIn() if(faded)
			faded = false
			for(var/hud/bar/part/part in parts)
				part.alpha = 32
				animate(part, alpha = 224, time = 2)

		proc/FadeOut() if(!faded)
			faded = true
			for(var/hud/bar/part/part in parts)
				part.alpha = 224
				animate(part, alpha = 32, time = 2)

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