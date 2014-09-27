mob
	var tmp/attacking = FALSE

	proc/is_attackable(mob/mortal/m)
		if(!(istype(m) || istype(m, /obj/Built))) return FALSE

		if(!m.attackable) return FALSE

		if(is_player(m))
			var mob/player/p = m
			if(p.GodMode) return FALSE

		if(istype(m, /obj/Built))
			if(m == boat) return FALSE

			//	check deeds
			var obj/Built/b = m
			if(istype(b)) for(var/turf/t in b.locs) for(var/PropertyDeed/deed in t.deeds) if(!deed.can_destroy(src)) return FALSE

			//	check totems
			for(var/obj/Built/Totem/t) if(t.active && t.z == m.z && abs(t.x - m.x) <= t.range && abs(t.y - m.y) <= t.range) return FALSE

		return TRUE

	proc/attack(target)
		set waitfor = FALSE
		var mob/player/player = src
		if(istype(player))
			if(!player.pvp)
				src << "Your combat has been disabled."
				return

		if(handcuffs())
			src << "Your handcuffs restrict your combat."
			return

		//	attack floors last
		var floors[0]
		var ahead[0]
		for(var/atom/o in combat_zone())
			if(istype(o, /obj/Built/Floors))
				floors += o
			else ahead += o
		ahead += floors

		if(GodMode)
			for(var/mob/mortal/m in ahead)
				m.die(src)
				return

			for(var/obj/Built/B in ahead)
				if(B.Health)
					var obj/Built/fence_part/c = B
					if(istype(c))
						del c.parent
					else del B
					return

		else
			if(!attacking)
				attacking = TRUE
				spawn(5) attacking = FALSE

				var mob/targ = target

				if(!targ)
					for(var/mob/Animal/m in ahead)
						targ = m
						break

				if(!targ)
					for(var/mob/mortal/m in ahead)
						if(!is_attackable(m)) continue
						targ = m
						break

				if(targ)
					var mob/mortal/m = targ
					if(client && m.client)
						combat_log << "\[[time2text(world.realtime)]] [name] ([key]) attacked [m.name] ([m.key])\n"
						var mob/player/a = src
						var mob/player/b = m
						a.log_action("attacked [b.key] ([b.charID])")
						b.log_action("attacked by [a.key] ([a.charID])")

					else if(istype(m, /mob/NPC))
						var mob/NPC/N = m
						if(N.new_ai) N.get_attacked(src)

					var combat/battle = new(src, m)
					var result = battle.result
					if(result)
						if(istext(result))
							switch(result)
								if("parry")
									m.emote("parries the attack")
									m.view_sound(sound('code/Sounds/steel slash.wav'))
								if("block")
									m.emote("blocks the attack")
									m.view_sound(sound('code/Sounds/sword slash.wav'))

						if(isnum(result))
							result = bonus_check(m, result)
							if(is_npc(src)) result /= 2
							if(result < 1) result = 1

							view_sound(pick(
								'code/Sounds/steel slash.wav',
								'code/Sounds/sword slash.wav',
								'code/Sounds/hit.wav'))

							if(is_humanoid(src))
								var mob/humanoid/h = src
								h.used_weapon()

							if(prob(result)) m.Bleed(src)

							//	PvP: Knock out before killing
							if(is_player(src) && is_player(m))
								if(!m.KO)
									if(m.Health - result <= 0)
										m.set_health(1)
										m.aux_output("You have been knocked unconscious!")
										aux_output("You have knocked [nameShown(m)] unconscious!")
										m.KO()
										return

							m.take_damage(result, src)

				for(var/obj/Built/b in ahead)
					if(istype(b, /obj/Built/fence_part))
						var obj/Built/fence_part/c = b
						if(c.parent)
							b = c.parent
							ahead -= b
							ahead -= c.parent.children
						else del c

					if(!is_attackable(b)) continue

					var combat/battle = new(src, b)
					var result = battle.result
					if(result && isnum(result))
						view_sound(pick(
							'code/Sounds/hit.wav',
							'code/Sounds/sword slash.wav',
							'code/Sounds/smith1.wav'))

						if(b.Health > 0) b.take_damage(result, src)
					return

				//	empty swing
				if(!targ) view_sound('code/Sounds/arrow 1.wav')