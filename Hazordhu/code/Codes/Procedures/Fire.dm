var looper/fire_loop = new ("fire tick")
var looper/fps30_loop = new ("tick", 1/3)

obj
	Fire
		name = "On Fire!"
		icon = null
		layer = 10
		Flammable = 0
		mouse_opacity = 2
		layer = 50

		New()
			..()
			var image/f1 = image('code/Icons/Fire.dmi', src, pick("", "medium", "fast"), FLOAT_LAYER)
			f1.pixel_x += rand(-13, 19)
			f1.pixel_y += rand(-12, 20)
			overlays += f1

			for(var/atom/movable/o in loc)
				if(o.Flammable && o.attackable)
					fire_loop.add(o)

			var spread_time = randn(100, 300)
			if(WarTime) spawn(spread_time) if(WarTime)
				Spread()

			var burn_time = spread_time + randn(200, 400)
			spawn(burn_time)
				if(WarTime)
					for(var/atom/movable/o in loc)
						fire_loop.remove(o)
				del src

		interact_right(mob/m)
			var obj/Item/Bucket/Water/b = locate() in m
			if(b)
				del b
				new /obj/Item/Bucket (m)
				m.emote("puts out the fire")
				for(var/obj/Fire/o in loc) o.Extinguish()
			else m.aux_output("You need a bucket of water to put out the fire.")

		proc/Spread()
			if(!WarTime) return
			for(var/turf/t in oview(1, loc))
				spawn(rand(10, 50))
					if(!WarTime) return
					if(t && !(locate(/obj/Fire) in t))
						for(var/atom/movable/o in t)
							if(o.Flammable && o.attackable)
								new /obj/Fire (t)
								break

		proc/Extinguish()
			for(var/obj/o in range(1, src)) o.extinguish()
			for(var/obj/Fire/f in orange(1, src)) del f
			del src

	Smoke
		icon='code/Icons/Smoke.dmi'
		layer = 25
		Flammable = 0

		var lifetime
		var lived_time
		var px, py
		New()
			..()
			lifetime = rand(100, 150)
			fps30_loop.add(src)

		proc/tick()
			icon_state = "[round(lerp(1, 4, lived_time / lifetime), 1)]"

			px += randn(-0.5, 0.5)
			py += randn(-0.5, 1)
			pixel_x = px
			pixel_y = py

			lived_time += world.tick_lag
			if(lived_time >= lifetime)
				loc = null
				fps30_loop.remove(src)

atom/movable
	var
		tmp/burning
		Flammable
		attackable = 1

		fires[]
		max_fires

		smokes[]

	proc/extinguish()
		burning = FALSE
		fire_loop.remove(src)

	proc/fire_tick_start()
		if(!burning && WarTime)
			burning = TRUE
			fires = new
			smokes = new
			max_fires = rand(4, 8)
		else fire_loop.remove(src)

	proc/fire_tick()
		if(fires.len < max_fires)
			var image/o = image('code/Icons/Fire.dmi', src, pick("", "medium", "fast"), FLOAT_LAYER)

			if(istype(src, /obj/Built))
				o.pixel_x += rand(-10, 22)
				o.pixel_y += rand(-10, 22)

			else if(istype(src, /obj/Woodcutting))
				if(istype(src, /obj/Woodcutting/Bush))
					o.pixel_x += rand(-12, 12)
					o.pixel_y += rand(-12, 12)
				else
					o.pixel_x += rand(24, 40)
					o.pixel_y += rand(-5, 25)

			else if(istype(src, /obj/Item/Wood))
				var move = rand(0, 13)
				o.pixel_x += move
				o.pixel_y += move
			else
				o.pixel_x = pixel_x + rand(-16, 16)
				o.pixel_y = pixel_y + rand(-16, 16)

			overlays += o
			fires += o

		if(prob(1))
			new /obj/Smoke (loc)

		if(!(locate(/obj/Fire) in loc))
			new /obj/Fire (loc)

	proc/fire_tick_stop()
		overlays -= fires
		fires = null

		if(burning && WarTime)
			new /obj/Item/Coal (loc)

			if(istype(src, /obj/Item))
				src:complete_delete = TRUE
				del src

			if(is_mortal(src))
				var mob/mortal/m = src
				m.die("being burned alive")

			else del src

		burning = FALSE