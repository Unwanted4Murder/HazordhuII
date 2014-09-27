obj/Item/Clothing
	value = 20
	Hood
		Leather_Hood
			icon='Leather Hood.dmi'
			heat_added = 10
			Type = "Leather"
			value = 23
		Flargl_Leather_Hood
			icon='flargl Hood.dmi'
			heat_added = 10
			value = 92
			Type = "Leather"
		//	Defense = 3
		Grawl_Hood
			heat_added = 10
			icon = 'Grawl Hood.dmi'

		North_Grawl_Hood
			heat_added = 12
			icon = 'NGrawl Hood.dmi'

	Hands
		Leather_Gloves
			value = 16
			icon='Leather Gloves.dmi'
			heat_added = 3
			Type = "Leather"
		Flargl_Leather_Gloves
			value = 88
			icon='flargl Gloves.dmi'
			heat_added = 3
			Type = "Leather"
		//	Defense = 2
		Mittens
			value = 20
			icon='Mittens.dmi'
			heat_added = 5
		//	Defense = 1
		Grawl_Gloves
			value = 20
			icon='Grawl Gloves.dmi'
			heat_added = 5
		North_Grawl_Gloves
			value = 20
			icon='NGrawl Gloves.dmi'
			heat_added = 7

	Pants
		Leather_Pants
			value = 30
			icon='Leather_Pants.dmi'
			heat_added = 10
			Type = "Leather"
		Flargl_Leather_Pants
			value = 95
			icon='flargl Pants.dmi'
			heat_added = 10
			Type = "Leather"
		//	Defense = 5
		Fur_Pants
			value = 24
			icon='Fur Trousers.dmi'
			heat_added = 15
		//	Defense = 1
		Loincloth
			value = 10
			icon='Loin Cloths.dmi'
			heat_added = 2
		Grawl_Loincloth
			value=24
			icon = 'Grawl Loincloth.dmi'
			heat_added = 4
		North_Grawl_Loincloth
			value=24
			icon = 'NGrawl Loincloth.dmi'
			heat_added = 7
		Grawl_Pants
			value=24
			icon = 'Grawl Pants.dmi'
			heat_added = 10
		North_Grawl_Pants
			value=24
			icon = 'NGrawl Pants.dmi'
			heat_added = 12

	Shirt
		Leather_Shirt
			value = 32
			icon='Leather_Shirt.dmi'
			heat_added = 5
			Type = "Leather"
		Flargl_Leather_Shirt
			value = 98
			icon='flargl Shirt.dmi'
			heat_added = 5
			Type = "Leather"
		//	Defense = 5
		Fur_Coat
			value = 26
			icon='Fur Coat.dmi'
			heat_added = 10
		//	Defense = 2
		Loincloth_Top
			value = 10
			icon='Top.dmi'
			heat_added = 2
		Grawl_Shirt
			value = 26
			icon='Grawl Shirt.dmi'
			heat_added = 10
		North_Grawl_Shirt
			value = 26
			icon='NGrawl Shirt.dmi'
			heat_added = 10


	Back
		Fur_Cape
			value = 25
			icon='Fur Cape.dmi'
			heat_added = 10
		//	Defense = 1

		Quiver
			value = 32
			icon='quiver.dmi'
			Type = "Leather"
		Grawl_Cape
			value = 25
			icon='Grawl Cape.dmi'
			heat_added = 10
		North_Grawl_Cape
			value = 25
			icon='NGrawl Cape.dmi'
			heat_added = 10

	Feet
		Leather_Shoes
			value = 20
			icon='Leather_Shoes.dmi'
			heat_added = 2
			Type = "Leather"
		Flargl_Leather_Shoes
			value = 86
			icon='flargl Shoes.dmi'
			heat_added = 2
			Type = "Leather"
		//	Defense = 2
		Fur_Boots
			value = 20
			icon='Fur Boots.dmi'
			heat_added = 5
		Grawl_Boots
			value = 20
			icon='Grawl Shoes.dmi'
			heat_added = 5
		North_Grawl_Boots
			value = 20
			icon='NGrawl Shoes.dmi'
			heat_added = 5

	Helmet
		Leather_Mask
			icon = 'Leatherhelmet.dmi'
			heat_added = 2
			Type = "Leather"
		//	Defense = 1
		Mask
			icon='Leather_Mask.dmi'
			heat_added = 5
			value = 18
		Toque
			icon = 'Toque.dmi'
			heat_added = 5
		//	Defense = 1
			pixel_y=1
		Grawl_Mask
			icon = 'Grawl Mask.dmi'
			heat_added = 3
		North_Grawl_Mask
			icon = 'NGrawl Mask.dmi'
			heat_added = 3


