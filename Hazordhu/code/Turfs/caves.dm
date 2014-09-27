proc/cave_transport(mob/humanoid/mob, turf/cave, dir, new_z) spawn
	if(istype(src, /mob/title)) return

	var sx = 0, sy = 0
	switch(turn(dir, 180))
		if(NORTH)	sy = -mob.bound_y
		if(SOUTH)	sy = tile_height() - mob.bound_y - mob.bound_height
		if(EAST)	sx = -mob.bound_x
		if(WEST)	sx = tile_width()  - mob.bound_x - mob.bound_width
	mob.set_loc(get_step(locate(cave.x, cave.y, new_z), dir), sx, sy)

	if(is_humanoid(mob))
		mob.pulling_cart && mob.pulling_cart.set_loc(mob.loc, mob.step_x, mob.step_y)
		mob.mount && mob.mount.set_loc(mob.loc, mob.step_x, mob.step_y)

turf/Environment
	Cave/Caves
		Enter(mob/m, atom/oldloc)
			var d = get_dir(src, m) || get_dir(src, oldloc)
			if(is_cardinal(d))
				if(istype(m) || istype(m, /obj/Built/Boat))
					cave_transport(m, src, d, 1)

	Cliffs/Caves
		Enter(mob/m, atom/oldloc)
			var d = get_dir(src, m) || get_dir(src, oldloc)
			if(is_cardinal(d))
				if(istype(m) || istype(m, /obj/Built/Boat))
					cave_transport(m, src, d, 2)