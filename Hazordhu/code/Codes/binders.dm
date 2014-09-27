client
	DblClick(object)	if(!(!istype(object, /obj/Built/Boat) && (locate(/obj/Item/binders/Handcuffs) in mob.binders))) ..()
	MouseDrag()			if(!(locate(/obj/Item/binders/Handcuffs) in mob.binders)) ..()
mob/NPC/Move()			return !(locate(/obj/Item/binders/Footcuffs) in binders) && ..()

mob
	var binders[4]

	//	Removing binders
	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		if(!istype(src, /mob/Animal))
			if((over_control == "inventory.inventorygrid" || over_object == usr))
				if(bounds_dist(src, usr) > 4) return
				usr.remove_binder(src)
				return
		..()

	proc/remove_binder(mob/m)
		var obj/Item/binders/a = input(src, "What binder will you remove?") as null|obj in m.binders
		if(!a) return
		if(binders[3] && a != binders[3]) return
		if(a && a.remove(m, src))
			if(src != usr)
				usr << "You remove \the [a] from [usr.nameShown(src)]."
				src << "[nameShown(usr)] removes \the [a] from you."
			else
				src << "You remove \the [a] from yourself."
			src.InventoryGrid()

obj
	Item/binders
		Stackable = 0
		gender = NEUTER

		//	Putting on binders
		use(mob/m) if(loc == m)
			var mob/target
			for(target in m.front())
				if(istype(target, /mob/Animal))
					continue

				var found_other
				for(var/obj/Item/binders/b in target.binders)
					if(b.type == type)
						found_other = 1
						break
				if(found_other)
					continue

				break
			if(!target) return

			m << "You attempt to put \a [src] on [m.nameShown(target)]."
			target << "[target.nameShown(m)] attempts to put \a [src] on you."

			target.Locked = 1
			m.Locked = 1
			m.status_overlay("lock", 100)
			sleep(100)
			m.Locked = 0
			target.Locked = 0

			if(target == m)
				m << "You put \a [src] on yourself."
				add(m)
				m.InventoryGrid()

			else
				if((m.KO || prob(50)) && add(target))
					m << "You put \a [src] on [m.nameShown(target)]."
					target << "[target.nameShown(m)] put \a [src] on you."
					m.InventoryGrid()
				else
					m << "You fail to put \a [src] on [m.nameShown(target)]."
					target << "[m.nameShown(m)] failed to put \a [src] on you."

		proc
			add(mob/m)
				set_loc(m.binders)
				var/I=image(icon,"overlay",layer = FLOAT_LAYER)
				overlayo = I
				m.overlays += overlayo
				m.overlays2 += overlayo

			remove(mob/m, atom/a)
				if(src in m.binders)
					set_loc(a)
					m.overlays -= overlayo
					m.overlays2 -= overlayo


		Handcuffs
			icon = 'code/Smithing/handcuffs.dmi'
			gender = PLURAL
			var id

			New(x, string)
				..()
				if(!id)
					id = string
					name = "\improper Handcuffs \[[id]]"

			add(mob/m)
				..()
				m.binders[3] = src
				return 1

			remove(mob/m)
				for(var/obj/Item/Metal/Key/key in usr)
					if(key.id == id || !key.id)
						..()
						m.binders[3] = null
						return 1

		Footcuffs
			icon = 'code/Smithing/footcuffs.dmi'
			gender = PLURAL
			var id

			New(x, string)
				..()
				if(!id)
					id = string
					name = "\improper Footcuffs \[[id]]"

			add(mob/humanoid/m)
				..()
				m.binders[4] = src
				if(m.mount)
					m.mount.dismount(m)	//	m falls off mount
				return 1

			remove(mob/m)
				for(var/obj/Item/Metal/Key/key in usr)
					if(key.id == id || !key.id)
						..()
						m.binders[4] = null
						return 1

		Muzzle
			name = "\improper Muzzle"
			icon = 'code/Tailoring/muzzle.dmi'
			can_color = TRUE

			add(mob/m)
				..()
				m.binders[1] = src
				return 1

			remove(mob/m)
				..()
				m.binders[1] = null
				return 1

		Blindfold
			name = "\improper Blindfold"
			icon = 'code/Tailoring/blindfold.dmi'
			screen_loc = "CENTER"
			can_color = TRUE
			Click()
				if(src in usr.client.screen)
					if(usr.binders[3] == null)
						remove(usr, usr)
						usr.InventoryGrid()

			add(mob/m)
				..()
				m.binders[2] = src
				if(m.client)
					m.sight |= BLIND
					m.client.screen += src
				return 1

			remove(mob/m)
				..()
				m.binders[2] = null
				if(m.client)
					m.sight &= ~BLIND
					m.client.screen -= src
				return 1