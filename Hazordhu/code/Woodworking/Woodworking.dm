obj/Built
	firepit
		icon = 'code/Cooking/Firepit.dmi'
		base_health = 25
		can_cook = TRUE
		takes_fuel = TRUE
		fuel_time(o)
			if(istype(o, /obj/Item/Coal))
				return
			return ..()

	Garbage
		icon = 'Garbage.dmi'
		base_health = 50
		SET_TBOUNDS("11,2 to 22,8")

	Stocks
		icon = 'Stocks.dmi'
		base_health = 50
		Flammable = TRUE
		layer = MOB_LAYER + 10

		SET_TBOUNDS("7,3 to 26,7")
/*
		MouseDrop(mob/m, src_location, over_location, src_control, over_control, params)
			..()
			if(usr.Locked || icon_state == "used") return
			if(ismob(m) && get_dist(m, src) <= 1 && get_dist(m, usr) <= 1)
				m.set_loc(loc)
				m.Locked = 1
				icon_state = "used"
				while(m.loc == loc) sleep(1)
				if(m) m.Locked = 0
				icon_state = ""
*/

	Headpike
		SET_TBOUNDS("15,3 to 18,5")
		icon = 'headpike.dmi'
		base_health = 50
		Flammable = 1
		layer = MOB_LAYER + 10

	Range
		parent_type = /obj/Built/Counter

		icon_state = "Cook"
		base_health = 200

		SET_TBOUNDS("1,7 to 32,18")
		can_cook = TRUE
		takes_fuel = TRUE
		lit_state = "Cook lit"
		unlit_state = "Cook"
		var container

	Torch
		icon = 'code/Woodworking/Torch.dmi'
		base_health = 20

		SET_BOUNDS(15, 5, 2, 2)

		proc/toggle()
			icon_state == "lit" ? turn_off() : turn_on()
			return 1

		proc/turn_off()
			icon_state = ""
			set_light(0)

		proc/turn_on()
			icon_state = "lit"
			set_light(8)

		interact() return toggle()

		New()
			..()
			if(icon_state == "lit")
				turn_on()
			else turn_off()

	Bed
		SET_TBOUNDS("3,7 to 30,22")
		icon = 'code/woodworking/bedframe.dmi'
		base_health = 50
		density = FALSE
		Flammable = TRUE

		interact_right(mob/m)
			if(bed_is_made())
				return

			var obj/Item/Tailoring
				Mattress/mattress = locate() in m
				Pillow/pillow = locate() in m

			if(mattress)
				mattress.Drop(m)
				mattress.set_loc(loc, step_x, step_y)
				m.aux_output("You put a mattress on the bed.")

			if(pillow)
				pillow.Drop(m)
				pillow.set_loc(loc, step_x, step_y)
				m.aux_output("You put a pillow on the bed.")

	Barricade
		SET_TBOUNDS("10,8 to 24,16")
		icon = 'Barricade.dmi'
		base_health = 50
		Flammable = 1
		density = 1
		Bumped(mob/mortal/m)
			if(istype(m))
				m.take_damage(rand(1, 25), "a barricade")
				m.Bleed()

	Floor
		parent_type = /obj/Built/Floors
		icon = 'code/Woodworking/Floor.dmi'
		base_health = 30
		Flammable = TRUE

	Table
		icon = 'code/Woodworking/Table.dmi'
		base_health = 50
		Flammable = TRUE
		density = TRUE
		pixel_x = -8
		pixel_y = -8
		SET_BOUNDS(0, 4, 32, 24)
		layer = 10.5

	Wall
		icon = 'code/Woodworking/Wall.dmi'
		Flammable = TRUE
		density = TRUE
		opacity = TRUE
		base_health = 300

	skin_wall
		icon='code/Woodworking/skin_wall.dmi'
		density = TRUE
		opacity = TRUE
		base_health = 200

		Fur_Wall
			icon_state = "fur"
			Flammable = TRUE

		Human_Skin_Wall
			icon_state = "human"

		Orc_Skin_Wall
			icon_state = "orc"
			base_health = 250

		Flargl_Skin_Wall
			icon_state = "flargl"
			base_health = 500

		Troll_Skin_Wall
			icon_state = "troll"
			base_health = 400

		Grawl_Fur_Wall
			icon_state = "grawl"
			base_health = 300

		North_Grawl_Fur_Wall
			icon_state = "ngrawl"
			base_health = 300

	Log_Wall
		icon='code/Woodworking/Log Wall.dmi'
		Flammable = TRUE
		density = TRUE
		opacity = TRUE
		base_health = 250

	Log_Window
		parent_type = /obj/Built/Windows
		icon = 'code/Woodworking/Log Window.dmi'
		Flammable = TRUE
		base_health = 200

	Window
		parent_type = /obj/Built/Windows
		icon = 'code/Woodworking/Window.dmi'
		Flammable = TRUE
		base_health = 250

	Stool
		icon = 'code/Woodworking/Furniture.dmi'
		SET_TBOUNDS("12,12 to 21,20")
		Flammable = TRUE
		density = FALSE
		icon_state = "2"
		base_health = 20

	Chair
		icon = 'code/Woodworking/Furniture.dmi'
		SET_TBOUNDS("12,12 to 21,20")
		Flammable = TRUE
		density = FALSE
		icon_state = "3"
		base_health = 30

	Throne
		parent_type = /obj/Built/Chair
		icon = 'code/Woodworking/Throne.dmi'
		Flammable = FALSE
		density = FALSE
		base_health = 100

	Sign
		icon='code/Woodworking/Sign.dmi'
		Flammable = TRUE
		density = TRUE
		base_health = 30
		SET_TBOUNDS("7,3 to 25,7")

	Fence
		icon='code/Woodworking/Fence.dmi'
		density = TRUE
		Flammable = TRUE
		base_health = 100

	Pallisade_Wall
		icon = 'code/Woodworking/Pallisade Wall.dmi'
		layer = MOB_LAYER + 1
		density = TRUE
		Flammable = TRUE
		opacity = TRUE
		base_health = 300
		New()
			..()
			join_check()

		Del()
			var walls[0]
			for(var/obj/Built/Pallisade_Wall/p in oview(1, src))
				walls += p
			set_loc()
			for(var/obj/Built/Pallisade_Wall/p in walls)
				p.join_check()
			..()

		proc/join_check()
			for(var/obj/Built/Pallisade_Wall/p in oview(1, src))
				if(get_dir(src,p) in list(1,2,4,8))
					p.icon_state = "[text2num(p.icon_state) | get_dir(p,src)]"
					icon_state = "[text2num(icon_state) | get_dir(src,p)]"

	Orc_Pallisade_Wall
		layer = MOB_LAYER+1
		icon = 'code/Woodworking/Orc Pallisade.dmi'
		density = TRUE
		Flammable = FALSE
		opacity = TRUE
		base_health = 400
		New()
			..()
			join_check()

		Del()
			var walls[0]
			for(var/obj/Built/Orc_Pallisade_Wall/p in oview(1, src))
				walls += p
			set_loc()
			for(var/obj/Built/Orc_Pallisade_Wall/p in walls)
				p.join_check()
			..()

		proc/join_check()
			for(var/obj/Built/Orc_Pallisade_Wall/p in oview(1, src))
				if(get_dir(src,p) in list(1,2,4,8))
					p.icon_state = "[text2num(p.icon_state) | get_dir(p,src)]"
					icon_state = "[text2num(icon_state) | get_dir(src,p)]"

	Bridge
		icon = 'code/Woodworking/Wall.dmi'
		icon_state = "Bridge"
		Flammable = TRUE
		base_health = 300

	Combat_Dummy
		icon = 'Combat Dummy.dmi'
		Flammable = TRUE
		density = TRUE
		base_health = 1000

	Counter
		icon = 'code/Woodworking/Counter.dmi'
		Flammable = TRUE
		density = TRUE
		base_health = 75

	Sink
		parent_type = /obj/Built/Counter
		icon_state = "Sink"
		density = TRUE
		base_health = 200

		New() del src

		interact() toggle()

		interact_right(mob/player/m)
			is_on() ? Drink(m) : m.aux_output("The sink isn't flowing!")

		proc/toggle()	is_on() ? turn_off() : turn_on()

		proc/turn_on()	icon_state = "Sink on"
		proc/turn_off()	icon_state = "Sink"
		proc/is_on()	return icon_state == "Sink on"

		proc/Drink(mob/player/m)
			if(m.Locked) return
			if(!m.Thirst)
				m.aux_output("You don't need to drink.")
				return
			m.emote("drinks from the sink")
			m.Locked = TRUE
			while(m.Thirst > 0)
				m.status_overlay("thirst", 1)
				sleep 1
				m.lose_thirst(1)
			m.Locked = 0
			return TRUE

	Target
		icon = 'code/Woodworking/Target.dmi'
		Flammable = TRUE
		density = TRUE
		SET_TBOUNDS("9,2 to 24,8")
		base_health = 50

	Water_Wheel
		icon = 'Water Wheel.dmi'
		Flammable = TRUE
		density = TRUE
		base_health = 50

	Grinding_Platform
		icon = 'Grinding Stone.dmi'
		density = TRUE
		Flammable = TRUE
		SET_TBOUNDS("9,1 to 25,8")
		base_health = 50
		interact(mob/m) return add_stone(m)
		proc/add_stone(mob/m)
			var obj/Item/Ores/Stone/s = locate() in m
			if(!s)
				m.aux_output("You need to add a stone to the platform.")
				return
			del s
			m.emote("adds a stone to the platform")
			new /obj/Built/Grinding_Stone (loc)
			set_loc()
			return TRUE

	Grinding_Stone
		icon = 'Grinding Stone.dmi'
		icon_state = "stone"
		density = TRUE
		SET_TBOUNDS("9,1 to 25,8")
		base_health = 75

