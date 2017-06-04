
mob
	player
		move_tick()
			..()
			if(storage && storage.loc != src)
				var distance = bounds_dist(src, storage)
				if(distance > 24)
					stop_storage()

	var tmp/obj/storage
	proc/stop_storage()
		if(!storage) return
		storage.hide_storage(src)

obj
	var is_storage
	var Items = 0
	var Item_Limit = 100

	proc/show_storage(mob/player/m)
		if(!is_storage) return
		if(!istype(m)) return
		m.stop_storage()
		m.storage = src
		m.StorageGrid()
		m.status_overlay("bag")
		#if THIN_SKIN
		m.storage_grid.show()
		#else
	//	winshow(m, "child_br_off")
		winset(m, "inventory_child", "bottom=storage")
		m.show_items()
		#endif
		return TRUE

	proc/hide_storage(mob/player/m)
		if(!is_storage) return
		if(!istype(m)) return
		m.status_overlay_remove("bag")
		m.storage = null
		#if THIN_SKIN
		m.storage_grid.hide()
		#else
	//	winshow(m, "child_br_off", 0)
		winset(m, "inventory_child", "bottom=")
		#endif
		return TRUE

	proc/can_store(obj/Item/item)
		return TRUE

	//	post-transfer events
	proc/stored(obj/Item/item)
	proc/unstored(obj/Item/item)

	proc/toggle_storage(mob/player/m)
		if(m.storage == src)
			hide_storage(m)
		else show_storage(m)

	interact(mob/player/m)
		if(boat)
			var obj/Built/Boat/b = boat
			if(boat.take_off(src))
				m.emote("takes the [src] off of the [b]")

		else if(is_storage)
			toggle_storage(m)

		else return ..()

	Item
		use(mob/player/m)
			if(is_storage)
				toggle_storage(m)
			else return ..()

		Clothing
			Back
				Quiver
					is_storage = TRUE
					can_store(obj/Item/item)
						if(istype(item, /obj/Item/Projectile/Arrow)) return TRUE
						if(istype(item, /obj/Item/Projectile/Bolt)) return TRUE
						return FALSE

			Bag
				icon_state = "item"
				is_storage = TRUE

				can_store(item)
					if(istype(item, /obj/Item/Projectile/Arrow)) return FALSE
					if(istype(item, /obj/Item/Projectile/Bolt)) return FALSE
					if(istype(item, /obj/Item/Clothing/Bag)) return FALSE
					return ..()

				Pouch
					icon = 'code/Clothes/Pouch.dmi'
					Item_Limit = 15
				Sack
					icon = 'code/Clothes/Sack.dmi'
					Item_Limit = 25
				Bag
					icon = 'code/Clothes/Bag.dmi'
					Item_Limit = 50

				use_alt(mob/player/m)
					if(m.is_equipped(/obj/Item/Tools/Quill))
						var obj/Item/Alchemy/Bottle/Potion/Ink/ink = locate() in m
						if(!ink)
							m.aux_output("You need ink to label the bag.")
							return
						m.used_tool()
						var label = input(m, "What will you label this bag? (Up to 10 characters)", "Bag Label") as null|text
						if(!label)
							name = "Bag"
							return
						label = html_encode(copytext(label, 1, 10))
						name = "Bag ([label])"
					else return ..()

	Built
		Bookshelf
			icon = 'code/woodworking/Bookshelf.dmi'
			density = TRUE
			Flammable = TRUE
			SET_TBOUNDS("3,2 to 30,8")
			step_y = 8
			base_health = 50
			is_storage = TRUE
			Item_Limit = 25
			can_store(obj/Item/Book/book) return istype(book)
			stored() update()
			unstored() update()
			proc/update()
				if(Items < 1)
					icon_state = ""
				else if(Items > 16)
					icon_state = "17-24"
				else if(Items > 8)
					icon_state = "9-16"
				else icon_state = "[Items]"


		Garbage
			is_storage = TRUE
			Item_Limit = 25

		Storage
			density = TRUE
			base_health = 800
			Flammable = TRUE
			is_storage = TRUE

			Cart
				icon = 'code/Woodworking/Cart.dmi'
				var Puller
				SET_BOUNDS(6, 4, 20, 20)
				animate_movement = FORWARD_STEPS
				SET_STEP_SIZE(16)

				interact_right(mob/player/m)
					m._pull_cart(src)

				Bumped(mob/humanoid/m)
					if(istype(m))
						if(src == m.pulling_cart) return
						dir = get_dir(m, src)
						step(src, dir, m.step_size)

			Chest
				SET_TBOUNDS("6,10 to 28,18")

				icon = 'code/Woodworking/Chest.dmi'
				var obj/haslock
				var tmp/lookers[0]

				New()
					..()
					if(istext(haslock))
						var/obj/Item/Metal/Lock/lock = new
						lock.id = haslock
						lock.name = "Lock \[[lock.id]]"
						haslock = new
						lock.Move(haslock)
						overlays += lock.icon
					else haslock = new

				show_storage(mob/player/m)
					if(is_locked() && !interact_right(m))
						m.aux_output("The chest is locked.")
						return
					. = ..()
					if(.)
						lookers |= m
						icon_state = "open"

				hide_storage(mob/player/m)
					. = ..()
					if(.)
						lookers -= m
						clean_list(lookers)
						if(!lookers.len)
							icon_state = "chest_closed"

				interact_right(mob/humanoid/m)
					var obj/Item/Metal/Lock/lock = has_lock()
					if(!lock) return
					if(lock.find_key(m))
						toggle_lock()
						return TRUE

				proc/has_lock()
					if(!haslock) return
					return locate(/obj/Item/Metal/Lock) in haslock

				proc/toggle_lock()
					if(is_locked())
						unlock()
					else
						if(icon_state == "open")
							for(var/mob/player/m in lookers)
								hide_storage(m)
						lock()

				proc/is_locked() return icon_state == "chest_locked"
				proc/lock() icon_state = "chest_locked"
				proc/unlock() icon_state = "chest_closed"

				proc/remove_lock(mob/m)
					if(icon_state != "chest_closed") return
					var obj/Item/Metal/Lock/lock = has_lock()
					if(!lock) return
					if(lock.find_key(m))
						lock.Move(m)
						icon_state = ""
						name = "[initial(name)]"