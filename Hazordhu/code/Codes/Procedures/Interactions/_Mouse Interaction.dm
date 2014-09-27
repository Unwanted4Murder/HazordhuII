/*

	If an atom is clicked by a player
	within atom.interact_distance pixels:
		left-click: atom.interact(player)
		right-click: atom.interact_right(player)
	This includes the atom being inside the player.

*/

client
	show_popup_menus = FALSE

	Click(atom/o, l, c, pa)
		var p[] = params2list(pa)
		var mob/player/player = mob

		if(p["middle"] && isturf(l))
			return player.cycle_main_hand()

		else if(o.loc == mob || bounds_dist(mob, o) <= o.interact_distance && mob.raycast_to(o, /ray/interact))
			if(mob.can_interact(o))
				if(isturf(o.loc))
					var d = angle2dir(
						vec2_angle(
							vec2(
								o.cx() - mob.cx(),
								o.cy() - mob.cy())))

					if(mob.loc) for(var/obj/cliff_border/edge in obounds(mob, bounds_dist(mob, o)))
						if(get_dir(mob, edge) == d)
							return

				if(p["left"])
					o.interact(mob)

				else if(p["right"])
					o.interact_right(mob)

				if(o && o.loc)
					mob.act()
					mob._swing()
		..()

atom
	var interact_distance = 16
	proc/interact(mob/m)
	proc/interact_right(mob/m)

obj/Item
	proc/use(mob/humanoid/m)
	proc/use_alt(mob/humanoid/m)
	interact_right(mob/player/m)
		if(m.has_key("ctrl"))
			m.client.keys["ctrl"] = FALSE
			use_alt(m)
		else use(m)

	Tailoring
		Harness/parent_type = /obj/Item/Tools

//	Wood
//		Log/interact_right(mob/humanoid/m)
//			MakeBoards(m)
/*
	Ores
		Dirt/interact_right(mob/humanoid/m)
			if(isturf(loc))
				m._pack_dirt(src)
*/
	Farming/plant
		interact(mob/humanoid/m)
			m._harvest(src)

obj/Resource/interact(mob/humanoid/m)
	m._gather(src)
	..()

//	for skinning
mob/interact(mob/humanoid/m)
	m._gather(src)
	..()
/*
turf/interact_right(mob/humanoid/m)
	m._dig(src)
	..()
*/
turf/Environment/Water/interact(mob/humanoid/m)
	m._gather(src)
	..()

obj/Built
	Doors/interact(mob/humanoid/m) if(m._use_door(src)) return

	Path/interact_right(mob/humanoid/m)
		m._plow_path(src)

	Headpike/interact(mob/humanoid/m)
		var obj/Item/Head/h = locate() in src
		if(h) h.Move(loc)
		icon_state = ""

mob/player
	proc/cycle_main_hand()
		var obj/Item/main = equipment["main"]
		var obj/Item/next

		if(main)
			var obj/Item/possible
			var pos = contents.Find(main)
			if(pos < contents.len)
				for(var/n in pos + 1 to contents.len)
					possible = contents[n]
					if("main" == get_equip_type(possible))
						next = possible
						break

			if(!next && pos > 1)
				for(var/n in 1 to pos - 1)
					possible = contents[n]
					if("main" == get_equip_type(possible))
						next = possible
						break
		else
			for(var/obj/Item/i in src)
				if(get_equip_type(i) == "main")
					next = i
					break

		if(next)
			equip(next)