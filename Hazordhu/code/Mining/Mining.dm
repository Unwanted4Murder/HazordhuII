
obj
	Mining
		Deposits
			layer = MOB_LAYER + 1
			density = 1

			SET_BOUNDS(0, 8, 32, 8)

			Metal_Deposit
				icon = 'code/Mining/Deposits.dmi'
				icon_state = "Metal"
				resources = 130
				resource = /obj/Item/Ores/Metal
				experience = 2

			Hazium_Deposit
				icon = 'code/Mining/Deposits.dmi'
				icon_state = "Hazium"
				resources = 50
				resource = /obj/Item/Ores/Hazium
				experience = 4

			Quarry
				name="Boulder"
				icon = 'code/Mining/Deposits.dmi'
				icon_state = "Stone"
				resources = 150
				resource = /obj/Item/Ores/Stone
				experience = 2

			Clay_Deposit
				icon = 'code/Mining/Deposits.dmi'
				icon_state = "Clay"
				resources = 250
				resource = /obj/Item/Ores/Clay
				experience = 1

			Sandstone_Boulder
				icon = 'code/Mining/Deposits.dmi'
				icon_state = "Sandstone"
				resources = 100
				resource = /obj/Item/Ores/Sandstone
				experience = 1

		cave_walls
			name = "Cave Wall"

			//	How far can the wall support by itself?
			var supported

			proc/depleted() if(invisibility) return TRUE

			//	When a cave wall is mined, it becomes invisible
			proc/deplete()
				if(depleted()) return

				resources = 0
				icon = null
				opacity = FALSE
				density = FALSE
				invisibility = 100

				clear_edges()
				for(var/obj/Mining/cave_walls/cave in orange(1, src))
					cave.remake_edges()

				for(var/obj/Mining/cave_walls/other in orange(supported + 1, src))
					if(!other.is_supported())
						other.cave_in()

			//	When a cave-in occurs, nearby depleted walls replenish
			proc/restore()
				if(!depleted()) return

				resources = initial(resources)
				icon = initial(icon)
				opacity = TRUE
				density = TRUE
				invisibility = FALSE

				for(var/obj/Mining/cave_walls/cave in range(1, src))
					cave.remake_edges()

				for(var/obj/Item/o in loc)
					o.complete_delete = TRUE
					del o

				for(var/mob/mortal/m in loc)
					if(is_player(m))
						var mob/player/p = m
						if(p.GodMode) continue
					m.die("a cave-in")

			//	Depleted cave walls get no edges
			make_edges()
				if(invisibility)
					clear_edges()
				else return ..()

			//	Is the cave wall supported by anything
			proc/is_supported(obj/exclude, cave_in)
				if(!depleted()) return TRUE

				var range[] = orange(src)
				if(exclude) range -= exclude

				//	Check for supporting buildings nearby
				for(var/obj/Built/b in range)
					if(b.can_support && b.can_support >= get_dist(src, b))
						return TRUE

				//	Check for supporting cave walls nearby
				if(!cave_in) for(var/obj/Mining/cave_walls/cave in range)
					if(!cave.invisibility && cave.supported >= get_dist(src, cave))
						return TRUE

				return FALSE

			var caving = FALSE
			//	When a cave wall caves in
			proc/cave_in()
				set waitfor = FALSE
				if(!invisibility) return
				caving = TRUE

				for(var/mob/player/p in orange(10, src)) p.client.shake(45)
				sleep rand(20, 30)

				restore()

				for(var/obj/Mining/cave_walls/cave in orange(supported + 1, src))
					if(cave.caving || prob(90) || cave.is_supported(cave_in = TRUE)) continue
					cave.cave_in()
					sleep(-1)
				caving = FALSE

			dirt
				icon = 'code/Turfs/Cave Walls.dmi'
				icon_state = "Dirt"
				supported = 1
				opacity = 1
				density = 1
				layer = OBJ_LAYER + 1

				resources = 3
				resource = /obj/Item/Ores/Dirt

				experience = 1

				edge_dirs = DIR_CARDINAL
				edge_type = /obj/edge/dirt_wall

			coal
				icon = 'code/Turfs/Cave Walls.dmi'
				icon_state = "Coal"
				supported = 2
				opacity = 1
				density = 1
				layer = OBJ_LAYER + 1

				resources = 3
				resource = /obj/Item/Coal

				experience = 2

				edge_dirs = DIR_CARDINAL
				edge_type = /obj/edge/stone_wall

			stone
				icon = 'code/Turfs/Cave Walls.dmi'
				icon_state = "Stone"
				supported = 2
				opacity = 1
				density = 1
				layer = OBJ_LAYER + 1

				resources = 5
				resource = /obj/Item/Ores/Stone

				experience = 2

				edge_dirs = DIR_CARDINAL
				edge_type = /obj/edge/stone_wall

			clay
				icon = 'code/Turfs/Cave Walls.dmi'
				icon_state = "Clay"
				supported = 2
				opacity = 1
				density = 1
				layer = OBJ_LAYER + 1

				resources = 3
				resource = /obj/Item/Ores/Clay

				experience = 2

				edge_dirs = DIR_CARDINAL
				edge_type = /obj/edge/stone_wall

			metal
				icon = 'code/Turfs/Cave Walls.dmi'
				icon_state = "Metal"
				supported = 2
				opacity = 1
				density = 1
				layer = OBJ_LAYER + 1

				resources = 4
				resource = /obj/Item/Ores/Metal

				experience = 3

				edge_dirs = DIR_CARDINAL
				edge_type = /obj/edge/stone_wall

			hazium
				icon = 'code/Turfs/Cave Walls.dmi'
				icon_state = "Hazium"
				supported = 2
				opacity = 1
				density = 1
				layer = OBJ_LAYER + 1

				resources = 2
				resource = /obj/Item/Ores/Hazium

				experience = 4

				edge_dirs = DIR_CARDINAL
				edge_type = /obj/edge/stone_wall

			sandstone
				icon = 'code/Turfs/Cave Walls.dmi'
				icon_state = "Sandstone"
				supported = 1
				opacity = 1
				density = 1
				layer = OBJ_LAYER + 1

				resources = 1
				resource = /obj/Item/Ores/Sandstone

				experience = 1

				edge_dirs = DIR_CARDINAL
				edge_type = /obj/edge/sandstone_wall

