var mod_values[] = list(
		"Doitean"		=	ARROW_FIRE,
		"Pleascadh"		=	ARROW_EXPLODE,
		"Doigh"			=	ARROW_INFERNO,
		"Piriteicniula"	=	ARROW_INFERNO | ARROW_EXPLODE
)

var magics[] = list(
		"Nektorifisch",	//	Summon Zombie
		"Xiorniarora",	//	Next season
		"Akatuarats"	//	Spawn Tree
)

obj/Built/tutorial_circle
	name = "Rune Circle"
	icon = 'code/Codes/Interactive Objects/transporter.dmi'
	icon_state = "off"
	density = 0
	attackable = 0

	interact(mob/m)
		var flag_path = text2path("/obj/Flag/[m.Race]")
		var obj/Flag/dest = locate(flag_path)

		if(!dest || !dest.loc)
			m.aux_output("Something is wrong. Contact an admin. ")
			return

		m.Locked = 1

		icon_state = "activate"
		sleep(10)
		icon_state = "on"
		sleep(10)
		icon_state = "off"

		if(!dest || !dest.loc)
			m.aux_output("Something is wrong. Contact an admin. ")
			return

		m.set_loc(dest.loc)
		m.Locked = 0

obj
	Built
		Transporter
			name = "Rune Circle"
			icon = 'code/Codes/Interactive Objects/transporter.dmi'
			icon_state = "buried"
			density = 0
			attackable = 0
			var id
			var buried = TRUE

			#if NEW_RUNES
			save_to(savedatum/s)
				s.save_id = id

			load_from(savedatum/s)
				SetID(s.save_id)

			proc/SetID(ID)
				if(id == "[x]/[y]/[z]") id = null
				id = runes.LinkCode(src, ID || id || runes.GetNewCode())

			#endif

			New()
				..()
				#if NEW_RUNES
				SetID()
				#else
				id = "[x]/[y]/[z]"
				#endif
				tag = "transporter_[id]"

				if(icon_state == "buried")
					buried = TRUE
				else
					buried = FALSE
					icon_state = "off"

			DblClick()
				var mob/player/player = usr
				if(get_dist(src, player) > 1) return
				if(buried)
					if(player.is_equipped(/obj/Item/Tools/Shovel))
						player.used_tool()
						player.aux_output("You uncover a rune circle.")
						icon_state = "off"
						buried = FALSE
					else player.aux_output("You need a shovel equipped in your main hand to uncover that.")

				#if !NEW_RUNES
				else player.aux_output("You read the rune circle and discover the rune code to access it: [id]")
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

			proc
				Activate(destination, mob/humanoid/m)
					if(buried)
						return

					if(icon_state != "off")
						return

					var obj/Built/Transporter/dest = locate("transporter_[destination]")

					if(!dest || dest.buried)
			//			m << "A rune circle with that destination could not be found."
						return

					if(dest == src)
			//			m << "That wouldn't be very productive at all..."
						return

					m.Locked = 1
					glow()
					m.Locked = 0

					m.set_loc(dest.loc)
					if(m.mount)
						m.mount.set_loc(dest.loc)
					return 1

				glow()
					icon_state = "activate"
					sleep(10)
					icon_state = "on"
					sleep(10)
					icon_state = "off"



	Item
		Rune_Stone
			Stackable = 0
			icon = 'code/Codes/Interactive Objects/transporter.dmi'
			icon_state = "rune"
			value = 43
			var destination
			var uses = 5

			#if !NEW_RUNES
			New()
				..()
				if(destination)
					name = "Rune Stone ([destination])"
			#endif

			#if NEW_RUNES
			Del()
				if(istype(loc, /mob/player))
					var mob/player/player = loc
					if(player.rune_stone == src)
						player.HideRuneStone()
				..()

			dropped_by(mob/player/Player)
				if(src == Player.rune_stone)
					Player.HideRuneStone()
				..()
			#endif

			#if NEW_RUNES
			use(mob/player/player)
				if(loc == player)
					set_destination(player)
			#else
			use_alt(mob/player/player)
				if(loc == player)
					set_destination(player)
			#endif

			proc/drain(mob/player/m)
				if(!m.SubBens)
					uses --
					m << "The rune stone has [uses] uses left... (Subscribe to get unlimited usage!)"
					if(uses <= 0)
						crumble()

			#if NEW_RUNES
			proc/Activate(mob/player/m, RuneCode)
				destination = RuneCode
			#else
			use(mob/m) if(loc == m)
			#endif
				if(!destination) return

				if(destination in magics)
					cast(m)

				var obj/Built/Transporter/circle = locate() in m.loc
				if(circle)
					if(destination in mod_values)
						mod(m)

					else
						if(circle.Activate(destination, m))
							drain(m)
						else m << "The rune circle does not react to your rune stone. "

				var obj/Built/spawnstones/main/obelisk = locate() in orange(2, m)
				if(obelisk)
					var obj/Built/spawnstones/main/dest = locate("obelisk [destination]")
					/*
					for(dest)
						if(dest.id == destination && dest != obelisk)
							break
					*/
					if(dest && dest != obelisk)
						if(obelisk.activate(dest))
							drain(m)
							return
					else m.aux_output("The obelisk does not react to your rune stone. ")

			proc/set_destination(mob/player/m)
			#if NEW_RUNES
				m.ToggleRuneStone(src)

			#else
				var new_dest = input(m, "Please input a new rune destination.", "Rune Stone") as null|text
				if(new_dest == null) return
				destination = new_dest
				if(new_dest)
					name = "Rune Stone ([destination])"
			#endif

			proc/crumble(mob/m)
				m.aux_output("The rune stone crumbles to dust...")
				m.lose_item(src)

			proc/mod(mob/m)
				var obj/Item/Weapons/archery/Bow/B = locate() in m
				if(B)
					B.Mod = (B.Mod || 0) | mod_values[destination]
					m.aux_output("Your bow has been modified!")
					crumble()

			proc/cast(mob/player/m)
				if(!m.SubBens)
					m.aux_output("You lack the intellect needed to cast that spell! (Subscribe!)")
					return

				switch(destination)
					if("Nektorifisch") //dichuimhne
						var mob/Corpse/c = locate() in orange(3, m)
						if(c)
							var mob/NPC/Zombie/z = new (c.loc)
						#if PIXEL_MOVEMENT
							z.step_x = c.step_x
							z.step_y = c.step_y
						#endif
							del c

							z.leader = m.key
							m.aux_output("You summoned a zombie!")

						else
							m.aux_output("You need a corpse to raise!")
							return

					if("Xiorniarora") //raitheachan
						calendar.next_season()
						m.aux_output("You have changed the season!")

					if("Akatuarats") //foraoiseolaiocht
						new /obj/Woodcutting/Tree (m.loc)
						m.aux_output("You have created a tree!")

					else return

				crumble(m)
