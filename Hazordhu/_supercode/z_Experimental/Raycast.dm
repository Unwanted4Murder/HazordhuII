/*

	A system to cast a ray from one position to another position

*/

atom
	Enter(atom/movable/o) return istype(o) && o.CanCross(src) || ..()

	Entered(atom/movable/o)
		o.Crossing(src)
		..()

	movable
		Cross(atom/movable/o) return o.CanCross(src) || ..()

		Crossed(atom/movable/o)
			o.Crossing(src)
			..()

		proc/Crossing(atom/o)
		proc/CanCross(atom/o)

atom
	proc/blocks_interaction() return density

mob/Animal/blocks_interaction()

obj/Built
	blocks_interaction() return !is_table && ..()
	Tanning_Frame/blocks_interaction()

turf/Environment
	Water/blocks_interaction()
	Lava/blocks_interaction()

ray
	parent_type = /obj
	invisibility = 101
	density = TRUE
	SET_BOUNDS(0, 0, 1, 1)

	var tmp/crossed[0]
	Crossing(atom/o) crossed |= o
	interact/CanCross(atom/o) . = !o.blocks_interaction()

//	Accepts two vectors or 4 numbers
#if PIXEL_MOVEMENT
proc/raycast(px, py, z, dx, dy, type)
	if(is_vec2(px))
		z = dx
		dx = py[1]
		dy = py[2]
		py = px[2]
		px = px[1]
	. = list()
	if(!ispath(type)) type = /ray
	var ray/ray = new type
	ray.set_pos(px, py, z)
	if(!ray.loc) return
	. |= obounds(ray)
	ray.move(dx, dy)
	. |= ray.crossed
	if(ray.bumped) . += ray.bumped
	. |= ray.loc
	ray.set_loc()
#endif

atom
	proc/raycast_to(atom/o, type)
		#if PIXEL_MOVEMENT
		if(z != o.z) return
		var a[] = center()
		var b[] = o.center()
		. = raycast(a[1], a[2], z, b[1] - a[1], b[2] - a[2], type)
		return o in .
		#else
		return TRUE
		#endif