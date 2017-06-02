obj
	Item
		Food
			value = 3

			var Hunger
			use(mob/player/m)
				if(istype(src, /obj/Item/Food/Cooking/Cake) || istype(src, /obj/Item/Food/Cooking/Pie))
					m.aux_output("You need to slice this first.")
					return

				if(istype(src, /obj/Item/Food/Meat))
					var obj/Item/Food/Meat/F = src
					if(istype(F, /obj/Item/Food/Meat/Zombie_Meat))
						m.aux_output("You eat the [src], and you suddenly start feeling very ill.")
						m.lose_health(rand(5, 10), "eating zombie meat")
						m.zombie_infection += rand(3, 5)
						m.lose_item(src)
						m.ZombieInfected()

					var can_eat_raw
					if(m.Race == "Orc")
						can_eat_raw = TRUE

					if(!can_eat_raw && F.cooked <= 5)
						m.aux_output("You eat the [src], but it's still pretty raw and your stomach rejects it.")
						m.lose_stamina(rand(3, 5))
						m.lose_item(src)
					else m.lose_hunger(Hunger - F.cooked)
				else m.lose_hunger(Hunger)

				m.aux_output("You eat the [src].")
				m.lose_item(src)

			Meat
				value = 5
				icon='code/Food/Meat.dmi'
				Flammable = TRUE

				Fish
					icon = 'code/Food/Fish.dmi'
					icon_state = "1"
					Hunger = 15
					New()
						..()
						icon_state="[rand(1, 5)]"

				Zombie_Meat
					value = 1
					name = "Undead Meat"
					icon_state = "Zombie Meat"
					Hunger = -20
					New()
						..()
						del src

				Human_Meat
					name = "Human Meat"
					icon_state = "Human Meat"
					Hunger = 20
				Orc_Meat
					name = "Orc Meat"
					icon_state = "Orc Meat"
					Hunger = 20
				Elf_Meat
					name = "Elf Meat"
					icon_state = "Elf Meat"
					Hunger = 10
				Lar
					value = 8
					name = "Large Meat"
					icon_state = "Bux Meat"
					Hunger = 40
				Med
					name = "Medium Meat"
					icon_state = "Human Meat"
					Hunger = 20
				Sma
					value = 3
					name = "Small Meat"
					icon_state = "Sty Meat"
					Hunger = 25

				Murshum
					icon = 'code/Farming/Farming.dmi'
					icon_state = "Murshum"
					Hunger = 20
					Flammable = TRUE
					New()
						..()
						if(prob(50))
							icon_state = "Murshum2"
			Berry
				icon = 'code/Food/Berry.dmi'
				Hunger = 2
			Egg
				icon = 'code/Food/Egg.dmi'
				Hunger = 7
				var baby	//	type of baby animal

				MouseDrop(obj/Built/Nest/nest)
					if(loc == usr)
						if(istype(nest) && get_dist(usr, nest) <= 1)
							if(nest.egg)
								usr.aux_output("There is already an egg in that nest.")
								return
							nest.egg = (baby || TRUE)
							nest.icon_state = icon_state
							usr.lose_item(src)
					..()


				Bux
					icon_state = "Bux"
					name = "Bux Egg"
				Mur
					icon_state = "Mur"
					name = "Mur Egg"
				Hoge
					icon_state = "Hoge"
					name = "Hoge Egg"
				Peek
					icon_state = "Peek"
					name = "Peek Egg"
				Rar
					icon_state = "Rar"
					name = "Rar Egg"
				Ruff
					icon_state = "Rar"
					name = "Ruff Egg"
					baby = /mob/Animal/Ruff
				Ret
					icon_state = "Ret"
					name = "Ret Egg"
				Sty
					icon_state = "Sty"
					name = "Sty Egg"
				Stoof
					icon_state = "Stoof"
					name = "Stoof Egg"
				Olihant
					icon_state = "Olihant"
					name = "Olihant Egg"
				Flargl
					icon_state = "Flargl"
					name = "Flargl Egg"
				Grawl
					icon_state = "Grawl"
					name = "Grawl Egg"
				GrawlNorth
					icon_state = "Grawl"
					name = "Northern Grawl Egg"
					baby = /mob/Animal/Grawl/North
				Shomp
					icon_state = "Shomp"
					name = "Shomp Egg"
				Agriner
					icon_state = "Agriner"
					name = "Agriner Egg"
				Kaw
					icon_state = "Peek"
					name = "Kaw Egg"
					baby = /mob/Animal/Kaw
				Scree
					icon_state = "Peek"
					name = "Scree Egg"
					baby = /mob/Animal/Scree
		Skin
			value = 3
			icon = 'code/Food/Meat.dmi'
			Human_Skin
				icon_state = "Human Skin"
			Orc_Skin
				icon_state = "Orc Skin"
			Elf_Skin
				icon_state = "Elf Skin"
			Troll_Skin
				icon_state = "Troll Skin"
			Flargl_Skin
				icon_state = "Flargl Skin"
				value = 60
		Fur
			icon = 'code/Food/Meat.dmi'
			icon_state = "Fur"
			Flammable = TRUE
			value = 4
		Bone
			icon = 'code/Hunting/bonez.dmi'
			Flammable = TRUE
			value = 4
		Grawl_Fur
			icon='code/Food/Meat.dmi'
			icon_state = "Grawl Fur"
			Flammable = TRUE
			value = 4
			name = "Grawl Fur"
		North_Grawl_Fur
			icon = 'code/Food/Meat.dmi'
			icon_state = "NGrawl Fur"
			Flammable = TRUE
			value = 4
			name = "North Grawl Fur"

		Feather
			value = 2
			icon = 'code/Food/Feather.dmi'
			Flammable = TRUE
			use(mob/player/m)
				if(m.has_knife())
					m.used_tool()
					m.emote("makes a quill from a feather")
					m.get_item(new /obj/Item/Tools/Quill)
					m.lose_item(src)

		Parchment
			value = 7
			icon = 'code/Food/Meat.dmi'
			icon_state = "Parchment"
			Flammable = TRUE

		Book
			value = 7
			icon = 'code/Hunting/book.dmi'
			Flammable = TRUE

		Leather
			value = 7
			icon = 'code/Food/Meat.dmi'
			icon_state = "Leather"
			Flammable = 1
			Orc
				name = "Orc Leather"
				icon_state = "Orc Leather"
			Human
				name = "Human Leather"
				icon_state = "Human Leather"
			Elf
				name = "Elf Leather"
				icon_state = "Elf Leather"
			Flargl_Leather
				value = 68
				name = "Flargl Leather"
				icon_state = "Flargl Leather"