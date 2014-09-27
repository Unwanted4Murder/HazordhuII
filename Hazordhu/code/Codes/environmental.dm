//	This is how much the global temperature affects the heat of the players.
var world_temperature = 10

//	How much heat is added to a player wearing this.
obj/Item/var/tmp/heat_added = 0

var looper/temperature_loop = new ("temperature tick", 1)

mob/player
	/*
		body_heat <= 15: freezing
		body_heat >= 90: burning
	*/
	var tmp/body_heat = 50

	PostLogin()
		..()
		temperature_loop.add(src)

	proc/temperature_tick()
		if(!in_tutorial())
			var overall_addition = world_temperature

			if(z == 2)	//	in a cave
				switch(get_season())
					if(SUMMER, SPRING) overall_addition -= 10
					if(WINTER, AUTUMN) overall_addition += 20

			else switch(y)
				if(0   to  20)	overall_addition -= 20
				if(21  to  40)	overall_addition -= 15
				if(41  to  50)	overall_addition -= 10
				if(61  to  70)	overall_addition += 10
				if(71  to  90)	overall_addition += 15
				if(91  to 100)	overall_addition -= 10
				if(101 to 115) 	overall_addition -= 15
				if(719 to 828)	overall_addition -= 20

			var fire_heat = 0
			var view[] = view(5, src)

			for(var/obj/Fire/o in view)
				fire_heat += cos(90 * distance(x, y, o.x, o.y) / 32 / 5)

			if(locate(/turf/Environment/Lava) in view)
				for(var/turf/Environment/Lava/o in view)
					fire_heat += 25 * (1 - get_dist(src, o) / 5)

			if(locate(/obj/Built/Forge) in view)
				for(var/obj/Built/Forge/o in view)
					if(o.fuel_life)
						fire_heat += 10 * (1 - get_dist(src, o) / 5)

			if(locate(/obj/Built/Range) in view)
				for(var/obj/Built/Range/o in view)
					if(o.fuel_life)
						fire_heat += 10 * (1 - get_dist(src, o) / 5)

			overall_addition += fire_heat

			var equipment_heat = 0
			for(var/obj/Item/o in Equipment())
				equipment_heat += o.heat_added

			overall_addition += equipment_heat

			var old_body_heat = body_heat
			body_heat = min(30 + overall_addition, 100)

			if(body_heat != old_body_heat)
				if(0 && client)
					winset(src, "heat_bar", "value=[body_heat]; bar-color=[temperature_color()]")

				if(!(GodMode || Dead))
					if(body_heat >= 90)
						take_heat_damage()
					else
						overheating = FALSE
						if(body_heat <= 15)
							take_cold_damage()
						else freezing = FALSE

	var tmp/next_heat_damage

	var tmp/overheating
	proc/take_heat_damage()
		if(GodMode || Dead || in_tutorial() || world.time < next_heat_damage) return
		next_heat_damage = world.time + 10
		overheating = TRUE
		aux_output("You take heat damage!")
		take_damage(rand(1, 5), "overheating")

	var tmp/freezing
	proc/take_cold_damage()
		if(GodMode || Dead || in_tutorial() || world.time < next_heat_damage) return
		next_heat_damage = world.time + 10
		freezing = TRUE
		aux_output("You take cold damage!")
		take_damage(rand(5, 10), "freezing")

	proc/in_tutorial() return x > 665 && y > 770

	//	I totally used Excel to make a smooth curve
	proc/temperature_color(x = body_heat)
		var x2 = x * x, x3 = x2 * x, x4 = x3 * x
		var r = 0.0437*x2 - 1.8137*x + 3.5714
		var g = 0.0001*x4 - 0.0217*x3 + 1.2553*x2 - 16.947*x - 7e-11
		var b = 0.0437*x2 - 6.9177*x + 258.77
		return rgb(
			clamp(round(r), 0, 255),
			clamp(round(g), 0, 255),
			clamp(round(b), 0, 255))