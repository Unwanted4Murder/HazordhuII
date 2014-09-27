mob/Animal
	Cross(mob/m)
		if(m == rider) return TRUE
		return ..()

mob
	var mob/Animal/mount
	Cross(mob/Animal/m)
		if(m == mount) return TRUE
		return ..()

	proc/mount_animal(mob/Animal/animal)
		if(animal)
			if(animal == mount)
				dismount_animal()
				return

			if(boat)
				return

			if(mount && mount != animal)
				aux_output("You're already riding something.")
				return

			if(is_equipped(/obj/Item/Weapons/Tower_Shield))
				aux_output("Your shield is too large for you to mount.")
				return

			return animal.mount(src)

	proc/dismount_animal()
		if(mount)
			return mount.dismount(src)


obj/Item/Tailoring/Harness
	icon = 'code/Hunting/Harness.dmi'
	proc/place(mob/Animal/a, mob/m)
		if(loc == m && !m.Locked)
			if(!a) return

			if(!a.can_harness)
				m.aux_output("You can't put a harness on [a].")
				return

			if(locate(type) in a)
				m.aux_output("[a] already has a harness on.")
				return

			m.emote("attempts to harness [a]")
			m._do_work(30)

			if(prob(75))
				m.emote("successfully harnesses [a]")
				var obj/Item/o = Drop(m)
				o.Get(a)

				overlayo = icon(icon, a.name)
				a.overlays += overlayo

			else
				m.emote("fails to harness [a]")
				step_away(a, m)

mob/Animal
	var
		can_harness = TRUE
		posted

		tmp
			mob/humanoid/rider
			mount_offset_x = 0
			mount_offset_y = 8

	Olihant
	//	mount_offset_x = 16
		mount_offset_y = 38

	Grawl
		mount_offset_y = 11

	proc/is_harnessed()
		return locate(/obj/Item/Tailoring/Harness) in src

	proc/remove_harness(mob/m)
		if(!rider && !posted && !on_boat)
			var obj/Item/Tailoring/Harness/h = locate() in src
			if(h && (h.Get(m) || h.Drop(src)))
				m.emote("takes the harness off of [src]")
				if(locate(/obj/Item/Armour) in src)
					m.emote("takes the armor off of [src]")
					for(var/obj/Item/Armour/A in src) A.Drop(src)
				overlays = null

	proc/mount(mob/humanoid/m) if(istype(m))
		if(!can_harness)
			return

		if(!is_harnessed())
			m.aux_output("You need to put a harness around [src] to ride it.")
			return

		if(rider)
			m.aux_output("Someone is riding this already.")
			return

		if(boat && !boat.get_off(src))
			return

		rider = m
		m.mount = src
		m.emote("gets on the [src]")
		m.set_loc(loc, step_x, step_y)
		m.pixel_x = mount_offset_x
		m.pixel_y = mount_offset_y
		m.dir = dir

		if(posted)
			posted = FALSE
			Locked = FALSE
		return TRUE

	proc/dismount(mob/humanoid/m)
		if(!m) m = rider
		if(istype(m))
			if(rider != m || m.mount != src)
				return FALSE
			m.mount = null
			m.emote("gets off the [src]")
			m.set_loc(loc, step_x, step_y)
			m.pixel_y = 0
			rider = null
			return TRUE