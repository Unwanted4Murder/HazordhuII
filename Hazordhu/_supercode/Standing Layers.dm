//	My side-map layering system

atom/movable
	//	Set this to TRUE if you want the atom to
	//	layer like it's standing up
	var standing
	var bottom_offset

	proc/update_layer()
		if(!standing) return
		var max_py = world.maxy * tile_height()
		if(!max_py) return

		//	The base layer
		layer = MOB_LAYER

		//	px / max_py
		if(loc) layer -= (py() + bottom_offset) / max_py

	New()
		..()
		standing && update_layer()

	Move()
		. = ..()
		standing && update_layer()

mob
	standing = TRUE
	Corpse
		standing = FALSE
		layer = TURF_LAYER + 2


obj/click_void/standing = FALSE

obj
	Mining/Deposits/standing = TRUE
	Woodcutting/standing = TRUE
	Flag/standing = TRUE
	Built
		standing = TRUE
		Boat/standing = FALSE
		Path/standing = FALSE
		Floor/standing = FALSE
		Stone_Floor/standing = FALSE
		Sandstone_Floor/standing = FALSE
		tutorial_circle/standing = FALSE
		Transporter/standing = FALSE
		Bed/standing = FALSE
		firepit/standing = FALSE

