//	This allows mobs that can open doors to actually open doors according to their pathfinding.
obj/Built/Doors
	Cross(mob/NPC/npc)
		if(istype(npc) && npc.opens_doors)
			return TRUE
		return ..()

	Crossed(mob/NPC/npc)
		if(istype(npc) && npc.opens_doors && density)
			open()
		return ..()

mob
	player
		moved()
			. = ..()
			var nearby[] = ohearers(src)
			if(locate(/mob/NPC) in nearby)
				for(var/mob/NPC/npc in nearby)
					if(npc.new_ai)
						game_loop.add(npc)

	NPC
		var
			new_ai = TRUE

			tmp
				image/aggro_marker
				mob/mortal/target

				turf/move_target
				next_move

				attacked = FALSE
				next_tick

				next_search

			friendly_types[0]

			strength = 0
			defense = 0

			//	How far away the NPC has to be to attack (in pixels)
			attack_range = 2
			attack_delay = 30

			//	If an open window comes between the NPC and the target it'll fire an arrow. (non-zero values are how far it can fire)
			ranged_attack = FALSE

			//	How long between AI cycles.
			ai_delay = 0.1

			//	If the NPC will open doors when encountered.
			opens_doors = TRUE

			//	Will follow blood trails.
			follow_blood = FALSE

			//	Its commander if it is reanimated by a player
			leader

		New()
			..()
			if(new_ai)
				game_loop.add(src)

		Write()
			if(aggro_marker)
				overlays -= aggro_marker
			..()

		die()
			overlays -= aggro_marker()
			..()

		proc/aggro_marker()
			if(!aggro_marker)
				aggro_marker = image('code/Icons/aggressive.dmi', layer = FLOAT_LAYER)
			return aggro_marker

		proc/tick()
			if(world.time < next_tick) return
			next_tick = world.time + ai_delay

			if(!loc)
				game_loop.remove(src)
				return

			if(move_target)
				step_to(src, move_target)
				if(bounds_dist(src, move_target) <= step_size)
					move_target = null

			if(target)
				if(!is_valid_target())
					target = null
					return

				dir = get_dir(src, target)
				overlays += aggro_marker()
				spawn(world.tick_lag)
					overlays -= aggro_marker

				if(ranged_attack)
					if(shooting)
						SET_STEP_SIZE(1)
					else
						SET_STEP_SIZE(2)

					var dist = get_dist(src, target)
					if(dist < ranged_attack)
						if(!move_target)
							move_target = pick(nearby_turfs(5) - target.nearby_turfs(3))
					else if(dist > ranged_attack)
						if(!move_target)
							move_target = pick(target.nearby_turfs(2))

				else
					SET_STEP_SIZE(2)
					move_target = null
					step_to(src, target)

				attack_target()

			else
				SET_STEP_SIZE(1)
				search_for_target()

		proc/is_valid_target(mob/m)
			m = m || target
			if(!is_humanoid(m)) return FALSE
			if(m.GodMode || m.Dead) return FALSE
			if(m.Race == Race) return FALSE
			if(m.client && m.key == leader)	return FALSE
			if(leader && istype(m, /mob/NPC) && m:leader == leader)	return FALSE
			if(get_dist(src, m) >= 10) return FALSE
			if(m.type in friendly_types) return FALSE
			return TRUE

		proc/search_for_target()
			if((!target || prob(10)) && world.time >= next_search)
				if(!playerFound())
					game_loop.remove(src)
					return

				next_search = world.time + randn(10, 30)

				var valid_targets[0]
				for(var/mob/m in ohearers(5, src))
					if(is_valid_target(m))
						valid_targets += m

				if(valid_targets.len)
					target = pick(valid_targets)
					return

				if(follow_blood)
					var obj/Blood/blood
					var nearby[] = oview(5, src)
					if(locate(/obj/Blood) in nearby)
						for(blood in oview(5, src))
							if(get_dist(src, blood) < 3) continue
							break
						if(blood)
							move_target = blood.loc

			if(world.time >= next_move && !move_target)
				next_move = world.time + randn(50, 100)

				if(loc)
					var turfs[] = nearby_turfs(3)
					if(turfs.len)
						move_target = pick(turfs)

		//	Returns TRUE on a successful attack.
		proc/attack_target()
			if(attacked) return
			if(!ranged_attack)
				if(z == target.z && bounds_dist(src, target) <= attack_range)
					attacked = 1
					spawn(attack_delay) attacked = 0
					attack(target)
					return TRUE

			else
				var dist = get_dist(src,target)
				if(dist >= 2 && dist <= ranged_attack)
					fire_ranged()
					attacked = 1
					spawn(attack_delay / 3) attacked = 0

		proc/get_attacked(mob/attacker)
			if(attacker.type == src.type)
				return

			if(target)
				if(target != attacker)
					if(get_dist(src,attacker) < get_dist(src,target))
						target = attacker

		// Called when the NPC kills someone.
		proc/killed_target(mob/killed)
			target = null

		proc/fire_ranged()
			if(attacked) return
			if(!target) return
			if(!is_equipped(/obj/Item/Weapons/archery))
				equip(new /obj/Item/Weapons/archery/Bow (src))

			if(!shooting)
				archery_pull()
			else
				var angle = vec2_angle(vec2(target.cx() - cx(), target.cy() - cy()))
				shoot(angle)
				archery_stop()