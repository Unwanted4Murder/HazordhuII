mob/NPC
	saveable = TRUE

	var
		mom
		dad
		save_mom
		save_dad
		mom_name
		dad_name

	New(x, namer,mommy,daddy,gend,skin,hair)
		..()
		name = namer || name

		mom = mommy || mom
		dad = daddy || dad
		mom_name = mom_name || "Mother"
		dad_name = dad_name || "Father"

		gender = gend || gender
		if(gender == NEUTER)
			gender = pick(MALE, FEMALE)

		Heritage = skin || Heritage
		HairColor = hair || HairColor

		if(!Heritage) switch(Race)
			if("Human") Heritage = pick("Southshores", "Plainsman", "Northern", "Chiprock")
			if("Orc") Heritage = pick("Windhowl", "Stonehammer", "Warcry")

		clothe()
		HeritageIcon()
		reset_flat_icon()

	MouseDrop(atom/movable/o)
		if(src in view(1))
			if(istype(o,/obj/Built/Boat) && (o in view(1,usr)))
				var/obj/Built/Boat/B = o
				if(boat)
					B.take_off(src)

				else if(B.passengers.len == 2)
					usr << "There is something in that boats passenger spot!"
					return

				else
					B.put_on(src)
					return
		..()

	proc/clothe()
		if(!equipment["main"])
			var type = pick(
				/obj/Item/Tools/Knife,
				/obj/Item/Tools/Hatchet,
				/obj/Item/Tools/Tongs)
			equip(new type (src))

		if(!equipment["legs"])
			var type = pick(
				/obj/Item/Clothing/Pants/Loincloth)
			equip(new type (src))

		if(!equipment["body"])
			if(gender == FEMALE)
				var type = pick(
					/obj/Item/Clothing/Shirt/Loincloth_Top)
				equip(new type (src))

		if(!equipment["back"])
			var type = pick(
				/obj/Item/Clothing/Back/Fur_Cape)
			equip(new type (src))

	Human
		icon = 'code/Mobs/Human/m_tan.dmi'
		icon_state = "Tan"
		Race = "Human"
		name = "Human"
		Strength = 3
		Health = 125

		New()
			Speaking = "Common"
			..()

		Soldier
			name = "Human Soldier"
			clothe()
				if(!equipment["main"])
					var type = pick(normal_weapons)
					equip(new type (src))

				if(!equipment["off"])
					var type = pick(normal_shields)
					equip(new type (src))

				var suit[] = pick(plate_suit, chain_suit)
				for(var/type in suit)
					equip(new type (src))

		Archer
			name = "Human Archer"
			ranged_attack = 5
			clothe()
				var weapon = pick(ranged_weapons)
				equip(new weapon (src))

				for(var/type in pick(chain_suit, leather_suit))
					equip(new type (src))

	Orc
		icon='code/Mobs/Orc/m_warcry.dmi'
		name = "Orc"
		Race="Orc"
		MeatType=/obj/Item/Food/Meat/Orc_Meat
		SkinType=/obj/Item/Skin/Orc_Skin
		Strength = 5
		Health = 75
		New()
			Speaking = "Orc"
			..()

		Warrior
			name = "Orc Warrior"
			clothe()
				var weapon = pick(normal_weapons)
				equip(new weapon (src))

				var shield = pick(normal_shields)
				equip(new shield (src))

				for(var/type in chain_suit)
					equip(new type (src))

		Archer
			name = "Orc Archer"
			ranged_attack = 5
			clothe()
				var weapon = pick(ranged_weapons)
				equip(new weapon (src))

				for(var/type in leather_suit)
					equip(new type (src))

	Bandit
		icon = 'code/Mobs/Human/m_tan.dmi'
		icon_state = "Tan"
		Race = "Bandit"
		name = "Bandit"
		Strength = 10
		Health = 150

		New()
			Strength = rand(50, 90)
			clothe()
			if(!Heritage)
				Heritage = pick("Southshores","Plainsman","Northern","Chiprock")
				HeritageIcon()
			..()

		Warrior
			name = "Bandit"
			clothe()
				var weapon = pick(normal_weapons)
				equip(new weapon (src))

				for(var/type in pick(chain_suit, leather_suit))
					equip(new type (src))