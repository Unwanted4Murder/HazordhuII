client/mouse_pointer_icon = 'pointer.dmi'

var cursors[0]

world/New()
	..()
	for(var/a in icon_states('pointer.dmi'))
		cursors[a] = fcopy_rsc(icon('pointer.dmi', a))

mob
	Corpse
		MouseEntered()
			..()
			mouse_over_pointer = cursors["knife"]

	Animal
		Sty
			MouseEntered()
				..()
				mouse_over_pointer = cursors["scissors"]
atom
	var cursor = ""

	MouseEntered()
		if(cursor)
			mouse_over_pointer = cursors[cursor]
		..()

obj

	Nest
		cursor = "grab"

	Built
		Boat
			cursor = "paddle"

		Torch
			cursor = "hand"

		Tether_Post
			cursor = "hand"

		Forge
			cursor = "tongs"

		Signs
			cursor = "eye"

		Doors
			cursor = "hand"
			MouseEntered(location,control,params)
				..()
				var/list/plist = params2list(params)
				if("ctrl" in plist)
					mouse_over_pointer = cursors["knock"]

		Window
			cursor = "hand"

		Stone_Window
			cursor = "hand"

		Sandstone_Window
			cursor = "hand"

		Storage
			cursor = "hand"

		Grinding_Stone
			cursor = "hand"

		Garbage
			cursor = "hand"

	Item
		cursor = "grab"

		Wood
			Log
				cursor = "hatchet"

	Mining
		cursor = "pickaxe"

	Woodcutting
		cursor = "hatchet"


turf
	Environment
		Water
			MouseEntered()
				..()
				if(icon == 'code/Turfs/Ice.dmi' && icon_state == "")
					mouse_over_pointer = cursors["chisel"]