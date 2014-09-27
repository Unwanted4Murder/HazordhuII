var
	const
		DIR_CARDINAL	=	1
		DIR_DIAGONAL	=	2
		DIR_ALL			=	3

	dir_cardinal[]	=	list(1, 2, 4,  8)
	dir_diagonal[]	=	list(5, 6, 9, 10)
	dir_all[]		=	list(1, 2, 4, 5, 6, 8, 9, 10)

/*proc/get_general_dir(atom/ref,atom/target)
    if(target.z > ref.z) return UP
    if(target.z < ref.z) return DOWN

    var/d = get_dir(ref,target)
    if(d&d-1)        // diagonal
        var/ax = abs(ref.x - target.x)
        var/ay = abs(ref.y - target.y)
        if(ax >= (ay << 1))      return d & (EAST|WEST)   // keep east/west (4 and 8)
        else if(ay >= (ax << 1)) return d & (NORTH|SOUTH) // keep north/south (1 and 2)
    return d
*/
proc/get_dir_c(atom/a, atom/b)
	if(b.z > a.z) return UP
	if(b.z < a.z) return DOWN

	var d = get_dir(a, b)
	if(d & d - 1)	//	diagonal
		var ax = abs(a.cx() - b.cx())
		var ay = abs(a.cy() - b.cy())
		if(ax >= (ay << 1))      return d & 3	//	keep east/west (4 and 8)
		else if(ay >= (ax << 1)) return d & 12	//	keep north/south (1 and 2)


atom
	proc/set_dir(new_dir)
		dir = new_dir

	proc/nearby_turfs(range = 1, path)
		var turfs[0]
		var minx, miny
		var maxx, maxy
		if(isnum(range))
			minx = max(1, x - range)
			miny = max(1, y - range)
			maxx = min(world.maxx, x + range)
			maxy = min(world.maxy, y + range)
		else
			var r[] = text2dim(range)
			minx = max(1, x - r[1] / 2)
			miny = max(1, y - r[2] / 2)
			maxx = min(world.maxx, minx + r[1])
			maxy = min(world.maxy, miny + r[2])

		var turf/turf
		if(path)
			for(var/dy in maxy to miny step -1)
				for(var/dx in minx to maxx)
					turf = locate(dx, dy, z)
					if(!istype(turf, path))
						continue
					turfs |= turf
		else
			for(var/dy in maxy to miny step -1)
				for(var/dx in minx to maxx)
					turfs |= locate(dx, dy, z)
		return turfs

proc/cardinals(atom/ref)
	. = list()
	for(var/dir in dir_cardinal)
		var turf/t = get_step(ref, dir)
		if(t)
			. |= t
			. |= t.contents

obj/Built
	var can_support = 0

	New()
		..()
		if(loc)
			var r[] = obounds(src)
			for(var/obj/Woodcutting/t in r) del t
			for(var/obj/Nest/n in r) del n
			for(var/obj/Mining/Deposits/d in r) del d
			spawn(1) for(var/obj/Built/o in r) if(o.type == type && o.step_x == step_x && o.step_y == step_y) del o
			for(var/obj/Item/Farming/plant/plant in loc) if(plant.wild) del plant

	Del()
		if(loc)
			if(istype(src, /obj/Built/Floors))
				var turf/Environment/t = loc
				if(is_water(t) && t.is_frozen() || istype(t, /turf/Environment/Lava))
					t.density = TRUE

			var unsupported[0]
			for(var/obj/Mining/cave_walls/cave in orange(can_support, src))
				if(!cave.is_supported(src))
					unsupported += cave

			for(var/obj/Mining/cave_walls/cave in unsupported)
				cave.cave_in()
		..()

	Stone_Wall/can_support = 1
	Brick_Wall/can_support = 1

	Support_Beam
		icon='code/Woodworking/Support Beam.dmi'
		density = TRUE
		can_support = 2

	Pillar/can_support = 3

obj
	Woodcutting
		New()
			..()
			if(locate(/obj/Built) in loc)
				del src

	Mining/Deposits
		New()
			..()
			if(locate(/obj/Built) in loc)
				del src