obj
	Item
		Clothing
			var
				removed
				clothtype
				Defense

			value = 30
			Stackable = FALSE
			Flammable = TRUE

			Pants
				clothtype="legs"
				Trousers
					can_color = 1
					value = 38
					icon = 'code/Clothes/Trousers.dmi'
					heat_added = 2
					//Defense = 1
				Dress
					can_color = 1
					value = 36
					icon = 'code/Clothes/Dress.dmi'
					heat_added = 1
					//Defense = 1

			Shirt
				clothtype="body"
				Shirt
					can_color = 1
					value = 36
					icon = 'code/Clothes/Shirt.dmi'
					heat_added = 10
					//Defense = 1
				Short_Sleeve_Shirt
					can_color = 1
					value = 34
					icon = 'code/Clothes/Shirt_S-Sleeve.dmi'
					heat_added = 2
					//Defense = 1
				Robe_Shirt
					can_color = 1
					icon = 'code/Clothes/shiekrobe.dmi'
					heat_added = 10
					//Defense = 1
				Gown
					can_color = 1
					icon = 'code/Clothes/Princess.dmi'
					heat_added = 9
					//Defense = 1

			Feet
				clothtype="feet"
				Shoes
					can_color = 1
					icon = 'code/Clothes/Shoes.dmi'
					heat_added = 2
					//Defense = 1
				Boots
					value = 32
					can_color = 1
					icon = 'code/Clothes/Boots.dmi'
					heat_added = 5
					//Defense = 1

			Hands
				clothtype="hands"
				Gloves
					can_color = 1
					value = 28
					icon='code/Clothes/Gloves.dmi'
					heat_added = 2
					//Defense=1

			Belt
				clothtype="belt"
				Belt
					can_color = 1
					value = 26
					heat_added = 0
					icon = 'code/Clothes/Belt.dmi'

			Back
				clothtype="back"
				Cape
					can_color = 1
					icon = 'code/Clothes/Cape.dmi'
					heat_added = 3
					//Defense = 1
				Cloak
					can_color = 1
					heat_added = 5
					icon = 'code/Clothes/Cloak.dmi'
				Desert_Cloak
					can_color = 1
					heat_added = 0
					icon = 'code/Clothes/desert_cloak.dmi'
					//Defense = 1
				Tabard
					can_color = 1
					heat_added = 2
					icon='code/Clothes/Tabard.dmi'
				Apron
					can_color = 1
					heat_added = 2
					icon='code/Clothes/Apron.dmi'
				Half_Apron
					can_color = 1
					heat_added = 2
					icon='code/Clothes/Apron_bottom_half.dmi'

			Hood
				clothtype="head"
				Hood
					can_color = 1
					heat_added = 5
					icon = 'code/Clothes/Hood.dmi'
					//Defense = 1
				Hat1
					can_color = 1
					heat_added = 0
					//Defense = 1
					New() del src

				Sulteen
					can_color = 1
					heat_added = 3
					icon = 'code/Clothes/Sultan_hat.dmi'
				Turban
					can_color = 1
					heat_added = 3
					icon = 'code/Clothes/turban.dmi'
					//Defense = 1
				Hat
					can_color = 1
					heat_added = 0
					icon = 'code/Clothes/Fedorah.dmi'

			Helmet
				clothtype="helmet"
				Chef
					name = "Chef's Hat"
					can_color = 0
					heat_added = 3
					icon = 'code/Clothes/Chef_Hat.dmi'
				Skull
					heat_added = 0
					icon = 'code/Clothes/Skull.dmi'
					//Defense = 1
				Bandana
					can_color = 1
					heat_added = 1
					icon='code/Clothes/Bandana.dmi'
					covers_hair = FALSE

			Accessory
				clothtype="misc"
				patch_left
					can_color = 0
					heat_added = 1
					icon='code/Clothes/eyepatch_L.dmi'
				patch_right
					can_color = 0
					heat_added = 1
					icon='code/Clothes/eyepatch_R.dmi'

			Bag
				can_color = 1
				clothtype="bag"