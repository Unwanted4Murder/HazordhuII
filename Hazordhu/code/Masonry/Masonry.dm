obj
	Built
		density = TRUE

		Forge
			SET_TBOUNDS("5,1 to 28,10")
			icon='code/Masonry/Forge.dmi'
			base_health = 200
			takes_fuel = TRUE

			New()
				..()
				new/obj/Built/NewForge(loc)
				del src

		Oven
			SET_TBOUNDS("5,3 to 28,10")
			icon = 'code/Masonry/Oven.dmi'
			base_health = 200
			takes_fuel = TRUE

		Stone_Wall
			icon='code/Masonry/Stone Wall.dmi'
			opacity = TRUE
			base_health = 200

		Fortified_Tower
			icon = 'code/Masonry/Fortified Tower.dmi'
			opacity = TRUE
			SET_BOUNDS(0, 0, 96, 64)
			base_health = 300

		Brick_Wall
			icon='code/Masonry/Brick Wall.dmi'
			opacity = TRUE
			base_health = 300

			var Top
			New()
				..()
				if(Top) overlays = list(/obj/Built/Brick_Wall/Brick_Wall_Top)

			Brick_Wall_Top
				icon_state = "top"
				pixel_y = 32
				layer = MOB_LAYER + 1

			interact_right(mob/player/player)
				if(type != /obj/Built/Brick_Wall) return
				if(player.Locked) return
				if(!player.is_equipped(/obj/Item/Tools/Trowel))
					player.aux_output("You need a trowel equipped to your main hand to fortify the wall.")
					return
				var bricks
				var tars
				var obj/Item/Stone/Brick/b = locate() in player
				var obj/Item/Stone/Tar/t = locate() in player
				if(b) bricks += b.Stacked
				if(t) tars += t.Stacked
				if(bricks >= 3 && tars >= 2)
					player.lose_item(b, 3)
					player.lose_item(t, 2)
				player.emote("starts fortifying the wall")
				player._do_work(50)
				if(player)
					player.emote("finishes fortifying the wall")
					name = "Fortified Brick Wall"
					overlays += /obj/Built/Brick_Wall/Brick_Wall_Top
					Top = TRUE
					Health += 200

		Stone_Window
			parent_type = /obj/Built/Windows
			name = "Brick Window"
			icon = 'code/Masonry/Stone Window.dmi'
			base_health = 300

		Sandstone_Window
			parent_type = /obj/Built/Windows
			icon = 'code/Masonry/Sandstone Window.dmi'
			base_health = 200

		Well
			icon = 'code/Masonry/Well.dmi'
			SET_BOUNDS(8, 6, 16, 10)
			base_health = 200

		Fountain
			icon = 'code/Masonry/Fountain.dmi'
			SET_BOUNDS(0, 0, 32, 24)
			base_health = 200

			interact(mob/m) m._drink(src)

		Stone_Floor
			parent_type = /obj/Built/Floors
			icon = 'code/Masonry/Stone Floor.dmi'
			base_health = 600

		Sandstone_Floor
			parent_type = /obj/Built/Floors
			icon='code/Masonry/Sandstone Floor.dmi'
			base_health = 600

		Altar
			icon = 'Altar.dmi'
			density = TRUE
			SET_TBOUNDS("1,5 to 32,12")
			base_health = 200

		Stone_Bridge
			icon = 'code/Masonry/Stone Bridge.dmi'
			density = TRUE
			base_health = 700

		Sandstone_Bridge
			icon = 'code/Masonry/Sandstone Bridge.dmi'
			density = TRUE
			base_health = 600

		Plaque
			icon = 'Layout.dmi'
			base_health = 100

		Pillar
			icon='code/Masonry/Pillar.dmi'
			SET_BOUNDS(6, 2, 20, 16)
			base_health = 300

		Tombstone
			icon = 'Tombstone.dmi'
			SET_BOUNDS(6, 2, 20, 16)
			base_health = 100

		Statue
			icon='code/Masonry/Statues.dmi'
			SET_BOUNDS(6, 2, 20, 16)
			base_health = 200

		Stone_Sign
			icon = 'code/Masonry/Stone Sign.dmi'
			SET_BOUNDS(6, 2, 20, 16)
			base_health = 100

		Tower
			icon = 'Tower.dmi'
			opacity = 1
			base_health = 300

			New()
				..()
				overlays = list(/obj/Built/Tower/Tower_Top)

			Tower_Top
				icon_state = "top"
				pixel_y = 32
				layer = MOB_LAYER + 1


		Sandstone_Wall
			icon = 'code/Masonry/Sandstone Wall.dmi'
			opacity = TRUE
			base_health = 200

			var Top
			New()
				..()
				if(Top)overlays=list(/obj/Built/Sandstone_Wall/Sandstone_Wall_Top)

			Sandstone_Wall_Top
				icon_state="top"
				pixel_y=32
				layer=MOB_LAYER+1

			interact_right(mob/player/player)
				if(type != /obj/Built/Sandstone_Wall) return
				if(player.Locked)return
				if(!player.is_equipped(/obj/Item/Tools/Trowel))
					player.aux_output("You need a trowel equipped to your main hand to fortify the wall.")
					return
				var bricks
				var tars
				var obj/Item/Stone/Sandstone_Brick/b = locate() in player
				var obj/Item/Stone/Tar/t = locate() in player
				if(b) bricks += b.Stacked
				if(t) tars += t.Stacked
				if(bricks >= 3 && tars >= 2)
					player.lose_item(b, 3)
					player.lose_item(t, 2)
				player.emote("starts fortifying the wall")
				player._do_work(50)
				if(player)
					player.emote("finishes fortifying the wall")
					name = "Fortified Sandstone Wall"
					overlays += /obj/Built/Sandstone_Wall/Sandstone_Wall_Top
					Top = TRUE
					Health += 200
obj
	Item
		Stone
			Brick
				value = 2
				icon = 'code/Masonry/Brick.dmi'
			Tar
				value = 3
				icon = 'code/Masonry/Tar.dmi'
			Sandstone_Brick
				value = 3
				icon = 'code/Masonry/Brick.dmi'
				icon_state = "sandstone"
		Hazium
			Crystal
				value = 19
				icon = 'code/Masonry/Hazium.dmi'
				icon_state = "Crystal"
				Stackable = 0
				var id

		Plate
			icon = 'code/Masonry/Plate.dmi'
			value = 2

		Bowl
			icon = 'code/Masonry/Bowl.dmi'
			value = 2

			Tannin
				value = 6
				icon_state = "Tannin"
			Flour
				value = 6
				icon_state = "Flour"

			Water
				value = 6
				icon_state = "Water"

			Shurger
				value = 6
				icon_state = "Sugar"