obj/Built/Tanning_Frame
	icon = 'Tanning Frame.dmi'
	Flammable = TRUE

	interact(mob/m) Pin(m)

	var tmp/obj/Item/Leather/Tanning/Tanning
	proc/Pin(mob/m, obj/Item/item)
		if(Tanning) return

		var global/skin2tan[] = list(
			/obj/Item/Fur = /obj/Item/Leather/Tanning,
			/obj/Item/Skin/Human_Skin = /obj/Item/Leather/Tanning/Human,
			/obj/Item/Skin/Orc_Skin = /obj/Item/Leather/Tanning/Orc,
			/obj/Item/Skin/Elf_Skin = /obj/Item/Leather/Tanning/Elf,
			/obj/Item/Skin/Flargl_Skin = /obj/Item/Leather/Tanning/Flargl)

		if(item && !(item.type in skin2tan)) return

		if(!item)
			for(var/path in skin2tan)
				item = locate(path) in m
				if(item) break

		if(item)
			m.aux_output("You stretch [item] on the tanning frame.")
			var tanning = skin2tan[item.type]
			Tanning = new tanning (loc)
			Tanning.layer = layer + 0.1
			m.lose_item(item)

	Del()
		if(Tanning) del Tanning
		..()

obj/Item
	MouseDrop(obj/Built/Tanning_Frame/frame)
		if(!usr.Locked && loc == usr && bounds_dist(usr, frame) <= 16 && istype(frame) && (istype(src, /obj/Item/Skin) || istype(src, /obj/Item/Fur)) && !frame.Tanning)
			frame.Pin(usr, src)
		else ..()

obj/Item/Leather/Tanning
	name = "Fur"
	icon_state = "Tanning"
	SET_BOUNDS(0, 0, 32, 32)

	Orc
		name = "orc skin"
		icon_state = "Orc Tanning"
	Human
		name = "human skin"
		icon_state = "Human Tanning"
	Elf
		name = "elf skin"
		icon_state = "Elf Tanning"
	Flargl
		name = "flargl skin"
		icon_state = "Flargl Tanning"

	var Done
	Get(mob/humanoid/m)
		if(Done)
			var leather
			switch(type)
				if(/obj/Item/Leather/Tanning)			leather = /obj/Item/Leather
				if(/obj/Item/Leather/Tanning/Orc)		leather = /obj/Item/Leather/Orc
				if(/obj/Item/Leather/Tanning/Human)		leather = /obj/Item/Leather/Human
				if(/obj/Item/Leather/Tanning/Elf)		leather = /obj/Item/Leather/Elf
				if(/obj/Item/Leather/Tanning/Flargl)	leather = /obj/Item/Leather/Flargl_Leather
			new leather (m)
			del src

		else if(locate(/obj/Built/Tanning_Frame) in loc)
			if(!m.is_equipped(/obj/Item/Tools/Brush)) return

			var obj/Item/Bowl/Tannin/tannin = locate() in m
			if(tannin)
				usr.aux_output("You brush tannin on [name] to make leather.")
				m.lose_item(tannin)
				new /obj/Item/Bowl (m)
				Done = TRUE
				return

			var obj/Item/Bowl/Water/water = locate() in m
			if(water)
				usr.aux_output("You brush water on [name] to make a soaked hide.")
				m.lose_item(water)
				new /obj/Item/Bowl (m)
				new /obj/Item/Leather/Tanning/Soaked_Hide (loc)
				del src

	Soaked_Hide
		icon_state = "Parch Tanning"
		var Scraped
		Get(mob/player/m)
			if(locate(/obj/Built/Tanning_Frame)in loc)
				if(Done)
					for(var/obj/Built/Tanning_Frame/frame in loc) frame.Tanning = FALSE
					m.lose_item(src)
					new /obj/Item/Parchment (m)

				else if(!Done && Scraped)
					m.aux_output("The skin must dry.")

				else if(m.has_knife())
					m.aux_output("You scrape off the fur from the hide. It must now dry.")
					Scraped = TRUE
					sleep 300
					ohearers(src) << "The parchment has finished drying."
					Done = TRUE