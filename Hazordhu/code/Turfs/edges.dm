
obj/edge
	icon = null
	icon_state = "edge"
	mouse_opacity = FALSE

	stone_wall/icon_state = "Stone edge"
	dirt_wall/icon_state = "Dirt edge"
	sandstone_wall/icon_state = "Sandstone edge"
	sand
	desert

turf/Environment
	Sand/edge_dirs = DIR_ALL
	Desert/edge_dirs = DIR_ALL
	Riverbank/edge_dirs = DIR_ALL
	Snowy_Riverbank/edge_dirs = DIR_ALL
	Jungle_Riverbank/edge_dirs = DIR_ALL

	Cliffs
		joins_with(o) return istype(o, /turf/Environment/Cliffs)
		Caves

	Cave
		joins_with(o) return istype(o, /turf/Environment/Cave)
		Caves
			edge_state = "cave edge"

atom
	season_update()
		..()
		if(!invisibility && edge_dirs) make_edges()

	var edges[]
	var edge_dirs
	var edge_type
	var edge_state
	proc
		new_edge(dir, t)
			if(!ispath(edge_type)) edge_type = /obj/edge

			if((edge_dirs & DIR_DIAGONAL) && (dir & (dir - 1)) && (istype(get_step(src, dir & (NORTH | SOUTH)), type) || istype(get_step(src, dir & (EAST  |  WEST)), type))) return FALSE

			var obj/edge/edge = new edge_type (t)
			edge.dir	=	dir
			edge.icon	=	icon
			if(edge_state) edge.icon_state = edge_state
			edge.layer	=	layer
			return edge

		remake_edges()
			edge_dirs = initial(edge_dirs)
			clear_edges()
			make_edges()

		clear_edges()
			for(var/obj/edge/e in edges) e.set_loc()
			edges = null

		make_edges()
			if(invisibility) return
			if(!edge_dirs) return

			edges = new
			var d, turf/t

			var L[]
			switch(edge_dirs)
				if(DIR_CARDINAL)	L = dir_cardinal
				if(DIR_DIAGONAL)	L = dir_diagonal
				if(DIR_ALL)			L = dir_all

			main
				for(d in L)
					t = get_step(src, d)
					if(!t) continue
					var atom/LOC = turf_of(src)
					if(d & 1) if(locate(/obj/cliff_border/north) in LOC) continue
					if(d & 2) if(locate(/obj/cliff_border/south) in LOC) continue
					if(d & 4) if(locate(/obj/cliff_border/east)  in LOC) continue
					if(d & 8) if(locate(/obj/cliff_border/west)  in LOC) continue
					if(isturf(src)) if(joins_with(t)) continue
					else for(var/atom/movable/am in t)
						if(am.invisibility) continue
						if(joins_with(am)) continue main
					edges += new_edge(d, t)
			edge_dirs = 0

		//	no edge will be created towards o if this returns TRUE
		joins_with(atom/o) return istype(o, type)