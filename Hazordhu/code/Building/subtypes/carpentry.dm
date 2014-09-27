builder/carpentry
	main_tool = /obj/Item/Tools/Hammer
	skill = CARPENTRY
	cursor = "hammer"
	density = TRUE

	log_wall
		name = "Log Wall"
		icon = 'code/Woodworking/Log Wall.dmi'

		desc = "A primitive wall made from logs<br />\
				3 logs"
		tooltipRows = 2

		req	= list(	LOG		=	3)
		built = /obj/Built/Log_Wall
	log_door
		name = "Log Door"
		icon = 'code/Woodworking/Log Door.dmi'

		desc = "A primitive door made from logs<br />\
				5 logs"
		tooltipRows = 2

		req	= list(	LOG		=	5)
		built = /obj/Built/Doors/Log_Door

	log_window
		name = "Log Window"
		icon = 'code/Woodworking/Log Window.dmi'

		desc = "A primitive window made from logs<br />\
				4 logs"
		tooltipRows = 2

		req	= list(	LOG		=	4)
		built = /obj/Built/Log_Window

	wall
		name = "Wooden Wall"
		icon = 'code/Woodworking/Wall.dmi'

		desc = "A wall made from boards and nails<br />\
				2 Nails<br />\
				3 Boards"
		tooltipRows = 3

		req = list( NAIL	=	2,
					BOARD	=	3)
		built = /obj/Built/Wall

	door
		name = "Wooden Door"
		icon = 'code/Woodworking/Door.dmi'

		desc = "It opens, and it closes!<br />\
				3 Nails<br />\
				3 Boards"
		tooltipRows = 3

		req = list( NAIL	=	3,
					BOARD	=	3)
		built = /obj/Built/Doors/Door

	window
		name = "Wooden Window"
		icon = 'code/Woodworking/Window.dmi'

		desc = "It opens, and it closes!<br />\
				4 Nails<br />\
				4 Boards"
		tooltipRows = 3

		req = list( NAIL	=	4,
					BOARD	=	4)
		built = /obj/Built/Window

	floor
		name = "Wooden Floor"
		icon = 'code/Woodworking/Floor.dmi'

		desc = "A definite step-up from dirt<br />\
				2 Nails<br />\
				3 Boards"
		tooltipRows = 3

		req = list( NAIL	=	2,
					BOARD	=	3)
		built = /obj/Built/Floor

		density = FALSE

	fence
		name = "Fence"
		icon = 'code/Woodworking/Fence.dmi'

		desc = "Keep people out.. Or in<br />\
				2 Nails<br />\
				2 Boards"
		tooltipRows = 3

		req = list(	NAIL	=	2,
					BOARD	=	2)
		built = /obj/Built/Fence

	Gate
		name = "Gate"
		icon = 'code/Woodworking/Gate.dmi'
		dir  = EAST

		desc = "It's like a fence, but it opens!<br />\
				2 Nail<br />\
				2 Boards"
		tooltipRows = 3

		req = list(	NAIL	=	2,
					BOARD	=	2)
		built = /obj/Built/Doors/Gate

	orc_pallisade_wall
		name = "Orc Pallisade Wall"
		icon = 'code/Woodworking/Orc Pallisade.dmi'

		desc = "A Fireproof pallisade wall<br />\
				5 Logs<br />\
				3 Bricks<br />\
				1 Tar"
		tooltipRows = 4
		allowed_races = ORC

		req = list(	LOG		=	5,
					BRICK	=	3,
					TAR		=	1)
		built = /obj/Built/Orc_Pallisade_Wall

	pallisade_wall
		name = "Pallisade Wall"
		icon = 'code/Woodworking/Pallisade Wall.dmi'
		group_only = 1

		desc = "A heavy duty wooden defense structure<br />\
				5 Logs"
		tooltipRows = 2

		req = list(	LOG		=	5)
		built = /obj/Built/Pallisade_Wall

	pallisade_gate
		name = "Pallisade Gate"
		icon = 'code/Woodworking/Pallisade Door.dmi'

		desc = "A heavy duty wooden defense gate<br />\
				5 Logs"
		tooltipRows = 2

		req = list(	LOG		=	5)
		built = /obj/Built/Doors/Pallisade_Door

	bridge
		name = "Wooden Bridge"
		icon = 'code/Woodworking/Wall.dmi'
		icon_state = "Bridge"

		desc = "Built on water to allow passage<br />\
				5 Boards<br />\
				3 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	5,
					NAIL	=	3)
		built = /obj/Built/Bridge
		valid_loc(turf/t) return is_water(t)

		density = FALSE

	stocks
		name = "Stocks"
		icon = 'code/Woodworking/Stocks.dmi'
		group_only = 1

		desc = "Used to humiliate miscreants<br />\
				4 Nails<br />\
				6 Boards"
		tooltipRows = 3

		req	= list(	NAIL	=	4,
				   	BOARD	=	6)
		built = /obj/Built/Stocks

	wheel
		name = "Water Wheel"
		icon = 'code/Woodworking/Water Wheel.dmi'

		desc = "Built in water to keep grinding stones spinning<br />\
				4 Boards<br />\
				2 Nails"
		tooltipRows = 4

		req = list(	BOARD	=	4,
					NAIL	=	2)
		built = /obj/Built/Water_Wheel
		valid_loc(turf/Environment/Water/w) return istype(w)

	support_beam
		name = "Support Beam"
		icon = 'code/Woodworking/Support Beam.dmi'

		desc = "A beam used to support tunnels and prevent<br />\
				cave-ins<br />\
				1 Nail<br />\
				2 Boards"
		tooltipRows = 4

		req	= list(	NAIL	=	1,
				   	BOARD	=	2)
		built = /obj/Built/Support_Beam

	bed
		name = "Bed Frame"
		icon = 'code/Woodworking/Bed.dmi'

		desc = "A homely touch for intellectuals<br />\
				4 Boards<br />\
				3 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	4,
					NAIL	=	3)
		built = /obj/Built/Bed

	table
		name = "Table"
		icon = 'code/Woodworking/Table.dmi'
		pixel_y = -8

		desc = "For all your placing needs<br />\
				3 Logs<br />\
				6 Nails<br />\
				3 Boards"
		tooltipRows = 4

		req = list( LOG		=	3,
					NAIL	=	6,
					BOARD	=	3)
		built = /obj/Built/Table

	stool
		name = "Stool"
		icon = 'code/Woodworking/Furniture.dmi'
		icon_state = "2"

		desc = "A touch of homely comfort<br />\
				2 Logs<br />\
				4 Nails<br />\
				2 Boards"
		tooltipRows = 4

		req = list( LOG		=	2,
					NAIL	=	4,
					BOARD	=	2)
		built = /obj/Built/Stool

		density = FALSE

	chair
		name = "Chair"
		icon = 'code/Woodworking/Furniture.dmi'
		icon_state = "3"

		desc = "A touch of homely comfort, with a back!<br />\
				2 Logs<br />\
				5 Nails<br />\
				3 Boards"
		tooltipRows = 5

		req = list( LOG		=	2,
					NAIL	=	5,
					BOARD	=	3)
		built = /obj/Built/Chair

		density = FALSE

	throne
		name = "Throne"
		icon = 'code/Woodworking/Throne.dmi'
		group_only = 1

		desc = "An expensive touch of homely comfort!<br />\
				10 Hazium Bars<br />\
				5 Boards<br />\
				3 Nails<br />\
				2 Crystalized Haziums"
		tooltipRows = 6

		req = list(	HBAR	=	10,
					NAIL	=	3,
					BOARD	=	5,
					CHAZ	=	2)
		built = /obj/Built/Throne

	counter
		name = "Counter"
		icon = 'code/Woodworking/Counter.dmi'

		desc = "Looks best with a woman in front of it!<br />\
				3 Boards<br />\
				2 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	3,
					NAIL	=	2)
		built = /obj/Built/Counter

	cooking_range
		name = "Cooking Range"
		icon = 'code/Woodworking/Counter.dmi'
		icon_state = "Cook"

		desc = "Used for cooking.  Go figure!<br />\
				8 Boards<br />\
				6 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	8,
					NAIL	=	6)
		built = /obj/Built/Range
