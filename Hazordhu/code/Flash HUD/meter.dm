/*
mob/player
	var tmp/hud/meter/test_meter/test_meter

	PostLogin()
		test_meter = new (src)
		test_meter.Show()
		spawn TestMeter()
		..()

	proc/TestMeter()
		for()
			sleep world.tick_lag
			test_meter.SetPercent((cos(world.time * 10) + 1) / 2 * 100)

hud/meter
	test_meter
		dir = NORTH
		x = 10
		y = 10
		length = 128
		width = 16

		Build()
			..()
			SetForegroundColor("blue")
			SetBackgroundColor("gray")
			for(var/hud/meter/part/part in parts)
				part.alpha = 0

		Show()
			..()
			for(var/hud/meter/part/part in parts)
				animate(part, alpha = 255, time = 1)

		Hide()
			..()
			for(var/hud/meter/part/part in parts)
				animate(part, alpha = 0, time = 1)
*/

hud/meter
/*

	A HUD meter is like a bar, but much more precise.

*/
	// screen position in tiles
	var x = 1
	var y = 1

	// pixel offset from x, y
	var pixel_x = 0
	var pixel_y = 0

	var dir = EAST	// a cardinal direction (not yet supported)
	var length = 32	// how far in the dir it goes
	var width = 8	// how wide it is, perpendicular to the length

	var parts[]
	var hud/meter/part
		background/bg
		foreground/fg

	var client/client

	var is_visible = FALSE

	New(Client)
		client = Client
		if(ismob(client))
			var mob/m = client
			client = m.client
		Build()

	proc/Build()
		bg = new (src)
		fg = new (src)
		parts = list(bg, fg)
		SetPosition(x, y, pixel_x, pixel_y)
		SetSize(length, width)

	proc/SetPosition(X, Y, Px, Py)
		x = X
		y = Y
		pixel_x = Px
		pixel_y = Py
		for(var/hud/meter/part/part in parts)
			part.Moved()

	proc/SetSize(L, W)
		length = L
		width = W
		for(var/hud/meter/part/part in parts)
			part.Resized()

	proc/SetDir(D)
		dir = D
		SetSize(length, width)

	proc/SetForegroundColor(C) fg.color = C
	proc/SetBackgroundColor(C) bg.color = C

	proc/Show()
		if(is_visible) return
		is_visible = TRUE
		client.screen += parts

	proc/Hide()
		if(!is_visible) return
		is_visible = FALSE
		client.screen -= parts

	// P is in 0 to 100
	proc/SetPercent(P)
		fg.SetPercent(P)

	proc/SetValue(Value, MaxValue)
		fg.SetPercent(Value / MaxValue * 100)

	part
		parent_type = /obj
		layer = 200
		icon = 'hud icons 32.dmi'
		icon_state = "meter"

		// the parent of this part
		var hud/meter/meter

		New(Meter)
			meter = Meter

		proc/Resized()
		proc/Moved() screen_loc = "[meter.x]:[meter.pixel_x],[meter.y]:[meter.pixel_y]"

		background
			/*

				The Background of a HUD Meter stays a constant size, representing the full size of the meter.

			*/
			Resized()
				var matrix/t = new
				t.Scale(meter.length / 32, meter.width / 32)
				t.Translate((32 - meter.length) / 2, (32 - meter.width) / 2 - 16)
				transform = t

		foreground
			/*

				The Foreground of a HUD Meter changes in length according to the value of the meter.
				It's a bit smaller than the background.

			*/
			layer = 200.1
			var percent = 1

			Resized()
				var matrix/t = new
				var width = (meter.length - 2) * percent
				var height = (meter.width - 2)
				t.Scale(width / 32, height / 32)
				t.Translate((32 - meter.length) / 2, (32 - meter.width) / 2)
				t.Translate(round((percent - 1) * meter.length / 2, 1), -16)
				transform = t

			proc/SetPercent(P) // P in 0 to 100
				percent = clamp(P / 100, 0, 1)
				Resized()