obj/Item
	Canteen
		icon = 'code/Hunting/Canteen.dmi'
		value = 30
		Water
			icon_state = "Full"
			Flammable = FALSE

	Bucket
		icon = 'code/Woodworking/Bucket.dmi'
		Flammable = TRUE
		value = 4

		Water
			icon_state = "Water"
			Flammable = FALSE

		Mylk
			icon_state = "Mylk"
			Flammable = FALSE

	Tinder_Box
		icon = 'Tinder Box.dmi'
		max_health = 10
		value = 18

		use(mob/player/m)
		/*
			if(!m.isSubscriber)
				m.aux_output("You need to subscribe to use a tinderbox.")
				return

			if(!WarTime)
				m.aux_output("Tinderboxes can only be used in times of war.")
				return

			if(!m.pvp)
				m.aux_output("Your combat has been disabled.")
				return

			if(loc == m && !m.Locked)
				take_damage()

				m.aux_output("You attempt to create an ember.")
				m._do_work(50)
				if(prob(50))
					AdminsOnline << "<font color=red>[m.key] has used a tinderbox. [ADMIN_TELE(m)]</font>"
					fire_log += "([time2text(world.realtime,"MM DD hh:mm")])[m.key][ADMIN_TELE(m)]<br>"

					m.aux_output("You successfully create an ember.")
					new /obj/Fire (m.loc)

				else m.aux_output("You fail to create an ember.")
		*/