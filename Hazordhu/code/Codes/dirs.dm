proc/dirdiff(a, b)
	if(a == b) return 0
	if(a == turn(b, 45)  || a == turn(b, -45))  return 45
	if(a == turn(b, 90)  || a == turn(b, -90))  return 90
	if(a == turn(b, 135) || a == turn(b, -135)) return 135
	if(a == turn(b, 180)) return 180

atom/movable
	proc
		get_px_step(dir, dist = 8)
			if(!loc) return
			return obounds(src,
				dir & 12 && dir & 8 && -dist,
				dir &  3 && dir & 2 && -dist,
				dir & 12 && dist,
				dir &  3 && dist)

		front(n = 8)	return get_px_step(dir, n)
		left_of(n = 8)	return get_px_step(turn(dir, -90), n)
		right_of(n = 8)	return get_px_step(turn(dir, 90), n)
		behind(n = 8)	return get_px_step(turn(dir, 180), n)