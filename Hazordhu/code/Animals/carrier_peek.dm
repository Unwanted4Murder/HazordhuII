mob
	var
		tmp
			obj/peek_status

	Animal
		//	bird properties
		var tmp/flying = FALSE
		proc/start_flying()
			if(flying) return
			icon_state = "fly"
			flying = TRUE
			pixel_y = 8
			density = FALSE
			show_shadow()

		proc/stop_flying()
			if(!flying) return
			icon_state = ""
			flying = FALSE
			pixel_y = 0
			density = TRUE
			hide_shadow()

		var tmp/image/shadow
		var tmp/has_shadow = FALSE
		proc/show_shadow()
			if(has_shadow) return
			if(!shadow)
				shadow = new
				shadow.icon = 'peek shadow.dmi'
				shadow.layer = TURF_LAYER
			has_shadow = TRUE
			overlays += shadow

		proc/hide_shadow()
			if(shadow && has_shadow)
				overlays -= shadow
				has_shadow = FALSE

		Peek
			var
				obj/Item/Parchment/parchment
				owner_id

				tmp/mob/owner
				tmp/mob/target

			Cross(mob/Animal/Peek/peek) return !istype(peek) && ..()

			proc/tick()
				if(!owner_id)
					return

				if(target)
					walk(src, 0)
					return

				if(!owner)
					for(var/mob/player/p)
						if(p.charID == owner_id)
							owner = p
							break

				if(owner)
					walk(src, 0)
					var pos[] = center()
					var opos[] = owner.center()
					var dx = opos[1] - pos[1]
					var dy = opos[2] - pos[2]
					var r = sqrt(dx * dx + dy * dy)
					if(r > 16)
						if(r > 32) start_flying()
						var scale = 0.08
						dx *= scale
						dy *= scale
						move(vec2(dx, dy))
						dir = angle2dir(atan2(dx, dy))
					else
						stop_flying()
						if(r < 4)
							var scale = -0.08
							dx *= scale
							dy *= scale
							move(vec2(dx, dy))

				if(ai_active)
					if(flying)
						pixel_y = 8
						density = FALSE
						show_shadow()
					else
						pixel_y = 0
						density = TRUE
						hide_shadow()

			tamed(mob/player/m)
				..()
				m.aux_output("You can now right-click the peek to place a parchment on the peek to send messages to other people quickly. Right-clicking it again will allow you to select a target.")
				owner = m
				owner_id = m.charID
				game_loop.add(src)

			interact_right(mob/player/m)
				if(m != owner) return

				if(parchment) SetTarget(m)
				else
					var parchments[0]
					for(var/obj/Item/Parchment/p in m) parchments += p
					var obj/Item/Parchment/selected = input(m, "Which parchment do you want to attach to the carrier peek?", "Carrier") as null|anything in parchments
					if(!selected) return
					parchment = selected
					selected.Move(src)

			proc
				Recall()
					target = owner
					SeekTarget()

				SetTarget(mob/M)
					if(!parchment)
						M << "You must place a piece of parchment on the peek before setting a carrier target."
						return

					var valid_targets[0]
					for(var/mob/player/tar in Players)
						if(!tar.client) continue
						if(tar.GodMode) continue
						var ns = M.nameShown(tar)
						if(ns != tar.stranger_name())
							valid_targets[ns] = tar

					if(!valid_targets.len)
						M << "There is nobody around for you to send the peek to!"
						return

					var selected = input(M, "Who do you want to send this carrier peek to?") as null | anything in valid_targets
					if(!selected) return

					if(valid_targets[selected])
						target = valid_targets[selected]
						SeekTarget()

				SeekTarget()
					if(owner.client)
						if(!owner.peek_status)
							owner.peek_status = new
							owner.peek_status.icon = 'peek_status.dmi'
							owner.peek_status.icon_state = "orange"
							owner.peek_status.screen_loc = "NORTHEAST"
						screen_loc = "NORTHEAST"
						owner.client.screen |= src
						owner.client.screen |= owner.peek_status
					start_flying()
					while(target)
						walk(src, 0)

						if(target.z != src.z)
							Recall()
							break

						var pos[] = center()
						var opos[] = target.center()
						var dx = opos[1] - pos[1]
						var dy = opos[2] - pos[2]
						var r = sqrt(dx * dx + dy * dy)
						if(r > 16)
							if(r > 24)
								icon_state = "fly"
							var scale =  0.05
							dx *= scale
							dy *= scale
							move(vec2(dx, dy))
							dir = angle2dir(atan2(dx, dy))
						else break
						sleep world.tick_lag
					stop_flying()
					if(parchment && target && target != owner)
						target << "The carrier peek drops a message on you and flies away!"
						owner.peek_status.icon_state = "green"
						parchment.set_loc(target.loc)
						parchment = null
						Recall()
					else
						target << "Your carrier peek returns \..."
						if(target.client)
							target.client.screen -= src
							target.client.screen -= target.peek_status
						if(parchment)
							target << "without delivering the message. It drops the message."
							parchment.set_loc(target.loc)
							parchment = null
						else target << "having successfully delivered the message."
						target = null

			New()
				..()
				if(owner_id)
					for(var/mob/player/M)
						if(M.charID == owner_id)
							owner = M