obj/Built
	Windows
		density = TRUE
		opacity = TRUE
		var open_state = "open"
		var closed_state = ""
		interact()
			if(opacity)
				icon_state = open_state
				opacity = FALSE
			else
				icon_state = closed_state
				opacity = TRUE
			changed_opacity()

	Floors
		density = FALSE
		layer = TURF_LAYER + 1
		New()
			..()
			if(istype(loc, /turf/Environment/Lava)) if(Flammable) del src
			for(var/obj/Built/bridge in loc) if(findtext(bridge.name, "bridge")) del bridge
			for(var/obj/footprint/f in loc) f.set_loc()

	Doors
		density = TRUE
		opacity = TRUE

		SET_BOUNDS(0, 0, 32, 32)

		var Locked = FALSE
		var open_state = "open"
		var closed_state = "closed"
		var locked_state = "locked"

		proc/open()
			if(Locked) return
			icon_state = open_state
			density = FALSE
			opacity = FALSE
			changed_opacity()
			return TRUE

		proc/close()
			icon_state = closed_state
			density = TRUE
			opacity = initial(opacity)
			changed_opacity()
			return TRUE

		proc/toggle() is_open() ? close() : open()

		proc/is_open() return icon_state == open_state

		proc/has_lock() return locate(/obj/Item/Metal/Lock) in src

		proc/lock()
			close()
			icon_state = locked_state
			Locked = TRUE

		proc/unlock()
			icon_state = closed_state
			Locked = FALSE

		proc/toggle_lock()
			if(Locked)
				unlock()
			else lock()

		proc/remove_lock(mob/m, obj/Item/Metal/Key/key)
			var obj/Item/Metal/Lock/lock = has_lock()
			if(!lock) return
			if(Locked) return
			if(key.id == lock.id || !key.id)
				lock.Move(m)
				overlays -= lock.icon
				name = initial(name)

		interact_right(mob/player/m)
			var obj/Item/Metal/Lock/lock = has_lock()
			if(!lock) return
			if(lock.find_key(m))
				toggle_lock()
				return TRUE

		Door
			icon = 'code/Woodworking/Door.dmi'
			Flammable = TRUE
			base_health = 200

		Log_Door
			icon = 'code/Woodworking/Log Door.dmi'
			Flammable = TRUE
			base_health = 150

		Stone_Door
			name = "Brick Door"
			icon = 'code/Masonry/Stone Door.dmi'
			base_health = 400

		Sandstone_Door
			icon = 'code/Masonry/Sandstone Door.dmi'
			base_health = 300

		Barred_Gate
			icon = 'code/Smithing/Barred Gate.dmi'
			opacity = FALSE
			base_health = 400

		Gate
			icon = 'code/Woodworking/Gate.dmi'
			opacity = FALSE
			Flammable = TRUE
			base_health = 100

			var dir_checked = FALSE
			/savedatum/var
				gate_dir_checked

			save_to(savedatum/s)
				s.gate_dir_checked = dir_checked

			load_from(savedatum/s)
				dir_checked = s.gate_dir_checked

			New()
				..()
				if(!dir_checked)
					check_dir()
				set_dir(dir)

			crafted_by(mob/m)
				..()
				check_dir()

			proc/can_join_with(atom/movable/o)
				var d = get_dir(src, o)
				if(d & d - 1) return FALSE
				if(o == src) return FALSE
				if(o.type == type) return TRUE
				if(o.type == /obj/Built/Fence) return TRUE
				if(o.type == /obj/Built/fence_part) return TRUE
				if(!o.density) return FALSE
				if(istype(o, /turf/Environment))
					if(istype(o, /turf/Environment/Cave)) return TRUE
					if(istype(o, /turf/Environment/Cliffs)) return TRUE
				if(istype(o)) return !(o.bound_width < 32 || o.bound_height < 32)

			proc/check_dir()
				dir_checked = TRUE
				var atom/join_with
				var near[] = orange(1, loc)

				for(var/obj/Built/b in near)
					if(can_join_with(b))
						join_with = b
						break

				if(!join_with)
					for(join_with in near)
						if(can_join_with(join_with))
							break

				if(join_with)
					if(get_dir(src, join_with) & VERT)
						set_dir(NORTH)
					else set_dir(EAST)

					if(istype(join_with, /obj/Built/Fence))
						fenceJoin()

			set_dir()
				..()
				if(dir & HORI)
					SET_TBOUNDS("1,8 to 32,11")
				else
					SET_TBOUNDS("15,1 to 18,32")
					bottom_offset = 16
					update_layer()

		Pallisade_Door
			icon = 'code/Woodworking/Pallisade Door.dmi'
			Flammable = TRUE
			base_health = 200
			overlays = list(/obj/Built/Doors/Pallisade_Door/Pallisade_Door_Top)
			Pallisade_Door_Top
				icon = 'code/Woodworking/Pallisade Door Top.dmi'
				layer = MOB_LAYER + 3
				pixel_y = 32

		skin_door
			name = "Skin Door"
			Flammable = TRUE
			base_health = 200
			fur
				name = "Fur Door"
				icon = 'code/Woodworking/skin_doors/fur_door.dmi'
			grawl
				name = "Fur Door"
				icon = 'code/Woodworking/skin_doors/grawl_fur.dmi'
			ngrawl
				name = "Fur Door"
				icon = 'code/Woodworking/skin_doors/ngrawl_fur.dmi'
			flargl
				icon = 'code/Woodworking/skin_doors/flargl_skin.dmi'
				Flammable = FALSE
			troll
				icon = 'code/Woodworking/skin_doors/troll_skin.dmi'
			human
				icon = 'code/Woodworking/skin_doors/human_skin.dmi'
			orc
				icon = 'code/Woodworking/skin_doors/orc_skin.dmi'