/*
	sink
		name = "Sink"
		icon = 'code/woodworking/counter.dmi'
		icon_state = "Sink"
		desc = "A water source that turns on and off.<br>\
				5 Boards<br>\
				3 Nails<br>\
				2 Bars"
		req = list(	BOARD	=	5,
					NAIL	=	3,
					BAR		=	2)
		built = /obj/Built/Sink
*/
	breakdown
		name = "Breakdown Counter"
		icon = 'code/Woodworking/Counter.dmi'
		icon_state = "Breakdown"

		desc = "Used to extract elements from materials<br />\
				3 Boards<br />\
				2 Nails"
		tooltipRows = 4

		req = list(	BOARD	=	3,
					NAIL	=	2)
		built = /obj/Built/Counter/Breakdown

	chest
		name = "Chest"
		icon = 'code/Woodworking/Chest.dmi'

		desc = "Where ye' be keepin' yer booty!<br />\
				2 Nails<br />\
				3 Boards"
		tooltipRows = 3

		req = list( NAIL	=	2,
					BOARD	=	3)
		built = /obj/Built/Storage/Chest

	sign
		name = "Wooden Sign"
		icon = 'code/Woodworking/Sign.dmi'

		desc = "A simple sign which can be written on<br />\
				1 Nail<br />\
				2 Boards"
		tooltipRows = 3

		req = list( NAIL	=	1,
					BOARD	=	2)
		built = /obj/Built/Sign

	rowboat
		name = "Rowboat"
		icon = 'code/Ship System/Boat.dmi'
		allowed_races = HUMAN

		desc = "Used to traverse water<br />\
				10 Boards<br />\
				5 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	10,
					NAIL	=	5)
		built = /obj/Built/Boat

	canoe
		name = "Canoe"
		icon = 'code/Ship System/Canoe.dmi'

		desc = "Used to traverse water<br />\
				10 Boards<br />\
				5 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	10,
					NAIL	=	5)
		built = /obj/Built/Boat/Canoe

	tether
		name = "Tether Post"
		icon = 'code/Woodworking/Tether Post.dmi'

		desc = "Used to tie up animals to keep them from<br />\
				running off<br />\
				1 Log<br />\
				1 Rope"
		tooltipRows = 4

		req = list(	LOG		=	1,
					ROPE	=	1)
		built = /obj/Built/Tether_Post

	garbage
		name = "Garbage Bin"
		icon = 'code/Woodworking/Garbage.dmi'

		desc = "Used to destroy unwanted items<br />\
				1 Nail<br />\
				2 Boards"
		tooltipRows = 3

		req	= list(	NAIL	=	1,
				   	BOARD	=	2)
		built = /obj/Built/Garbage

	tanning_frame
		name = "Tanning Frame"
		icon = 'code/Hunting/Tanning Frame.dmi'

		desc = "Used to process fur into other materials<br />\
				1 Nail<br />\
				2 Boards<br />\
				1 Thread"
		tooltipRows = 4

		req = list( NAIL	=	1,
					BOARD	=	2,
					THREAD	=	1)
		built = /obj/Built/Tanning_Frame

	nest
		name = "Nest"
		icon = 'code/Animals/Nests.dmi'
		icon_state = "race"

		desc = "The birthplace of any good family<br />\
				3 Logs<br />\
				5 Phluf"
		tooltipRows = 3

		req = list( LOG		=	3,
					PHLUF	=	5)
		built = /obj/Built/Nest

	cart
		name = "Cart"
		icon = 'code/Woodworking/Cart.dmi'

		desc = "Portable storage space<br />\
				2 Nails<br />\
				3 Boards"
		tooltipRows = 3

		req = list( NAIL	=	2,
					BOARD	=	3)
		built = /obj/Built/Storage/Cart

	bucket
		name = "Bucket"
		icon = 'code/Woodworking/Bucket.dmi'

		desc = "Used to carry liquids<br />\
				1 Nail<br />\
				2 Boards"
		tooltipRows = 3

		req = list(	NAIL	=	1,
					BOARD	=	2)
		built = /obj/Item/Bucket

	barrel
		name = "Barrel"
		icon = 'code/Woodworking/Barrel.dmi'

		desc = "Fish in this are easy to shoot!<br />\
				3 Nails<br />\
				5 Boards"
		tooltipRows = 3

		req = list(	NAIL	=	3,
					BOARD	=	5)
		built = /obj/Built/Barrel


	bookshelf
		name = "Bookshelf"
		icon = 'code/Woodworking/Bookshelf.dmi'

		allowed_races = HUMAN

		desc = "A homely touch for intellectuals<br />\
				3 Boards<br />\
				2 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	3,
					NAIL	=	2)
		built = /obj/Built/Bookshelf

	wooden_shield
		name = "Wooden Shield"
		icon = 'code/Weapons/Wooden Shield.dmi'
		icon_state = "item"

		desc = "Suitable for quick defense<br />\
				3 Boards<br />\
				2 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	3,
					NAIL	=	2)
		built = /obj/Item/Weapons/Wooden_Shield

		density = FALSE

	wooden_kite
		name = "Wooden Kite"
		icon = 'code/Weapons/Wooden Kite Shield.dmi'
		icon_state = "item"

		desc = "A slightly less quick defense<br />\
				5 Boards<br />\
				3 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	5,
					NAIL	=	3)
		built = /obj/Item/Weapons/Wooden_Kite

		density = FALSE

	combat_dummy
		name = "Combat Dummy"
		icon = 'code/Woodworking/Combat Dummy.dmi'

		desc = "Get your smash on!<br />\
				2 Boards<br />\
				2 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	2,
					NAIL	=	2)
		built = /obj/Built/Combat_Dummy

	target
		name = "Archery Target"
		icon = 'code/Woodworking/Target.dmi'

		desc = "Notch, pull, release!<br />\
				2 Boards<br />\
				1 Nail"
		tooltipRows = 3

		req = list(	BOARD	=	2,
					NAIL	=	1)
		built = /obj/Built/Target

	grinding_platform
		name = "Grinding Platform"
		icon = 'code/Woodworking/Grinding Stone.dmi'

		desc = "Used to sharpen weapons and tools<br />\
				3 Boards<br />\
				2 Nails"
		tooltipRows = 3

		req = list(	BOARD	=	3,
					NAIL	=	2)
		built = /obj/Built/Grinding_Platform

	torch
		name = "Torch"
		icon = 'code/Woodworking/Torch.dmi'

		desc = "Let there be light!<br />\
				2 Logs<br />\
				2 Phluf"
		tooltipRows = 3

		req = list(	LOG		=	2,
					PHLUF	=	2)
		built = /obj/Built/Torch

	headpike
		name = "Headpike"
		icon = 'code/Woodworking/headpike.dmi'
		group_only = 1

		desc = "Show them who runs this land!<br />\
				2 Logs<br />\
				1 Metal Bar"
		tooltipRows = 3

		allowed_races = ORC

		req = list(	LOG		=	2,
					BAR		=	1)
		built = /obj/Built/Headpike

	barricade
		name = "Barricade"
		icon = 'code/Woodworking/Barricade.dmi'
		group_only = 1

		desc = "A defensive structure which deals damage<br />\
				when bumped<br />\
				4 Logs"
		tooltipRows = 3

		req = list(	LOG		=	4)
		built = /obj/Built/Barricade


	skin_wall_fur
		name = "Fur Wall"
		icon = 'code/Woodworking/skin_wall.dmi'
		icon_state = "fur"
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				4 Boards<br />\
				2 Fur"
		tooltipRows = 3

		req = list(	BOARD	=	4,
					FUR		=	2)
		built = /obj/Built/skin_wall/Fur_Wall

	skin_door_fur
		name = "Fur Door"
		icon = 'code/Woodworking/skin_doors/fur_door.dmi'
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				5 Boards<br />\
				3 Fur"
		tooltipRows = 3

		req = list(	BOARD	=	5,
					FUR		=	3)
		built = /obj/Built/Doors/skin_door/fur


	skin_wall_grawl
		name = "Grawl Fur Wall"
		icon = 'code/Woodworking/skin_wall.dmi'
		icon_state = "grawl"
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				4 Boards<br />\
				2 Grawl Fur"
		tooltipRows = 3

		req = list(	BOARD	=	4,
					GFUR	=	2)
		built = /obj/Built/skin_wall/Grawl_Fur_Wall

	skin_door_grawl
		name = "Grawl Fur Door"
		icon = 'code/Woodworking/skin_doors/grawl_fur.dmi'
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				5 Boards<br />\
				3 Grawl Fur"
		tooltipRows = 3

		req = list(	BOARD	=	5,
					GFUR		=	3)
		built = /obj/Built/Doors/skin_door/grawl

	skin_wall_ngrawl
		name = "North Grawl Fur Wall"
		icon = 'code/Woodworking/skin_wall.dmi'
		icon_state = "ngrawl"
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				4 Boards<br />\
				2 North Grawl Fur"
		tooltipRows = 3

		req = list(	BOARD	=	4,
					NGFUR	=	2)
		built = /obj/Built/skin_wall/North_Grawl_Fur_Wall

	skin_door_ngrawl
		name = "North Grawl Fur Door"
		icon = 'code/Woodworking/skin_doors/ngrawl_fur.dmi'
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				5 Boards<br />\
				3 North Grawl Fur"
		tooltipRows = 3

		req = list(	BOARD	=	5,
					NGFUR		=	3)
		built = /obj/Built/Doors/skin_door/ngrawl


	skin_wall_orc
		name = "Orc Skin Wall"
		icon = 'code/Woodworking/skin_wall.dmi'
		icon_state = "orc"
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				4 Boards<br />\
				2 Orc Skin"
		tooltipRows = 3

		req = list(	BOARD	=	4,
					OSKIN	=	2)
		built = /obj/Built/skin_wall/Orc_Skin_Wall

	skin_door_orc
		name = "Orc Skin Door"
		icon = 'code/Woodworking/skin_doors/orc_skin.dmi'
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				5 Boards<br />\
				3 Orc Skin"
		tooltipRows = 3

		req = list(	BOARD	=	5,
					OSKIN	=	3)
		built = /obj/Built/Doors/skin_door/orc

	skin_wall_human
		name = "Human Skin Wall"
		icon = 'code/Woodworking/skin_wall.dmi'
		icon_state = "human"
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				4 Boards<br />\
				2 Human Skin"
		tooltipRows = 3

		req = list(	BOARD	=	4,
					HSKIN	=	2)
		built = /obj/Built/skin_wall/Human_Skin_Wall

	skin_door_human
		name = "Human Skin Door"
		icon = 'code/Woodworking/skin_doors/human_skin.dmi'
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				5 Boards<br />\
				3 Human Skin"
		tooltipRows = 3

		req = list(	BOARD	=	5,
					HSKIN	=	3)
		built = /obj/Built/Doors/skin_door/human

	skin_wall_flargl
		name = "Flargl Skin Wall"
		icon = 'code/Woodworking/skin_wall.dmi'
		icon_state = "flargl"
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				4 Boards<br />\
				2 Flargl Skin"
		tooltipRows = 3

		req = list(	BOARD	=	4,
					FSKIN	=	2)
		built = /obj/Built/skin_wall/Flargl_Skin_Wall

	skin_door_flargl
		name = "Flargl Skin Door"
		icon = 'code/Woodworking/skin_doors/flargl_skin.dmi'
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				5 Boards<br />\
				3 Flargl Skin"
		tooltipRows = 3

		req = list(	BOARD	=	5,
					FSKIN	=	3)
		built = /obj/Built/Doors/skin_door/flargl

	skin_wall_troll
		name = "Troll Skin Wall"
		icon = 'code/Woodworking/skin_wall.dmi'
		icon_state = "troll"
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				4 Boards<br />\
				2 Troll Skin"
		tooltipRows = 3

		req = list(	BOARD	=	4,
					TSKIN	=	2)
		built = /obj/Built/skin_wall/Troll_Skin_Wall

	skin_door_troll
		name = "Troll Skin Door"
		icon = 'code/Woodworking/skin_doors/troll_skin.dmi'
		group_only = 1
		allowed_races = ORC

		desc = "High tech tribal walls!<br />\
				5 Boards<br />\
				3 Troll Skin"
		tooltipRows = 3

		req = list(	BOARD	=	5,
					TSKIN	=	3)
		built = /obj/Built/Doors/skin_door/troll