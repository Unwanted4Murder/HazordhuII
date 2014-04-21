obj/Built/Totem
	icon = 'code/totems/totem.dmi'
	attackable = false
	var active = false
	var range = 4
	var tmp/showing[0]

	map_loaded()
		..()
		icon_state = active ? "on" : ""

	Click(l, c, params[])
		params = params2list(params)
		var mob/player/p = usr
		if(params["right"])
			show_coverage(p)
		else if(is_admin(p.ckey))
			if(p.has_key("ctrl")) set_range(p)
			else toggle(p)
		..()

	var tmp/images[0]

	proc/set_range(mob/player/p)
		var new_range = input(p, "Set the range of this totem.", "Totem Range", range) as null | num
		if(isnull(new_range)) return
		range = clamp(new_range, 0, 1.#INF)

		images = new
		for(var/x in -range to range)
			for(var/y in -range to range)
				var image/i = image(icon, src, "coverage", 150)
				i.pixel_x = x * 32
				i.pixel_y = y * 32
				images += i

	proc/show_coverage(mob/player/p)
		if(p in showing) return
		showing += p
		p.client.images += images
		spawn(10)
			if(p) p.client.images -= images
			showing -= p

	proc/toggle(mob/player/toggler) active ? deactivate(toggler) : activate(toggler)

	proc/activate(mob/player/p)
		active = true
		icon_state = "on"

	proc/deactivate(mob/player/p)
		active = false
		icon_state = ""