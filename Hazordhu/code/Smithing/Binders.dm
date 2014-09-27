mob
	can_interact(o) return (o in binders) || ..()
	can_drop(o) return !(o in binders) && ..()
	can_move() return !footcuffs() && ..()

	var binders[0]
	proc/muzzle()    return binders.len && (locate(/obj/Item/binders/Muzzle) in binders)
	proc/blindfold() return binders.len && (locate(/obj/Item/binders/Blindfold) in binders)
	proc/handcuffs() return binders.len && (locate(/obj/Item/binders/Handcuffs) in binders)
	proc/footcuffs() return binders.len && (locate(/obj/Item/binders/Footcuffs) in binders)

	//	Removing binders
	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		if(over_control == "inventory.inventorygrid" || over_object == usr)
			if(bounds_dist(src, usr) > 4) return
			if(usr.remove_binder(src)) return
		..()

	proc/remove_binder(mob/m)
		if(!length(m.binders)) return
		var obj/Item/binders/binder = input(src, "What binder will you remove?") as null|anything in m.binders
		if(!binder || handcuffs() && handcuffs() != binder) return
		if(binder.remove(m, src))
			if(src != m)
				src << "You remove \the [binder] from [nameShown(m)]."
				m << "[m.nameShown(src)] removes \the [binder] from you."
			else m << "You remove \the [binder] from yourself."
			return TRUE

obj
	Item/binders
		Stackable = 0
		gender = NEUTER

		MouseDrop(mob/humanoid/target)
			var mob/m = usr
			if(loc == m && istype(target) && bounds_dist(m, target) <= 4)
				if(locate(type) in target.binders)
					if(target == m)
						m << "You're already bound."
					else m << "[m.nameShown(target)] is already bound."
					return

				if(m.handcuffs())
					m << "Your handcuffs prevent you from doing that."
					return

				if(target == m)
					if(add(m))
						m << "You put \a [src] on yourself."
					else m << "You failed to put \a [src] on yourself."

				else
					m << "You attempt to put \a [src] on [m.nameShown(target)]."
					target << "[target.nameShown(m)] attempts to put \a [src] on you."
					m.Locked = TRUE
					target.Locked = TRUE
					m.status_overlay("lock", 100)
					sleep 100
					target.Locked = FALSE
					m.Locked = FALSE
					if((m.KO || prob(50)) && add(target))
						m << "You put \a [src] on [m.nameShown(target)]."
						target << "[target.nameShown(m)] put \a [src] on you."
						m.InventoryGrid()
					else
						m << "You fail to put \a [src] on [m.nameShown(target)]."
						target << "[m.nameShown(m)] failed to put \a [src] on you."
				return

		use(mob/m)
			if(src in m.binders)
				if(remove(m, m))
					m << "You remove \the [src] from yourself."
				else m << "You fail to remove \the [src] from yourself."

		proc/add(mob/m, mob/adder)
			if(ismob(adder) && adder.handcuffs())
				adder << "Your handcuffs prevent you from doing that."
				return

			if(src in m.binders) return

			m.binders |= src
			loc = m
			overlayo = image(icon,"overlay", layer = FLOAT_LAYER)
			m.overlays += overlayo
			added(m)
			m.InventoryGrid()
			return TRUE

		proc/remove(mob/m, mob/remover)
			if(ismob(remover) && remover.handcuffs() && src != remover.handcuffs())
				remover << "Your handcuffs prevent you from doing that."
				return

			if(src in m.binders)
				m.binders -= src
				m.overlays -= overlayo
				set_loc(remover)
				is_player(remover) && remover.InventoryGrid()
				removed(m, remover)
				return TRUE

		proc/added(mob/m)
		proc/removed(mob/m, atom/a)

		Handcuffs
			icon = 'code/Smithing/handcuffs.dmi'
			gender = PLURAL
			var id
			New(x, string)
				..()
				if(!id)
					id = string
					name = "\improper Handcuffs \[[id]]"

		Footcuffs
			icon = 'code/Smithing/footcuffs.dmi'
			gender = PLURAL
			var id
			New(x, string)
				..()
				if(!id)
					id = string
					name = "\improper Footcuffs \[[id]]"

		Muzzle
			name = "\improper Muzzle"
			icon = 'code/Tailoring/muzzle.dmi'
			can_color = TRUE

		Blindfold
			name = "\improper Blindfold"
			icon = 'code/Tailoring/blindfold.dmi'
			screen_loc = "CENTER"
			can_color = TRUE

			//	When put on, it goes in client.screen
			//	Can be clicked from the screen to be removed, if not handcuffed
			added(mob/m)
				m.sight |= BLIND
				m.client.screen |= src

			removed(mob/m, atom/remover)
				m.sight &= ~BLIND
				m.client.screen -= src