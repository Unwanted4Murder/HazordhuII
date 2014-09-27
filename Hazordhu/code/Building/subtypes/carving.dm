builder/carving
	main_tool = /obj/Item/Tools/Knife
	skill = CARVING
	cursor = "knife"
	allowed_in_tutorial = TRUE

	boards
		name = "Boards"
		icon = 'code/woodcutting/board.dmi'
		desc = "Chop a log into boards!<br>\
				1 Log"
		req = list(LOG = 1)
		main_tool = /obj/Item/Tools/Hatchet
		built = /obj/Item/Wood/Board
		build_amount() return rand(1, 3)

	firepit
		name = "Fire Pit"
		icon = 'code/Cooking/Firepit.dmi'

		desc = "Best for camping trips! Start the fire with tongs and logs, and cook with a Pan. <br />\
				3 Logs"
		tooltipRows = 2

		req = list( LOG		=	3)
		built = /obj/Built/firepit
		allowed_in_tutorial = FALSE

		density = TRUE
/*
	tinder_box
		name = "Tinder Box"
		icon = 'code/Woodworking/Tinder Box.dmi'

		desc = "Used to create fires.  Use with caution!<br />\
				1 Nail<br />\
				1 Board<br />\
				1 Stone<br />\
				1 Phluf"
		tooltipRows = 5

		req = list( NAIL	=	1,
					BOARD	=	1,
					STONE	=	1,
					PHLUF	=	1)
		built = /obj/Item/Tinder_Box
*/
	pipe
		name = "Pipe"
		icon = 'code/Icons/Pipe.dmi'

		desc = "Used to smoke huff<br />\
				1 Log"
		tooltipRows = 2

		req = list(	LOG		=	1)
		built = /obj/Item/Pipe

	arrows
		name = "Arrows"
		icon = 'code/Weapons/Arrow.dmi'

		desc = "Crafts 6 arrows<br />\
				1 Log"
		tooltipRows = 2

		req = list(	LOG		=	1)
		built = /obj/Item/Projectile/Arrow
		build_amount = 6

	bow
		name = "Bow"
		icon = 'code/Weapons/Bow.dmi'
		icon_state = "item"
		desc = "A bow used to shoot arrows<br>2 Logs<br>1 Thread"
		req = list(LOG = 2, THREAD = 1)
		built = /obj/Item/Weapons/archery/Bow

	crossbow
		name = "Crossbow"
		icon = 'code/Weapons/Crossbow.dmi'
		icon_state = "item"
		group_only = 1

		allowed_races = HUMAN

		desc = "A crossbow used to shoot bolts<br />\
				1 Log<br />\
				2 Boards<br />\
				2 Nails"
		tooltipRows = 4

		req = list(	LOG		=	1,
					BOARD	=	2,
					NAIL	=	2)
		built = /obj/Item/Weapons/archery/Crossbow

	carding
		name = "Carding Tool"
		icon = 'code/Tools/Carding Tool.dmi'
		icon_state = "item"

		desc = "Used to make thread<br />\
				1 Board"
		tooltipRows = 2

		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Carding_Tool

	hatchet
		name = "Hatchet"
		icon = 'code/Tools/Hatchet.dmi'
		icon_state = "item"

		desc = "Used to chop wood<br />\
				1 Board"
		tooltipRows = 2

		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Hatchet

	chisel
		name = "Chisel"
		icon = 'code/Tools/Chisel.dmi'
		icon_state = "item"

		desc = "Used to chisel bricks and ice<br />\
				1 Board"
		tooltipRows = 2

		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Chisel

	trowel
		name = "Trowel"
		icon = 'code/Tools/Straight Edge.dmi'
		icon_state = "item"

		desc = "Used to lay bricks<br />\
				1 Board"
		tooltipRows = 2

		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Trowel

	hammer
		name = "Hammer"
		icon = 'code/Tools/Hammer.dmi'
		icon_state = "item"

		desc = "Used in smithing and woodworking<br />\
				1 Board"
		tooltipRows = 2

		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Hammer

	pickaxe
		name = "Pickaxe"
		icon = 'code/Tools/Pickaxe.dmi'
		icon_state = "item"

		desc = "Used to gather minerals from deposits<br />\
				1 Board"
		tooltipRows = 2

		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Pickaxe

	knife
		name = "Knife"
		icon = 'code/Tools/Knife.dmi'
		icon_state = "item"

		desc = "Used to craft and skin dead animals<br />\
				1 Board"
		tooltipRows = 2

		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Knife

	shovel
		name = "Shovel"
		icon = 'code/Tools/Shovel.dmi'
		icon_state = "item"

		desc = "Used to dig up dirt and sand<br />\
				1 Board"
		tooltipRows = 2

		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Shovel

	hoe
		name = "Hoe"
		icon = 'code/Tools/Hoe.dmi'
		icon_state = "item"

		desc = "Used to plow fields for farming<br />\
				1 Board"
		tooltipRows = 2

		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Hoe

	spool
		name = "Spool"
		icon = 'code/Tools/Needle&Thread.dmi'
		icon_state = "item"

		desc = "Used to make thread<br />\
				1 Log"
		tooltipRows = 2

		req = list(	LOG		=	1)
		built = /obj/Item/Tools/NeedleThread

	brush
		name = "Brush"
		icon = 'code/Tools/Brush.dmi'
		icon_state = "item"

		desc = "Used to cure fur to make leather<br />\
				1 Log"
		tooltipRows = 2

		req = list(	LOG		=	1)
		built = /obj/Item/Tools/Brush

	spoon
		name = "Spoon"
		icon = 'code/Tools/Spoon.dmi'
		icon_state = "item"

		desc = "Used in cooking<br />\
				1 Board"
		tooltipRows = 2
		req = list(	BOARD	=	1)
		built = /obj/Item/Tools/Spoon

	torch
		name = "Handheld Torch"
		icon = 'code/Tools/Torch.dmi'
		icon_state = "item"

		desc = "Portable light!<br />\
				1 Log<br />\
				4 Phluf"
		tooltipRows = 3

		req = list(	LOG		=	1,
					PHLUF	=	4)
		built = /obj/Item/Tools/Torch

	staff
		name = "Staff"
		icon = 'code/Tools/Staff.dmi'
		icon_state = "item"

		desc = "Used to herd passive animals<br />\
				2 Logs"
		tooltipRows = 2

		req = list(	LOG		=	2)
		built = /obj/Item/Tools/Staff

	paddle
		name = "Paddle"
		icon = 'code/Ship System/Paddle.dmi'
		icon_state = "item"

		desc = "Equip one in either hand to row boats<br />\
				2 Boards"
		tooltipRows = 2

		req = list(	BOARD	=	2)
		built = /obj/Item/Tools/Paddle

	fishing_rod
		name = "Fishing Rod"
		icon = 'code/Tools/Fishing Rod.dmi'
		icon_state = "item"

		desc = "Gone Fishin'<br />\
				2 Logs<br />\
				1 Thread"
		tooltipRows = 3

		req = list(	LOG		=	2,
					THREAD	=	1)
		built = /obj/Item/Tools/Fishing_Rod

	twang
		name = "Twang"
		icon = 'code/music/twang.dmi'
		icon_state = "item"

		desc = "Serenade that pretty girl you've been eyeing!<br />\
				2 Boards<br />\
				2 Logs<br />\
				5 Thread"
		tooltipRows = 4

		req = list( BOARD	=	2,
					LOG		=	2,
					THREAD	=	5)
		built = /obj/Item/Tools/Instrument/Twang

	bloo
		name = "Bloo"
		icon = 'code/music/bloo.dmi'
		icon_state = "item"

		desc = "Ne'er a sound so sweet as the bloo!<br />\
				1 Log<br />\
				2 Boards<br />\
				1 Stone"
		tooltipRows = 4

		req = list( BOARD	=	2,
					LOG		=	1,
					STONE	=	1)
		built = /obj/Item/Tools/Instrument/Bloo

	dum
		name = "Dum"
		icon = 'code/music/dum.dmi'
		icon_state = "item"

		desc = "The dums of war are sounding!<br />\
				3 Boards<br />\
				3 Nails<br />\
				2 Thread<br />\
				1 Leather"
		tooltipRows = 5

		req = list( BOARD	=	3,
					NAIL	=	3,
					THREAD	=	2,
					LEATHER	=	1)
		built = /obj/Item/Tools/Instrument/Dum

	shield
		name = "Shield"
		icon = 'code/Weapons/Wooden Shield.dmi'
		icon_state = "item"

		desc = "The defense of the peasantry<br />\
				2 Boards<br />\
				2 Logs<br />\
				1 Stone"
		tooltipRows = 4

		req = list( BOARD	=	2,
					LOG		=	2,
					STONE	=	1)
		built = /obj/Item/Weapons/Wooden_Shield

	kite_shield
		name = "Kite Shield"
		icon = 'code/Weapons/Wooden Kite Shield.dmi'
		icon_state = "item"

		desc = "The defense of the peasantry<br />\
				3 Boards<br />\
				3 Logs<br />\
				2 Stone"
		tooltipRows = 4

		req = list( BOARD	=	3,
					LOG		=	3,
					STONE	=	2)
		built = /obj/Item/Weapons/Wooden_Kite