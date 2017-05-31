#if NEW_RUNES
var const/RUNE_CODE_LENGTH = 6
var const/RUNES = 18

mob/player
	var
		tmp
			hud
				rune_set/rune_set_hud
				rune_stone/rune_stone_hud

			obj/Item/Rune_Stone/rune_stone

	proc/ShowRuneSet(Runes[])
		if(!rune_set_hud) rune_set_hud = new (client)
		rune_set_hud.SetRunes(Runes)
		rune_set_hud.Show()

	proc/HideRuneSet()
		if(!rune_set_hud) return
		rune_set_hud.Hide()

	proc/ToggleRuneStone(RuneStone)
		if(rune_stone_hud && rune_stone_hud.is_visible)
			HideRuneStone()
		else ShowRuneStone(RuneStone)

	proc/ShowRuneStone(RuneStone)
		rune_stone = RuneStone
		if(!rune_stone_hud) rune_stone_hud = new (client)
		rune_stone_hud.ClearRunes()
		rune_stone_hud.Show()

	proc/HideRuneStone()
		rune_stone = null
		if(rune_stone_hud) rune_stone_hud.Hide()


hud/rune_set
/*
	This is the display that pops up when you inspect a rune circle or obelisk.
	It contains the set of runes that correspond to the thing.
*/
	var client/client
	var parts[] // contains all the /objs to be displayed
	var runes[] // determines the runes to be displayed
	var is_visible = FALSE

	New(Client)
		client = Client
		Build()

	proc/Build() // build the hud
		parts = new (RUNE_CODE_LENGTH)
		for(var/n in 1 to RUNE_CODE_LENGTH)
			var hud/rune_set/part/rune/rune = new (src)
			parts[n] = rune
			rune.screen_loc = "CENTER:[16*(n - (RUNE_CODE_LENGTH - 1) / 2)-8], CENTER-1:8"

		for(var/hud/rune_set/part/part in parts) part.alpha = 0

	proc/Show() // show the hud
		if(is_visible) return
		is_visible = TRUE
		client.screen += parts
		for(var/hud/rune_set/part/part in parts) animate(part, alpha = 255, time = 5)

	proc/Hide() // hide the hud
		if(!is_visible) return
		is_visible = FALSE
		for(var/hud/rune_set/part/part in parts) animate(part, alpha = 0, time = 5)
		spawn(5) if(!is_visible) client.screen -= parts

	proc/SetRunes(Runes[]) // set the set of runes to display
		runes = Runes.Copy()
		for(var/n in 1 to runes.len)
			var hud/rune_set/part/rune/rune = parts[n]
			rune.SetRune(runes[n])

	part
		parent_type = /obj
		mouse_opacity = FALSE

		var hud/rune_set/hud

		New(HUD)
			hud = HUD

		rune
			layer = 206
			icon = 'runes.dmi'

			var rune
			var image/symbol

			proc/SetRune(Rune)
				rune = Rune
				if(symbol) overlays -= symbol
				else
					symbol = new
					symbol.icon = runes.GetIcon()
					symbol.layer = FLOAT_LAYER
				symbol.icon_state = runes.GetIconState(rune)
				overlays += symbol

