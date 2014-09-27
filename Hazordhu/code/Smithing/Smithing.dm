obj
	Item
		Metal
			Nails
				value = 4
				icon = 'code/Smithing/Nails.dmi'
			Lock
				icon = 'code/Smithing/Lock.dmi'
				icon_state = "Lock"
				Stackable = 0
			Key
				icon = 'code/Smithing/Key.dmi'
				Stackable = 0
			Coins
				name = "Hazium Coins"
				icon = 'code/Smithing/Coin.dmi'
				value = 4
			Metal_Coins
				name = "Metal Coins"
				icon = 'code/Smithing/Metal Coin.dmi'
				value = 1
			Pole
				icon = 'code/Smithing/Pole.dmi'
				value = 2

			Animal_Shoes

			Pot
				icon = 'code/Smithing/Pot.dmi'

	Built
		Anvil
			icon = 'code/Smithing/Anvil.dmi'
			density = TRUE
			SET_TBOUNDS("2,2 to 31,9")
			base_health = 500

		Cauldron
			SET_TBOUNDS("6,2 to 27,8")
			icon = 'code/Smithing/Cauldron.dmi'
			density = TRUE
			base_health = 500
			var filled
			var elements[0]
			proc
				be_filled(mob/humanoid/filler)
					if(filler.Locked) return
					var obj/Item/Bucket/Water/water = locate() in filler
					if(!water) return 0

					filler.emote("begins filling the cauldron")
					filler._do_work(30)
					filler.emote("finishes filling the cauldron")
					filled = 5
					icon_state = "fill"
					new /obj/Item/Bucket (filler)
					del water

					return 1

				be_emptied(mob/humanoid/m)
					if(m.Locked) return

					m.emote("begins emptying the cauldron")
					m._do_work(30)
					m.emote("finishes emptying the cauldron")

					filled = 0
					icon_state = ""
					elements = new

					return 1


		Barred_Wall
			icon = 'code/Smithing/Barred Wall.dmi'
			density = TRUE
			base_health = 400