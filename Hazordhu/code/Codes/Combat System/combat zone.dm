
mob
	var tmp
		image/combat_zone_indicator
		combat_zone[]

	proc
		combat_zone()
			if(client)
				if(!combat_zone)
					update_combat_zone()
				return combat_zone

		update_combat_zone()
			if(!loc) return
			if(!client) return

			client.images -= combat_zone_indicator
			combat_zone = null

			if(!combat_mode) return

			var angle = client.mouse.angle

			if(!client.mouse.over)
				angle = dir2angle(dir)

			#if PIXEL_MOVEMENT

			if(!combat_zone_indicator)
				combat_zone_indicator = image(
					icon = 'attack zone.dmi',
					icon_state = "2",
					loc = src, layer = 100)

			//	combat_zone_indicator.blend_mode = BLEND_ADD

			var image/i = combat_zone_indicator
			i.alpha = 128

			var matrix/m = new
			m.Translate(0, 14)
			m.Turn(angle)
			m.Scale(1, 3/4)
			m.Translate(0, -12)
			i.transform = m

			if(combat_mode) client.images += i

			var dx = sin(angle) * 16
			var dy = cos(angle) * 14 + 2

			combat_zone = obounds(src, dx - 2, dy - 4, -bound_width + 16, -bound_height + 10)

			#else

			if(!combat_zone_indicator) combat_zone_indicator = image('code/codes/combat system/attack zone.dmi', icon_state = "dir", loc = src, layer = 100)
			var combat_dir = angle2dir(angle)
			var image/i = combat_zone_indicator

			i.dir = dir
			i.pixel_x = (combat_dir & 12) ? (combat_dir & EAST ? 16 : -16) : 0
			i.pixel_y = (combat_dir & 3) ? (combat_dir & NORTH ? 16 : -16) : -8
			i.transform = turn(matrix(), round(angle, 45))

			if(combat_mode) client.images += i

			var turf/ahead = get_step(src, combat_dir)
			if(ahead)
				combat_zone = ahead.contents.Copy()

			else
				combat_zone = list()

			#endif

			combat_zone -= mount