/*
			Click(location,control,params)
				if(loc != usr) return
				var/list/pr = params2list(params)
				if("right" in pr)
					if("shift" in pr)
						var/newdest = input("Please input a new rune destination")as null|text
						if(!newdest) return
						destination = newdest
						name = "Rune Stone ([destination])"
					else
						if(!destination) return
						var/obj/Built/Transporter/trans = locate() in usr.loc
						if(!trans)
							var/obj/Built/spawnstones/main/source = locate() in orange(2)
							if(source)
								for(var/obj/Built/spawnstones/main/m)
									if(m == source) continue
									else if(m.id == destination)
										if(!usr.SubBens)
											usr << "The rune stone crumbles to dust... (Subscribe to get unlimited usage!)"
											loc = null
										source.activate(m)
										break
							else
								usr << "There is no rune circle or Hazium Obelisk in range."
						else
							if(destination in mod_values)
								var/obj/Item/Weapons/archery/Bow/B = locate() in usr
								if(B)
									B.Mod &= mod_values[destination]
									usr << "Your bow has been modified!"
									usr << "The rune stone crumbles into nothing..."
									del(src)
									return

							if(destination in magics)
								if(usr.SubBens)
									if(destination == "Nektorifisch")
										var/foundCorpse
										for(var/mob/Corpse/c in range(3))
											var/mob/NPC/Zombie/Z = new(usr.loc)
											Z.leader = usr.key
											foundCorpse = 1
											del(c)
										if(foundCorpse)
											usr << "You summoned a zombie!"
											usr << "The rune stone crumbles into nothing..."
											del(src)
										return
									if(destination == "Xiorniarora")
									//	todo: change the season
										usr << "You have changed the season!"
										usr << "The rune stone crumbles into nothing..."
										del(src)
										return
									if(destination == "Akatuarats")
										new /obj/Woodcutting/Tree (usr.loc)
										usr << "You have created a tree!"
										usr << "The rune stone crumbles into nothing..."
										del(src)
										return
								else
									usr << "You lack the intellect needed to cast that spell! (Subscribe!)"

							if(usr.SubBens)
								trans.Activate(destination,usr)
								suffix = "(Uses: Unlimited)"
							else
								if(uses)
									trans.Activate(destination,usr)
									uses --
									suffix = "(Uses: [uses])"
									usr << "The rune stone has [uses] uses left... (Subscribe to get unlimited usage!)"
									if(uses <= 0)
										usr << "The rune stone crumbles to dust... (Subscribe to get unlimited usage!)"
										del(src)
*/