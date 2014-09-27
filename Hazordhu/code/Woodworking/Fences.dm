
/*

	Fences will join to any fully-dense object.

*/

obj
	Built
		New()
			if(!istype(src, /obj/Built/Fence) && !istype(src, /obj/Built/fence_part))
				for(var/obj/Built/Fence/f in orange(1, loc)) f.fenceJoin()
			..()

		Del()
			if(!istype(src, /obj/Built/Fence) && !istype(src, /obj/Built/fence_part))
				var old_loc = loc
				set_loc()
				for(var/obj/Built/Fence/f in orange(1, old_loc)) f.fenceJoin()
			..()

		fence_part
			no_save = TRUE

			Flammable = FALSE
			name = "Fence"

			icon = 'code/Woodworking/fence.dmi'
			icon_state = "child"
			density = TRUE

			north { SET_TBOUNDS("15,8 to 18,32"); dir = 1 }
			south { SET_TBOUNDS("15,1 to 18,11"); dir = 2 }
			east  { SET_TBOUNDS("15,8 to 32,11"); dir = 4 }
			west  { SET_TBOUNDS("1,8  to 18,11"); dir = 8 }

			var obj/Built/Fence/parent

		proc/fenceJoin(Center)
			for(var/obj/Built/Fence/f in range(1, Center || src))
				f.fencejoin()

		Fence
			name = "Fence Post"
			density = TRUE
			SET_TBOUNDS("15,8 to 18,11")

			var children[]

			proc
				can_join_with(atom/movable/o)
					if(o == src) return FALSE
					if(o.type == type) return TRUE
					if(o.type == /obj/Built/fence_part) return FALSE
					if(istype(o, /obj/Built/Doors))
						if(istype(o, /obj/Built/Doors/Gate))
							var d = get_dir(src, o)
							if(o.dir & HORI && d & VERT) return FALSE
							if(o.dir & VERT && d & HORI) return FALSE
						return TRUE
					if(!o.density) return FALSE
					if(istype(o, /turf/Environment))
						if(istype(o, /turf/Environment/Cave)) return TRUE
						if(istype(o, /turf/Environment/Cliffs)) return TRUE
					if(istype(o)) return !(o.bound_width < 32 || o.bound_height < 32)

				fencejoin()
					if(children && children.len) for(var/obj/o in children) o.set_loc()
					children = new

					for(var/atom/f in orange(1, loc))
						if(!can_join_with(f)) continue

						var path
						switch(get_dir(src, f))
							if(1) path = /obj/Built/fence_part/north
							if(2) path = /obj/Built/fence_part/south
							if(4) path = /obj/Built/fence_part/east
							if(8) path = /obj/Built/fence_part/west
							else continue

						var obj/Built/fence_part/part = new path (loc)
						part.parent = src
						children += part

			New()
				..()
				fenceJoin()

			Del()
				if(children && children.len)
					for(var/obj/o in children) o.set_loc()
					children = null
				var old_loc = loc
				set_loc()
				fenceJoin(old_loc)
				..()
