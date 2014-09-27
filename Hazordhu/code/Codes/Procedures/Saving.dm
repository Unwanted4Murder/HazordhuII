mob
	Admin/verb/Save_Players()
		world << "Saving all players..."
		global.SavePlayers()
		world << "All players saved."

	player
		proc/save_path()
			return "Data/Players/[ckey].sav"

		proc/Save()
			if(Made)
				var path = save_path()

				if(fexists(path)) fdel(path)

				var savefile/F = new (path)
				Write(F)

				if(x && y && z)
					F["lastx"]	<<	x
					F["lasty"]	<<	y
					F["lastz"]	<<	z
					F["lastsx"] << step_x
					F["lastsy"] << step_y
				F["lastdir"]	<<	dir

				F["icon"]		<<	null
				F["overlays"]	<<	null
				F["underlays"]	<<	null

				return TRUE

		proc/Load()
		#if !PLAYERSAVE
			return TRUE
		#endif
			var path = save_path()
			if(fexists(path))
				var savefile/F = new (path)
				Read(F)

				var lastx, lasty, lastz, lastdir, lastsx, lastsy
				F["lastx"] >> lastx
				F["lasty"] >> lasty
				F["lastz"] >> lastz
				F["lastsx"] >> lastsx
				F["lastsy"] >> lastsy
				F["lastdir"] >> lastdir

				set_loc(locate(lastx, lasty, lastz), lastsx, lastsy)
				dir = lastdir

				if(mount)
					mount.set_loc(loc)
					mount.rider = null
					mount.mount(src)

				var mob/humanoid/h = src
				if(istype(h)) for(var/obj/Item/binders/b in h.binders) b.add(src)

				return TRUE

proc/SavePlayers() for(var/mob/player/M in Players) M.Save()