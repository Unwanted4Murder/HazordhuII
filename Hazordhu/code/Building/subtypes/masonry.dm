builder/masonry
	main_tool = /obj/Item/Tools/Trowel
	skill = MASONRY
	cursor = "trowel"

	density = TRUE
	
	dig_dirt
		main_tool = /obj/Item/Tools/Shovel
		name = "Dig"
		icon = 'code/Mining/Dirt.dmi'
		desc = "Dig with a Shovel for 3x Dirt.<br>\
			Only on Grass or Dirt terrain."
		density = FALSE
		build_amount = 3
		built = /obj/Item/Ores/Dirt

		valid_loc(turf/t) 
			return t.name == "Grass" || t.name == "Dirt"
	
	dig_sand
		main_tool = /obj/Item/Tools/Shovel
		name = "Dig Sand"
		icon = 'code/Mining/Sand.dmi'
		desc = "Dig with a Shovel for 3x Sand.<br>\
			Only on Sand terrain."
		density = FALSE
		build_amount = 3
		built = /obj/Item/Ores/Sand

		valid_loc(turf/t)
			return t.name == "Sand"

	path
		main_tool = /obj/Item/Tools/Shovel
		name = "Dirt Path"
		icon = 'code/Icons/Path.dmi'
		desc = "A simple dirt path. <br />\
				1 Dirt"
		req = list(DIRT = 1)
		built = /obj/Built/Path

		density = FALSE

	sand_path
		main_tool = /obj/Item/Tools/Shovel
		name = "Sand Path"
		icon = 'code/Icons/Sand Path.dmi'
		desc = "A simple sand path. <br />\
				1 Sand"
		req = list(SAND = 1)
		built = /obj/Built/Path/Sand

		density = FALSE

	brick
		name = "Brick"
		icon = 'code/masonry/brick.dmi'
		desc = "Used somewhat often in masonry.<br>\
				1 Stone"
		req = list(STONE = 1)
		main_tool = /obj/Item/Tools/Chisel
		built = /obj/Item/Stone/Brick
		density = FALSE

	sandstone_brick
		name = "Sandstone Brick"
		icon = 'code/masonry/brick.dmi'
		icon_state = "sandstone"
		main_tool = /obj/Item/Tools/Chisel
		built = /obj/Item/Stone/Sandstone_Brick
		density = FALSE
		req = list(SANDSTONE = 1)
		desc = "Used in desert-themed masonry.<br>\
				1 Sandstone"

	tar
		main_tool = null
		name = "Tar"
		icon = 'code/Masonry/Tar.dmi'
		condition(mob/m)
			if(!m.loc) return
			var turf/Environment/Water/w = locate() in obounds(m, 16)
			if(istype(w) && !w.is_frozen())
				return TRUE

			if(get_season() == WINTER)
				return FALSE

			var obj/Built/Fountain/f = locate() in obounds(m, 16)
			if(!f) return FALSE
			return TRUE

		desc = "Used in almost all other Masonry. \
				Requires non-frozen water or a fountain nearby. <br />\
				1 Clay<br />\
				1 Dirt"
		tooltipRows = 3

		req = list(	CLAY	=	1,
					DIRT	=	1)
		built = /obj/Item/Stone/Tar
		build_amount = 3

		density = FALSE

	bowl
		main_tool = null
		name = "Bowl"
		icon = 'code/Masonry/Bowl.dmi'

		desc = "Holds water and tanin<br />\
				1 Clay"
		tooltipRows = 2

		req = list(	CLAY	=	1)
		built = /obj/Item/Bowl

		density = FALSE

	plate
		main_tool = null
		name = "Plate"
		icon = 'code/Masonry/Plate.dmi'

		desc = "Used to hold various foods<br />\
				1 Clay"
		tooltipRows = 2

		req = list(	CLAY	=	1)
		built = /obj/Item/Plate

		density = FALSE


	cobble_path
		main_tool = /obj/Item/Tools/Trowel
		name = "Cobblestone Path"
		icon = 'code/Icons/Cobblestone.dmi'

		allowed_races = HUMAN

		desc = "Nicer than dirt paths!<br />\
				2 Bricks"
		tooltipRows = 2

		req = list(	BRICK	=	2)
		built = /obj/Built/Path/Cobblestone

		density = FALSE

	sscobble_path
		main_tool = /obj/Item/Tools/Trowel
		name = "Sandstone Path"
		icon = 'code/Icons/Sand Cobblestone.dmi'

		allowed_races = HUMAN

		desc = "Nicer than dirt paths! With a desert theme!<br />\
				2 Sandstone Bricks"
		tooltipRows = 2

		req = list(	SSBRICK	=	2)
		built = /obj/Built/Path/Sand/Cobblestone

		density = FALSE

	forge
		name = "Forge"
		icon = 'code/Masonry/Forge.dmi'

		desc = "Used to smelt raw minerals into bars<br />\
				6 Bricks<br />\
				2 Tar"
		tooltipRows = 3

		req = list(	BRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Forge

	oven
		name = "Oven"
		icon = 'code/Masonry/Oven.dmi'

		desc = "Used to bake food<br />\
				6 Bricks<br />\
				2 Tar"
		tooltipRows = 3

		req = list(	BRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Oven

	altar
		name = "Altar"
		icon = 'code/Masonry/Altar.dmi'

		desc = "Give thanks to the Aels<br />\
				6 Bricks<br />\
				2 Tar"
		tooltipRows = 3

		req = list(	BRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Altar

	stone_wall
		name = "Stone Wall"
		icon = 'code/Masonry/Stone Wall.dmi'

		desc = "Quick and easy fire-proof structure<br />\
				5 Stones"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	STONE	=	5)
		built = /obj/Built/Stone_Wall

	brick_wall
		name = "Brick Wall"
		icon = 'code/Masonry/Brick Wall.dmi'
		group_only = 1

		desc = "Quick and easy fire-proof structure<br />\
				6 Bricks<br />\
				2 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	BRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Brick_Wall

	brick_window
		name = "Brick Window"
		icon = 'code/Masonry/Stone Window.dmi'
		group_only = 1

		desc = "Quick and easy fire-proof structure<br />\
				6 Bricks<br />\
				2 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	BRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Stone_Window

	brick_door
		name = "Brick Door"
		icon = 'code/Masonry/Stone Door.dmi'
		group_only = 1

		desc = "Quick and easy fire-proof door<br />\
				6 Bricks<br />\
				2 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	BRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Doors/Stone_Door

	brick_floor
		name = "Brick Floor"
		icon = 'code/Masonry/Stone Floor.dmi'
		group_only = 1

		desc = "Wear slippers, this gets cold!<br />\
				4 Bricks<br />\
				3 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	BRICK	=	4,
					TAR		=	3)
		built = /obj/Built/Stone_Floor

		density = FALSE

	brick_bridge
		name = "Brick Bridge"
		icon = 'code/Masonry/Stone Bridge.dmi'
		group_only = 1
		valid_loc(turf/t)
			if(is_water(t)) return TRUE
			if(istype(t, /turf/Environment/Lava)) return TRUE

		desc = "A sturdy and fireproof bridge<br />\
				6 Bricks<br />\
				4 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	BRICK	=	6,
					TAR		=	4)
		built = /obj/Built/Stone_Bridge

		density = FALSE


	ssbrick_wall
		name = "Sandstone Wall"
		icon = 'code/Masonry/Sandstone Wall.dmi'
		group_only = 1

		desc = "Quick and easy fire-proof structure<br />\
				6 Sandstone Bricks<br />\
				2 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	SSBRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Sandstone_Wall

	ssbrick_window
		name = "Sandstone Window"
		icon = 'code/Masonry/Sandstone Window.dmi'
		group_only = 1

		desc = "Quick and easy fire-proof structure<br />\
				6 Sandstone Bricks<br />\
				2 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	SSBRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Sandstone_Window

	ssbrick_door
		name = "Sandstone Door"
		icon = 'code/Masonry/Sandstone Door.dmi'
		group_only = 1

		desc = "Quick and easy fire-proof door<br />\
				6 Sandstone Bricks<br />\
				2 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	SSBRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Doors/Sandstone_Door

	ssbrick_floor
		name = "Sandstone Floor"
		icon = 'code/Masonry/Sandstone Floor.dmi'
		group_only = 1

		desc = "Wear slippers, this gets cold!<br />\
				4 Sandstone Bricks<br />\
				3 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	SSBRICK	=	4,
					TAR		=	3)
		built = /obj/Built/Sandstone_Floor

		density = FALSE

	ssbrick_bridge
		name = "Sandstone Bridge"
		icon = 'code/Masonry/Sandstone Bridge.dmi'
		group_only = 1
		valid_loc(turf/t)
			if(is_water(t)) return TRUE
			if(istype(t, /turf/Environment/Lava)) return TRUE

		desc = "A sturdy and fireproof bridge<br />\
				6 Sandstone Bricks<br />\
				4 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list( SSBRICK	=	6,
					TAR		=	4)
		built = /obj/Built/Sandstone_Bridge

	pillar
		name = "Pillar"
		icon = 'code/Masonry/Pillar.dmi'
		group_only = 1

		desc = "A fireproof pillar used to support tunnels and prevent cave-ins<br />\
				5 Bricks<br />\
				3 Tar"
		tooltipRows = 4

		allowed_races = HUMAN

		req = list( BRICK 	=	5,
					TAR 	=	3)
		built = /obj/Built/Pillar

	fountain
		name = "Fountain"
		icon = 'code/Masonry/Fountain.dmi'
		group_only = 1
		allowed_races = HUMAN

		desc = "An elegant decoration and water source<br />\
				3 Bricks<br />\
				2 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	BRICK	=	3,
					TAR		=	2)
		built = /obj/Built/Fountain

	well
		name = "Well"
		icon = 'code/Masonry/Well.dmi'

		desc = "A crude yet effective source of water<br />\
				2 Bricks<br />\
				1 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	BRICK	=	2,
					TAR		=	1)
		built = /obj/Built/Well

	tombstone
		name = "Tombstone"
		icon = 'code/Masonry/Tombstone.dmi'

		desc = "A memorial stone for the dead<br />\
				2 Bricks<br />\
				1 Tar"
		tooltipRows = 3

		req = list(	BRICK	=	2,
					TAR		=	1)
		built = /obj/Built/Tombstone

	statue
		name = "Statue"
		icon = 'code/Masonry/Statues.dmi'
		icon_state = "Human"
		group_only = 1

		desc = "A stone recreation of someone to be remembered<br />\
				6 Bricks<br />\
				2 Tar"
		tooltipRows = 4

		req = list(	BRICK	=	6,
					TAR		=	2)
		built = /obj/Built/Statue

	brick_sign
		name = "Sign"
		icon = 'code/Masonry/Stone Sign.dmi'

		desc = "A fireproof sign which can be written on<br />\
				3 Bricks<br />\
				2 Tar"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	BRICK	=	3,
					TAR		=	2)
		built = /obj/Built/Stone_Sign

	tower
		name =	"Tower"
		icon = 'code/Masonry/Tower.dmi'
		group_only = 1

		desc = "A mighty tower essential for any good<br />\
				castle<br />\
				7 Bricks<br />\
				4 Tar"
		tooltipRows = 4

		allowed_races = HUMAN

		req = list(	BRICK	=	7,
					TAR		=	4)
		built = /obj/Built/Tower

	Haz_Obelisk
		name =	"Hazium Obelisk"
		icon = 'code/Masonry/spawnstone.dmi'
		group_only = 1

		desc = "A teleporter or a spawn point<br />\
				6 Bricks<br />\
				4 Tar<br />\
				4 Crystalized Hazium"
		tooltipRows = 4

		req = list(	BRICK		=	6,
					TAR			=	4,
					CHAZ		=	4)
		built = /obj/Built/spawnstones/main

	Haz_Rune
		name =	"Hazium Rune"
		icon = 'code/Masonry/spawnstone.dmi'
		icon_state = "small"
		group_only = 1

		desc = "A key part to an Obelisk<br />\
				3 Bricks<br />\
				2 Tar<br />\
				2 Crystalized Hazium"
		tooltipRows = 4

		req = list(	BRICK		=	3,
					TAR			=	2,
					CHAZ		=	2)
		built = /obj/Built/spawnstones/small

	/*
	moat
		name = "Moat"
		icon = 'moat.dmi'
		icon_state = "11"
		req = list(	BRICK					=	6,
					TAR						=	4,
					/obj/Item/Bucket/Water	=	2)
	*/