obj
	Item
		Ores
			Metal
				icon = 'code/Mining/Metal Ore.dmi'
				value = 1

			Hazium
				icon = 'code/Mining/Hazium Ore.dmi'
				value = 3

			Stone
				icon = 'code/Mining/Stone.dmi'
				value = 1
/*
				proc/make_brick(mob/humanoid/m)
					if(!m.Locked)
						var obj/Item/Tools/Chisel/chisel = locate() in m
						if(chisel && m.is_equipped(/obj/Item/Tools/Hammer))
							m.emote("begins chiseling the stone into a brick")
							m._do_work(30)
							. = new /obj/Item/Stone/Brick (loc)
							m.emote("makes a brick")
							del src
						else m.aux_output("You need a hammer equipped to you main hand and a chisel in your inventory to make bricks.")
				use(mob/m) make_brick(m)
*/
			Crystalized_Hazium
				icon = 'code/Masonry/Hazium.dmi'
				icon_state = "Crystalized"
				value = 8

				proc/make_crystal(mob/humanoid/m)
					if(m.Locked) return
					var obj/Item/Tools/Chisel/chisel = locate() in m
					if(chisel && m.is_equipped(/obj/Item/Tools/Hammer))
						m.emote("begins to chisel crystalized hazium into a crystal")
						m._do_work(30)
						m.emote("finishes making a hazium crystal")
						m.lose_item(src)
						return m.get_item(/obj/Item/Hazium/Crystal)
						. = new /obj/Item/Hazium/Crystal (loc)
					else m.aux_output("You need a hammer equipped and a chisel in your inventory to make a hazium crystal.")
				use(mob/m) make_crystal(m)

			Clay
				icon = 'code/Mining/Clay.dmi'
				value = 1
				MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
					var obj/Item/Metal/Key/key = over_object
					if(istype(key))
						new /obj/Item/Mould (usr, key.id)
						del src
					else ..()

			Glass
				icon = 'code/Smithing/Glass.dmi'
				value = 2

			Dirt
				icon = 'code/Mining/Dirt.dmi'
				value = 1

			Sand
				icon='code/Mining/Sand.dmi'
				value = 1

			Sandstone
				icon = 'code/Mining/Sandstone.dmi'
				value = 2
/*
				proc/make_brick(mob/humanoid/m)
					if(m.Locked) return
					var obj/Item/Tools/Chisel/chisel = locate() in m
					if(chisel && m.is_equipped(/obj/Item/Tools/Hammer))
						m.emote("starts chiseling sandstone into a brick")
						m._do_work(30)
						m.emote("makes a sandstone brick")
						. = new /obj/Item/Stone/Sandstone_Brick (loc)
						del src
					else m << "You need a hammer equipped to you main hand and a chisel in your off hand to chisel."
				use(mob/m) make_brick(m)
*/
		Bars
			Metal
				icon = 'code/Mining/Metal Bar.dmi'
				value = 3

			Hazium
				icon = 'code/Mining/Hazium Bar.dmi'
				value = 5
