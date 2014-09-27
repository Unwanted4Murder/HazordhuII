/*

	Kaiochao's ProcLib - Angles

	The thing to note here is the difference between "angles" and "bearings."
		angles: 0 is east, increases counter-clockwise.
		bearings: 0 is north, increases clockwise.

	List o' Functions (=> means "returns")
		angle2bearing	=> a bearing from an angle
		angle2dir		=> a BYOND direction from an angle
		bearing2angle	=> an angle from a bearing
		bearing2dir		=> a BYOND direction from a bearing
		dir2angle		=> an angle from a BYOND direction
		dir2bearing		=> a bearing from a BYOND direction
		dir2text		=> a lowercase name for BYOND directions (NORTH == "north")
		dir2offset		=> an offset (-1 to 1, -1 to 1) from a BYOND direction
		offset2dir		=> a BYOND direction from an offset (components signed)
		atan2			=> an angle from x and y displacements
		atan2b			=> a bearing from x and y displacements

		clamp_angle			=> the angle inside [0, 360)
		angle_difference		=> the smallest difference between two angles

*/

proc
	//	conversions between bearings and directons
	angle2dir(angle) switch(clamp_angle(angle))
		if(0 to 22.5)		return NORTH
		if(22.5 to 67.5)	return NORTHEAST
		if(67.5 to 112.5)	return EAST
		if(112.5 to 157.5)	return SOUTHEAST
		if(157.5 to 202.5)	return SOUTH
		if(202.5 to 247.5)	return SOUTHWEST
		if(247.5 to 292.5)	return WEST
		if(292.5 to 337.5)	return NORTHWEST
		if(337.5 to 360)	return NORTH

	angle2cardinal(angle) switch(clamp_angle(angle))
		if(315 to 360, 0 to 45) return NORTH
		if(135 to 225) return SOUTH
		if(45 to 135) return EAST
		if(225 to 315) return WEST

	// converts a BYOND-direction to a bearing
	dir2angle(dir) switch(dir)
		if(NORTH)		return 0
		if(NORTHEAST)	return 45
		if(EAST)		return 90
		if(SOUTHEAST)	return 135
		if(SOUTH)		return 180
		if(SOUTHWEST)	return 225
		if(WEST)		return 270
		if(NORTHWEST)	return 315

	//	converts a BYOND-direction to a lowercase text string
	dir2text(dir) switch(dir)
		if(NORTH)		return "north"
		if(NORTHEAST)	return "northeast"
		if(EAST)		return "east"
		if(SOUTHEAST)	return "southeast"
		if(SOUTH)		return "south"
		if(SOUTHWEST)	return "southwest"
		if(WEST)		return "west"
		if(NORTHWEST)	return "northwest"

	//	keep an angle/bearing within bounds [0 360)
	clamp_angle(angle)
		. = angle % 360 + angle - round(angle)
		if(. >= 360) . -= 360
		if(. <    0) . += 360

	//	difference between angles
	angle_difference(a, b)
		var t = b - a
		return sin(t) >= 0 ? arccos(cos(t)) : -arccos(cos(t))
	/*
		. = (a - b)
		. = . % 360 + . - round(.)
		if (. < -180) . += 360
		if (. >  180) . -= 360
	*/

	//	get the angle with the given displacement
	//	if you already calculated the length of the displacement vector,
	//	you can provide that.
	atan2(x, y, d)
		if(istype(x, /list))
			if(isnull(d)) d = y
			y = x[2]
			x = x[1]
		if(!(x || y)) return 0
		if(isnull(d)) d = sqrt(x * x + y * y)
		return x >= 0 ? arccos(y / d) : 360 - arccos(y / d)

	//	takes an offset and returns a BYOND-direction, kinda like atan2
	offset2dir(dx, dy)
		if(istype(dx, /list))
			dy = dx[2]
			dx = dx[1]
		var global/o2d[] = list(
			list(8, 0, 4),
			list(2, 0, 1))
		return o2d[1][sign(dx) + 2] | o2d[2][sign(dy) + 2]

	//	takes a dir and returns an offset
	//	x and y can either be -1, 0, or 1
	dir2offset(dir)
		var global/d2o[] = list(
			list(0,  0,  0,  1,  1,  1,  0, -1, -1, -1),
			list(1, -1,  0,  0,  1, -1,  0,  0,  1, -1)
		)
		return list(d2o[1][dir], d2o[2][dir])