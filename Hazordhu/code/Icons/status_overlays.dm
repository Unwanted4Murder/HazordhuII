mob
	var tmp/status_overlays[]
	var tmp/status_active[]

	proc
		status_overlay(status as text, delay)
			set waitfor = FALSE

			if(!status_active)
				status_active = new

			if(status in status_active)
				return

			if(!status_overlays)
				status_overlays = icon_states('status.dmi')

			//	safety
			if(!(status in status_overlays))
				CRASH("Invalid status_overlay: [status]")

			//	the icon doesn't exist yet
			if(!status_overlays[status])
				var image/i = image('status.dmi', src, status, 99)
				i.pixel_x = 16
				i.pixel_y = 16
				status_overlays[status] = i

			overlays += status_overlays[status]
			status_active += status

			if(delay)
				sleep delay
				status_overlay_remove(status)

		status_overlay_remove(status as text)
			if(status in status_active)
				overlays -= status_overlays[status]

				if(status_active.len == 1)
					status_active = null
				else status_active -= status

		status_refresh()
			for(var/t in status_active)
				overlays -= status_overlays[t]
				overlays += status_overlays[t]

		status_clear()
			for(var/t in status_active)
				overlays -= status_overlays[t]