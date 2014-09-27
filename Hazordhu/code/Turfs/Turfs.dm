var summergrass[]
var autumngrass[]


turf/Environment
	var cliff_borders = 0

turf/Environment/cliff_edge
	icon = 'code/Turfs/grass_dir.dmi'
	icon_state = "1"
	var turf_type
	New()
		var dirs = text2num(icon_state)
		if(dirs & 1) new /obj/cliff_border/north (src)
		if(dirs & 2) new /obj/cliff_border/south (src)
		if(dirs & 4) new /obj/cliff_border/east  (src)
		if(dirs & 8) new /obj/cliff_border/west  (src)
		var turf/Environment/t = new turf_type (src)
		t.cliff_borders = dirs

	grass/turf_type		= /turf/Environment/Grass
	jungle/turf_type	= /turf/Environment/Grass/jungle
	snow/turf_type		= /turf/Environment/Snow
	desert/turf_type	= /turf/Environment/Desert

obj/cliff_border
	icon = 'code/Turfs/Clifft_top.dmi'
	density = TRUE
	layer = TURF_LAYER + 0.9
	north
		icon_state = "1"
		SET_BOUNDS(0, 28, 32, 4)
	south
		icon_state = "2"
		SET_BOUNDS(0, 0, 32, 4)
	east
		icon_state = "4"
		SET_BOUNDS(28, 0, 4, 32)
	west
		icon_state = "8"
		SET_BOUNDS(0, 0, 4, 32)

turf
	Environment
		Snow
			icon = 'code/Turfs/Grass.dmi'
			icon_state = "Winter"

		Grass
			icon = 'code/Turfs/Grass.dmi'
			icon_state = "Summer"
			jungle
				name = "Grass"

		Dead_Grass
			icon = 'code/Turfs/Rot Ground.dmi'
			icon_state = "1 Summer"
			New()
				..()
				var a = rand(1, 2)
				icon_state = "[a] Summer"
				dir = pick(1, 2, 4, 8)

		Riverbank
			icon = 'code/Turfs/riverbank.dmi'
			edge_type = /obj/edge/riverbank

		Snowy_Riverbank
			icon = 'code/Turfs/riverbank.dmi'
			icon_state = "winter"
			edge_type = /obj/edge/riverbank_snow

		Jungle_Riverbank
			icon = 'code/Turfs/riverbank.dmi'
			icon_state = "summer"
			edge_type = /obj/edge/riverbank_jungle

		Sand
			icon = 'code/Turfs/small sand.dmi'
			edge_type = /obj/edge/sand

		Desert
			icon = 'code/Turfs/small sand.dmi'
			edge_type = /obj/edge/desert

		Dirt
			icon = 'code/Turfs/Cave Floor.dmi'
			edge_dirs = DIR_CARDINAL
			New()
				..()
				dir = pick(1, 2, 4, 8)

		Ash
			icon = 'code/Turfs/ash.dmi'
			edge_dirs = DIR_CARDINAL
			New()
				..()
				dir = pick(1, 2, 4, 8)

		Lava
			icon = 'code/Turfs/Lava.dmi'
			icon_state = "Summer"
			density = TRUE

		Ice
			icon = 'code/Turfs/Ice.dmi'
			icon_state = "solid"
			var save_state
			New()
				..()
				save_state = icon_state

		Water
			icon = 'code/Turfs/Water.dmi'
			icon_state = "Summer"
			density = TRUE

			River
				icon_state = "river map"
				New()
					icon_state = "river"
					for(var/d in dir_cardinal)
						var path
						var turf/t = get_step(src, d)
						if(!is_water(t))
							switch(d)
								if(NORTH) path = /obj/cliff_border/south
								if(SOUTH) path = /obj/cliff_border/north
								if(EAST)  path = /obj/cliff_border/west
								if(WEST)  path = /obj/cliff_border/east
								else continue
							var obj/cliff_border/b = new path (t)
							b.density = FALSE
					..()

			noF
				name = "Water"
				River
					name = "River"
					icon_state = "river map nof"
					New()
						icon_state = "river"
						for(var/d in dir_cardinal)
							var path
							var turf/t = get_step(src, d)
							if(!is_water(t))
								switch(d)
									if(NORTH) path = /obj/cliff_border/south
									if(SOUTH) path = /obj/cliff_border/north
									if(EAST)  path = /obj/cliff_border/west
									if(WEST)  path = /obj/cliff_border/east
									else continue
								var obj/cliff_border/b = new path (t)
								b.density = FALSE
						..()

			ice_edge
				name = "Water"
				icon_state = "edge"

		Ocean
			icon = 'code/Turfs/ocean.dmi'
			density = TRUE

		water_rock
			icon = 'water_rock.dmi'
			icon_state = "1"
			name = "Sharp Rocks"
			density = TRUE
			New()
				..()
				icon_state = "[rand(1, 6)]"

			nofreeze

		Rot_Water
			icon = 'code/Turfs/Rot Water.dmi'
			icon_state = "Summer"
			density = TRUE

		Cliffs
			icon = 'code/Turfs/lessa_cliff2.dmi'
			icon_state = "Summer"
			density = TRUE
			name = "Cliffs"

			edge_dirs = DIR_CARDINAL

			no_snow
			snow
				icon_state = "winter"
				frozen = TRUE

			//	Leads to the underground
			Caves
				name = "Cave"
				icon_state = "out"
				density = FALSE
				Small
					icon = 'Caves Small.dmi'
					No/Enter()
				Wide
				Big

		Cave
			name = "Cave Wall"
			icon = 'code/Turfs/Cave Walls.dmi'
			icon_state = "No Mine"
			edge_dirs = DIR_CARDINAL
			density = TRUE
			opacity = TRUE

			Enter(mob/title/t) return !istype(t) && ..()

			//	Leads to the surface
			Caves
				name = "Cave"
				icon_state = "in"
				density = FALSE
				Small
					icon = 'Caves Small.dmi'
					No/Enter()

		Rock
			icon = 'Stalagmite.dmi'
			density = TRUE
			icon_state = "1"
			New()
				..()
				icon_state = "[rand(1, 6)]"