obj
	Item
		Mould
			icon = 'code/Smithing/Key.dmi'
			icon_state = "mold"
			Stackable = FALSE
			var id
			New(x, string)
				..()
				if(!id)
					id = string
					name = "Mould \[[id]]"

		Metal
			Keychain
				icon = 'code/Smithing/Keychain.dmi'
				Stackable = FALSE

				//	Detach a key
				use(mob/player) if(loc == player)
					var obj/Item/Metal/Key/k = input(player, "What key do you want to take off?") as null|obj in src
					if(k)
						k.Move(player)

				//	Remove locks with all attached keys
				use_alt(mob/player) if(loc == player)
					for(var/obj/Item/Metal/Key/k in src)
						k.use(player)

			Key
				icon = 'code/Smithing/Key.dmi'
				Stackable = FALSE

				var id
				New(x, string)
					..()
					if(!id)
						id = string
						name = "Key \[[id]]"

				MouseDrop(atom/over_object,src_location,over_location,src_control,over_control,params)
					if(loc == usr && istype(over_object, /obj/Item/Metal/Keychain) && over_object.loc == usr)
						return Move(over_object)
					..()

				use(mob/m) if(loc == m)
					var front[] = m.front()
					var obj/Built/Doors/d = locate() in front
					if(!d) d = locate(/obj/Built/Storage/Chest) in front
					if(d)  d.remove_lock(m, src)

			Lock
				icon = 'code/Smithing/Lock.dmi'
				var id
				Stackable = FALSE

				New(x, string)
					..()
					if(!id)
						id = string
						name = "Lock \[[id]]"

				use(mob/m) if(loc == m)
					var obj/Built/Doors/d = locate() in m.front()
					if(!d) d = locate(/obj/Built/Storage/Chest) in m.front()
					if(d)  place(d, m)

				proc/find_key(atom/loc)
					var keys[0]
					keys |= loc.contents
					for(var/obj/Item/Metal/Keychain/chain in loc)
						keys |= chain.contents
					for(var/obj/Item/Metal/Key/key in keys)
						if(!key.id || key.id == id)
							return key

				proc/place(atom/place_on, mob/m)
					if(istype(place_on, /obj/Built/Doors))
						var obj/Built/Doors/door = place_on
						if(door.contents.len)
							m << "There is already a lock on this door"
						else
							Move(door)
							door.overlays += icon
							door.name = "[door.name] \[[id]]"

							if(door.icon_state != "open")
								door.icon_state = "closed"

					if(istype(place_on, /obj/Built/Storage/Chest))
						var obj/Built/Storage/Chest/c = place_on
						if(c.icon_state == "chest_locked" || c.icon_state == "chest_open")
							m << "There is already a lock on this chest"
						else
							Move(c.haslock)
							c.overlays += icon
							c.name = "[c.name] \[[id]]"

							if(c.icon_state != "open")
								c.icon_state = "chest_closed"