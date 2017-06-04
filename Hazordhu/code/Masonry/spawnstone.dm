


obj
	Item/Armour/Accessory/Amulet
		var id
		proc/connect(obj/Built/spawnstones/main/obelisk)
			id = obelisk.id
			name = "Amulet \[[id]]"

	Item/Hazium/Crystal
		use(mob/m) if(loc == m)
			var obj/Built/spawnstones/main/stone = locate() in m.front()
			if(!stone) return

			id = stone.id
			name = "Crystal \[[stone.id]]"

	Built
		spawnstones
			density = 0
			icon = 'code/Masonry/spawnstone.dmi'

			main
				name = "Hazium Obelisk"
				density = 1
				var id

				//	solves the issue of overshooting (Eks and Kaio)
				var tmp/active

				#if MAPSAVE
				save_to(savedatum/s)
					s.save_id = id

				#if NEW_RUNES
				load_from(savedatum/s)
					SetID(s.save_id)

				proc/SetID(ID)
					// check for an older id
					if(id)
						var code[] = params2list(id)
						if(!istype(code) || code.len != RUNE_CODE_LENGTH)
							id = null

					id = runes.LinkCode(src, ID || id || runes.GetNewCode())

				#else
				load_from(savedatum/s)
					id = s.save_id

				#endif
				#endif

				#if NEW_RUNES
				MouseEntered()
					..()
					var mob/player/player = usr
					player.ShowRuneSet(params2list(id))

				MouseExited()
					..()
					var mob/player/player = usr
					player.HideRuneSet()
				#endif

				New()
					..()
					#if NEW_RUNES && MAPSAVE
					SetID()
					#else
					if(!id) id = string(5)
					name = "Hazium Obelisk \[[id]]"
					#endif
					tag = "obelisk [id]"

				interact(mob/humanoid/m)
					var obj/Item/Armour/Accessory/Amulet/amulet = locate() in m.Equipment()
					if(amulet)
						amulet.connect(src)
						m.aux_output("Your amulet links with the obelisk.")

				proc
					activate(var/obj/Built/spawnstones/main/target)
						if(active) return

						if(check() && (target && target.check()))
							active = TRUE

							// visual effect

							flick("activate", src)
							flick("activate", target)

							spawn(SECOND)
								var tosend1[] = tosend()
								var tosend2[] = target.tosend()

								transfer(target, tosend1)
								target.transfer(src, tosend2)

								active = FALSE
							return 1

					tosend() // tags items to be transferred

						var tosend[0]
						var range[] = orange(2, src)

						// Adds objects to the list to be sent
						for(var/o in range)
							if(istype(o, /obj/Item) || ismob(o) || istype(o, /obj/Built/Storage/Cart) || istype(o, /obj/Built/Boat))
								if(istype(o, /obj/Item/Farming/plant)) continue
								tosend += o

						return tosend

					transfer(obj/Built/spawnstones/main/target, tosend[])

						// Calculates relative location to the parent for sending
						for(var/atom/movable/i in tosend)
							var/tox = target.x + (i.x - x)
							var/toy = target.y + (i.y - y)
							i.set_loc(locate(tox, toy, target.z), i.step_x, i.step_y)

					//	Checks the area for the required children stones
					//	and anything that may block the transport
					check()
						//	returns 0 for obstacles
						//	returns null for lacking child stones

						var obj/Built/spawnstones/small
							child1 = locate() in locate(x-2, y+2, z)
							child2 = locate() in locate(x+2, y+2, z)
							child3 = locate() in locate(x-2, y-2, z)
							child4 = locate() in locate(x+2, y-2, z)

						if(child1 && child2 && child3 && child4)
							var children[] = list(child1, child2, child3, child4)

							for(var/obj/o in orange(src, 2))
								if(istype(o, /obj/Built/Storage/Cart))
									continue

								else if(istype(o, /obj/Built/spawnstones/small))
									if(o in children)
										continue
									else
										return 0

								else if(o.density || istype(o,/obj/Built/Doors))
									return 0

							return 1

			small
				icon_state = "small"
				name = "Rune"