hud/rune_stone
/*
	This is the interface of the rune stone device.
	It contains buttons for the player to press, including
	- the runes (5, 4, 2, 4, 3)
	- the center activation gem

	It's 5x5 in 16x16-pixel tiles (80x80 pixels)
*/
	var client/client
	var parts[] // contains all the /objs to be displayed, such as runes and the background
	var active_runes[] // the active runes
	var is_visible = FALSE

	var moved_x = 0
	var moved_y = 0

	New(Client)
		client = Client
		Build()
		for(var/hud/rune_stone/part/part in parts)
			part.HUDMove(-34, -34)

	proc/Build()
		var global/positions[] = list(5, 78, 78, 78, 51, 79, 63, 73, 73, 63, 79, 51, 79, 34, 73, 19, 63, 9, 51, 5, 34, 5, 19, 9, 9, 19, 5, 34, 5, 51, 9, 63, 19, 73, 34, 79)

		parts = new (RUNES + 2)
		for(var/n in 1 to RUNES)
			var hud/rune_stone/part/rune/rune = new /hud/rune_stone/part/rune (src, n)
			parts[n] = rune
			rune.hud_x = positions[n * 2 - 1]
			rune.hud_y = positions[n * 2]
			rune.UpdateHUDPosition()

		parts[parts.len - 1] = new /hud/rune_stone/part/gem (src)
		parts[parts.len] = new /hud/rune_stone/part/back (src)

		for(var/hud/rune_stone/part/part in parts) part.alpha = 0

	proc/Move(Dx, Dy)
		var ax = moved_x
		var ay = moved_y
		moved_x = clamp(moved_x + Dx, -200, 200)
		moved_y = clamp(moved_y + Dy, -200, 200)
		var dx = moved_x - ax
		var dy = moved_y - ay
		for(var/hud/rune_stone/part/part in parts)
			part.HUDMove(dx, dy)

	proc/Show()
		if(is_visible) return
		is_visible = TRUE
		client.screen += parts
		for(var/hud/rune_stone/part/part in parts) animate(part, alpha = 255, time = 1)

	proc/Hide()
		if(!is_visible) return
		is_visible = FALSE
		for(var/hud/rune_stone/part/part in parts) animate(part, alpha = 0, time = 1)
		spawn(5) client.screen -= parts

	// when a button is pushed
	proc/AddRune(hud/rune_stone/part/rune/Rune)
		if(active_runes)
			if(active_runes.len == RUNE_CODE_LENGTH) return
			if(Rune in active_runes) return
		else active_runes = new
		Rune.Down()
		active_runes += Rune

	// after the activation gem is pressed
	proc/ClearRunes()
		for(var/hud/rune_stone/part/rune/rune in active_runes) rune.Up()
		active_runes = null

	// when the activation gem is pressed
	proc/Activate()
		if(active_runes && active_runes.len == RUNE_CODE_LENGTH)
			var mob/player/player = client.mob
			player.rune_stone.Activate(player, GetRuneCode())
		ClearRunes()

	proc/GetRuneCode()
		var code[RUNE_CODE_LENGTH]
		for(var/n in 1 to code.len)
			var hud/rune_stone/part/rune/rune = active_runes[n]
			code[n] = rune.rune
		return list2params(code)

	part
		parent_type = /obj
		icon = 'rune stone symbols.dmi'

		var hud/rune_stone/hud

		// a pixel offset from CENTER,CENTER
		var hud_x = 0
		var hud_y = 0

		New(HUD)
			hud = HUD
			UpdateHUDPosition()

		MouseDrag()
			..()
			hud.Move(usr.client.mouse.move_x, usr.client.mouse.move_y)

		proc/HUDMove(Dx, Dy)
			hud_x += Dx
			hud_y += Dy
			UpdateHUDPosition()

		proc/UpdateHUDPosition()
			screen_loc = "CENTER:[hud_x],CENTER:[hud_y]"

		back
			// this is the background, looks like the rune stone item
			layer = 205
			icon = 'full rune stone.dmi'
			hud_x = 1
			hud_y = 1

		rune
			// this is a button on the stone
			layer = 206

			var rune
			var image/symbol

			New(HUD, Rune)
				..()
				SetRune(Rune)
				Up()

			Click() hud.AddRune(src)
			proc/Up() dir = SOUTH
			proc/Down() dir = NORTH
			proc/SetRune(Rune)
				rune = Rune
				icon_state = runes.GetIconState(rune)

		gem
			// activation gem in the center of the rune stone
			layer = 207
			icon_state = "gem"
			hud_x = 40
			hud_y = 40

			Click() hud.Activate()


var runes/runes = new
runes
	var values[]
	var codes[]

	proc/GetIcon() return 'runes.dmi' // icon of the rune symbols

	proc/GetIconState(Value) return "[Value]" // icon state corresponding to the value

	proc/GetValues()
		if(!values)
			values = new (RUNES)
			for(var/n in 1 to values.len) values[n] = n
		return values

	proc/GetNewCode()
		/*
			Rune codes are 6 symbols long with no repeated symbols from 18 total symbols.
			= 13,366,080 combinations.
		*/
		var code[0]
		var params
		do
			code.len = 0
			for(var/n in 1 to RUNE_CODE_LENGTH) code += pick(GetValues() - code)
			params = list2params(code)
		while(params in codes)
		if(!codes) codes = new
		codes += params
		return params

	proc/LinkCode(Object, Code)
		if(!codes) codes = new
		codes[Code] = Object
		return Code

	proc/Locate(Code)
		return codes[Code]
#endif
