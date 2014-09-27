builder/smithing
	main_tool = /obj/Item/Tools/Hammer
	skill = SMITHING
	cursor = "hammer"
	allowed_in_tutorial = TRUE

	var needs_anvil = TRUE

	condition(mob/m)
		if(!m.loc) return
		if(needs_anvil && !(locate(/obj/Built/Anvil) in obounds(m, 24)))
			return FALSE
		return TRUE

	anvil
		name = "Anvil"
		icon = 'code/Smithing/Anvil.dmi'
		needs_anvil = FALSE

		desc = "A heavy metal anvil required for smithing<br />\
				10 Bars"
		tooltipRows = 2

		req = list(	BAR		=	10)
		built = /obj/Built/Anvil
		allowed_in_tutorial = FALSE

		density = TRUE

	barred_wall
		name = "Barred Wall"
		icon = 'code/Smithing/Barred Wall.dmi'
		group_only = 1
		needs_anvil = FALSE

		desc = "Something to keep criminals behind, or just a better fence<br />\
				4 Poles"
		tooltipRows = 3

		req = list(	POLE	=	4)
		built = /obj/Built/Barred_Wall
		allowed_in_tutorial = FALSE

		density = TRUE

	barred_gate
		name = "Barred Gate"
		icon = 'code/Smithing/Barred Gate.dmi'
		group_only = 1
		needs_anvil = FALSE

		desc = "Like a barred wall, except you can open it<br />\
				5 Poles"
		tooltipRows = 2

		req = list(	POLE	=	5)
		built = /obj/Built/Doors/Barred_Gate
		allowed_in_tutorial = FALSE

		density = TRUE

	cauldron
		name = "Cauldron"
		icon = 'code/Smithing/Cauldron.dmi'
		needs_anvil = FALSE

		desc = "A big bowl used to mix alchemy ingredients<br />\
				6 Bars"
		tooltipRows = 2

		req = list(	BAR		=	6)
		built = /obj/Built/Cauldron
		allowed_in_tutorial = FALSE

		density = TRUE

	nail
		name = "Nail"
		icon = 'code/Smithing/Nails.dmi'

		desc = "Those pointy things used in woodworking<br />\
				1 Bar"
		tooltipRows = 2

		req = list(	BAR		=	1)
		built = /obj/Item/Metal/Nails
		build_amount = 3

	bolt
		name = "Bolts"
		icon = 'code/Weapons/Bolt.dmi'
		group_only = 1
		allowed_races = HUMAN

		desc = "Ammunition for crossbows<br />\
				1 Bar"
		tooltipRows = 2

		req = list(	BAR		=	1)
		built = /obj/Item/Projectile/Bolt
		build_amount = 5


	key
		name = "Key"
		icon = 'code/Smithing/Key.dmi'
		icon_state = "Key"
		desc = "Creates a new key. If you have a key mould, that can be copied instead. <br />\
				1 Bar<br />"
		tooltipRows = 3
		req = list(	BAR		=	1)
		built = /obj/Item/Metal/Key
		condition(mob/m) if(..())
			var moulds[] = list("New Key")
			for(var/obj/Item/Mould/mould in m) moulds += mould
			var obj/Item/Mould/mould = input(m, "Which key mould do you want to use?", "Key") as null|anything in moulds
			if(istype(mould)) return mould.id
			else if(mould == "New Key") return string()

	lock
		name = "Lock"
		icon = 'code/Smithing/Lock.dmi'
		icon_state = "Lock"
		desc = "Creates a lock for an existing key that you have in your inventory.<br />\
				1 Bar"
		tooltipRows = 3
		req = list(	BAR		=	1)
		built = /obj/Item/Metal/Lock
		condition(mob/m) if(..())
			var keys[0]
			for(var/obj/Item/Metal/Key/key in m) keys += key
			for(var/obj/Item/Metal/Keychain/chain in m) keys += chain.contents
			var obj/Item/Metal/Key/key = input(m, "Which key will you make a lock for?", "Locksmith") as null|anything in keys
			if(istype(key)) return key.id

	keychain
		name = "Keychain"
		icon = 'code/Smithing/Keychain.dmi'
		icon_state = "item"

		desc = "Used to hold multiple keys<br />\
				2 Bars<br />"
		tooltipRows = 2

		req = list(	BAR		=	2)
		built = /obj/Item/Metal/Keychain

	handcuffs
		name = "Handcuffs"
		icon = 'code/Smithing/handcuffs.dmi'
		condition(mob/m) if(..())
			var keys[0]
			for(var/obj/Item/Metal/Key/key in m) keys += key
			for(var/obj/Item/Metal/Keychain/chain in m) keys += chain.contents
			var obj/Item/Metal/Key/key = input(m, "Which key will you make handcuffs for?", "Handcuffs") as null|anything in keys
			if(key) return key.id

		desc = "Prevents the wearer from holding anything<br />\
				6 Bars"
		tooltipRows = 2

		req = list(	BAR		=	6)
		built = /obj/Item/binders/Handcuffs

	footcuffs
		name = "Footcuffs"
		icon = 'code/Smithing/footcuffs.dmi'
		condition(mob/m) if(..())
			var keys[0]
			for(var/obj/Item/Metal/Key/key in m) keys += key
			for(var/obj/Item/Metal/Keychain/chain in m) keys += chain.contents
			var obj/Item/Metal/Key/key = input(m, "Which key will you make footcuffs for?", "Footcuffs") as null|anything in keys
			if(key) return key.id

		desc = "Prevents the wearer from moving<br />\
				6 Bars"
		tooltipRows = 2

		req = list(	BAR		=	6)
		built = /obj/Item/binders/Footcuffs

	pole
		name =	"Pole"
		icon = 'code/Smithing/Pole.dmi'

		desc = "The most exciting object in the game!!!<br />\
				1 Bar"
		tooltipRows = 2

		req = list(	BAR		=	1)
		built = /obj/Item/Metal/Pole
		build_amount = 2

	hazium_coins
		name = "Hazium Coins"
		icon = 'code/Smithing/Coin.dmi'
		group_only = 1

		desc = "A rare form of currency!<br />\
				1 Hazium Bar"
		tooltipRows = 2

		req = list(	HBAR	=	1)
		built = /obj/Item/Metal/Coins
		build_amount = 5

	metal_coins
		name = "Metal Coins"
		icon = 'code/Smithing/Metal Coin.dmi'
		group_only = 1

		desc = "A common form of currency<br />\
				1 Bar"
		tooltipRows = 2

		req = list(	BAR		=	1)
		built = /obj/Item/Metal/Metal_Coins
		build_amount = 5

	shield
		name = "Shield"
		icon = 'code/Weapons/Shield.dmi'
		icon_state = "item"
		allowed_races = HUMAN

		desc = "A protective piece of equipment<br />\
				5 Bars"
		tooltipRows = 2

		req = list(	BAR		=	5)
		built = /obj/Item/Weapons/Shield

	kite_shield
		name = "Kite Shield"
		icon = 'code/Weapons/Kite Shield.dmi'
		icon_state = "item"
		group_only = 1
		allowed_races = HUMAN

		desc = "A more advanced shield<br />\
				6 Bars"
		tooltipRows = 2

		req = list(	BAR		=	6)
		built = /obj/Item/Weapons/Kite_Shield

	tower_shield
		name = "Tower Shield"
		icon = 'code/Weapons/Tower Shield.dmi'
		icon_state = "item"
		group_only = 1
		allowed_races = HUMAN

		desc = "A massive, towering shield<br />\
				8 Bars<br />\
				1 Hazium Bar"
		tooltipRows = 3

		req = list(	BAR		=	8,
					HBAR	=	1)
		built = /obj/Item/Weapons/Tower_Shield

	coif
		name = "Coif"
		icon = 'code/Clothes/Coif.dmi'

		desc = "A protective chainmail coif<br />\
				2 Bars"
		tooltipRows = 2

		req = list(	BAR		=	2)
		built = /obj/Item/Armour/Helmet/Coif

	crown
		name = "Crown"
		icon = 'code/Smithing/Crown.dmi'
		group_only = 1

		desc = "The definite sign of royalty!<br />\
				1 Hazium Bar"
		tooltipRows = 2

		req = list(	HBAR	=	1)
		built = /obj/Item/Armour/Accessory/Crown

	metal_helmet
		name = "Metal Helmet"
		icon = 'code/Clothes/Helmet.dmi'

		desc = "Metal protection for your head<br />\
				3 Bars"
		tooltipRows = 2

		req = list(	BAR		=	3)
		built = /obj/Item/Armour/Helmet/Metal_Helmet

	metal_helmet_north
		name = "Northern Metal Helmet"
		icon = 'code/Clothes/Helmet_North.dmi'

		desc = "A northerner variant of the original<br />\
				3 Bars"
		tooltipRows = 2

		req = list(	BAR		=	3)
		built = /obj/Item/Armour/Helmet/Metal_Helmet_North

	short_mail
		name = "Short Mail"
		icon = 'code/Clothes/Chain_S-Sleeve.dmi'

		desc = "The chainmail for hot Bloomstides<br />\
				4 Bars"
		tooltipRows = 2

		req = list(	BAR		=	4)
		built = /obj/Item/Armour/Shirt/Short_Mail

	chainmail
		name = "Chainmail"
		icon = 'code/Clothes/Chainmail.dmi'

		desc = "Quick protection for your torso<br />\
				5 Bars"
		tooltipRows = 2

		req = list(	BAR		=	5)
		built = /obj/Item/Armour/Shirt/Chainmail

	mail_pants
		name = "Mail Pants"
		icon = 'code/Clothes/Chain_Pants.dmi'

		desc = "Quick protection for your legs<br />\
				5 Bars"
		tooltipRows = 2

		req = list(	BAR		=	5)
		built = /obj/Item/Armour/Pants/Mail_Pants

	scissors
		name = "Scissors"
		icon = 'code/Tools/Scissors.dmi'
		icon_state = "item"

		desc = "Used to shear Sty. Don't run with these!<br />\
				3 Bars"
		tooltipRows = 2

		req = list(	BAR		=	3)
		built = /obj/Item/Tools/Scissors

	tongs
		name = "Tongs"
		icon = 'code/Tools/Tongs.dmi'
		icon_state = "item"

		desc = "Used to put ore in the hot forge!<br />\
				2 Bars"
		tooltipRows = 2

		req = list(	BAR		=	2)
		built = /obj/Item/Tools/Tongs

	pan
		name = "Pan"
		icon = 'code/Tools/Pan.dmi'
		icon_state = "item"

		desc = "Used to cook food on a range!<br />\
				2 Bars"
		tooltipRows = 2

		req = list(	BAR		=	2)
		built = /obj/Item/Tools/Pan

	pot
		name = "Pot"
		icon = 'code/Smithing/Pot.dmi'

		desc = "Used to cook food on a range!<br />\
				2 Bars"
		tooltipRows = 2

		req = list(	BAR		=	2)
		built = /obj/Item/Metal/Pot

	rune_stone
		name = "Rune Stone"
		icon = 'code/Magic/Runestone.dmi'
		icon_state = "item"

		desc = "These are rare items used alongside rune circles!<br />\
				5 Hazium Bars<br />\
				5 Crystalized Haziums<br />\
				2 Bars"
		tooltipRows = 6

		req = list(	HBAR	=	5,
					CHAZ	=	5,
					BAR		=	2)
		built = /obj/Item/Rune_Stone

	greaves
		name = "Greaves"
		icon = 'code/Clothes/Greaves.dmi'
		group_only = 1
		allowed_races = HUMAN

		desc = "Metal plate armor for your feet<br />\
				1 Hazium Bar<br />\
				2 Bars"
		tooltipRows = 3

		req = list(	HBAR	=	1,
					BAR		=	2)
		built = /obj/Item/Armour/Feet/Greaves

	gauntlets
		name = "Gauntlets"
		icon = 'code/Clothes/Gauntlets.dmi'
		group_only = 1
		allowed_races = HUMAN

		desc = "These are nothing like mittens<br />\
				1 Hazium Bar<br />\
				2 Bars"
		tooltipRows = 3

		req = list(	HBAR	=	1,
					BAR		=	2)
		built = /obj/Item/Armour/Hands/Gauntlets

	plate_helmet
		name = "Plate Helmet"
		icon = 'code/Clothes/Plate_Helmet_Visor.dmi'
		group_only = 1
		allowed_races = HUMAN

		desc = "The ultimate protection for your head!<br />\
				1 Hazium Bar<br />\
				3 Bars"
		tooltipRows = 3

		req = list(	HBAR	=	1,
					BAR		=	3)
		built = /obj/Item/Armour/Helmet/Plate_Helmet_Visor

	plate_helmet2
		name = "Plate Helmet"
		icon = 'code/Clothes/Plate_Helmet_Plume_Visor.dmi'
		icon_state = "plume"
		group_only = 1
		allowed_races = HUMAN

		desc = "The ultimate protection for your head!<br />\
				1 Hazium Bar<br />\
				3 Bars<br />\
				1 Thread"
		tooltipRows = 4

		req = list(	HBAR	=	1,
					BAR		=	3)
		built = /obj/Item/Armour/Helmet/Plate_Helmet_Plume_Visor

	plate_helmet3
		name = "Plate Helmet"
		icon = 'code/Clothes/Plate_Helmet.dmi'
		icon_state = "face"
		group_only = 1
		allowed_races = HUMAN

		desc = "The ultimate protection for your head!<br />\
				1 Hazium Bar<br />\
				3 Bars"
		tooltipRows = 3

		req = list(	HBAR	=	1,
					BAR		=	3)
		built = /obj/Item/Armour/Helmet/Plate_Helmet

	plate_helmet4
		name = "Plate Helmet"
		icon = 'code/Clothes/Plate_Helmet_Plume.dmi'
		icon_state = "plume face"
		group_only = 1
		allowed_races = HUMAN

		desc = "The ultimate protection for your head!<br />\
				1 Hazium Bar<br />\
				3 Bars<br />\
				1 Thread"
		tooltipRows = 4

		req = list(	HBAR	=	1,
					BAR		=	3)
		built = /obj/Item/Armour/Helmet/Plate_Helmet_Plume

	plate_helmet_reinforced
		name = "Reinforced Plate Helmet"
		icon = 'code/Clothes/Plate_Helmet_Reinforced.dmi'
		group_only = 1
		allowed_races = HUMAN

		desc = "The ultimate protection for your head!<br />\
				1 Hazium Bar<br />\
				3 Bars"
		tooltipRows = 3

		req = list(	HBAR	=	1,
					BAR		=	3)
		built = /obj/Item/Armour/Helmet/Plate_Helmet_Reinforced

	plate_legs
		name = "Plate Legs"
		icon = 'code/Clothes/Plate Legs.dmi'
		group_only = 1
		allowed_races = HUMAN

		desc = "Heavy armor for your legs, sure to slow you down<br />\
				1 Hazium Bar<br />\
				5 Bars"
		tooltipRows = 3

		req = list(	HBAR	=	1,
					BAR		=	5)
		built = /obj/Item/Armour/Pants/Plate_Legs

	plate_shirt
		name = "Plate Shirt"
		icon = 'code/Clothes/Plate Shirt.dmi'
		group_only = 1
		allowed_races = HUMAN

		desc = "The best protection for your torso<br />\
				1 Hazium Bar<br />\
				5 Bars"
		tooltipRows = 3

		req = list(	HBAR	=	1,
					BAR		=	5)
		built = /obj/Item/Armour/Shirt/Plate_Shirt

	plated_cape
		name = "Plated Cape"
		icon = 'code/Clothes/Shoulder_Cape.dmi'
		group_only = 1
		allowed_races = HUMAN

		desc = "Keep your back warm and your shoulders protected<br />\
				5 Threads<br />\
				1 Hazium Bar<br />\
				2 Bars"
		tooltipRows = 5

		req = list(	THREAD	=	5,
					HBAR	=	1,
					BAR		=	2)
		built = /obj/Item/Armour/Back/Plated_Cape

	axe
		name = "Axe"
		icon = 'code/Weapons/Axe.dmi'
		icon_state = "item"

		desc = "Not your typical hatchet<br />\
				3 Bars"
		tooltipRows = 2

		req = list(	BAR		=	3)
		built = /obj/Item/Weapons/Axe

	sparth
		name = "Sparth"
		icon = 'code/Weapons/Sparth.dmi'
		icon_state = "item"
		group_only = 1

		desc = "Very different than your typical hatchet<br />\
				4 Bars<br />\
				1 Hazium Bar"
		tooltipRows = 4

		req = list(	BAR		=	4,
					HBAR	=	1)
		built = /obj/Item/Weapons/Sparth

	broadaxe
		name = "Broadaxe"
		icon = 'code/Weapons/Broadaxe.dmi'
		icon_state = "item"
		group_only = 1

		desc = "Not your typical axe<br />\
				6 Bars<br />\
				1 Hazium Bar"
		tooltipRows = 3

		req = list(	BAR		=	6,
					HBAR	=	1)
		built = /obj/Item/Weapons/Broadaxe

	spear
		name = "Spear"
		icon = 'code/Weapons/Spear.dmi'
		icon_state = "item"

		desc = "Good for tribal warfare<br />\
				3 Bars"
		tooltipRows = 2

		req = list(	BAR		=	3)
		built = /obj/Item/Weapons/Spear

	corseque
		name = "Corseque"
		icon = 'code/Weapons/Corseque.dmi'
		icon_state = "item"
		group_only = 1

		desc = "Better for tribal warfare<br />\
				4 Bars<br />\
				1 Hazium Bar"
		tooltipRows = 3

		req = list(	BAR		=	4,
					HBAR	=	1)
		built = /obj/Item/Weapons/Corseque

	glaive
		name = "Glaive"
		icon = 'code/Weapons/Glaive.dmi'
		icon_state = "item"
		group_only = 1

		desc = "Best for tribal warfare<br />\
				5 Bars<br />\
				1 Hazium Bar"
		tooltipRows = 3

		req = list(	BAR		=	5,
					HBAR	=	1)
		built = /obj/Item/Weapons/Glaive

	dagger
		name = "Dagger"
		icon = 'code/Weapons/dagger.dmi'
		icon_state = "item"

		desc = "Small but deadly.<br />\
				2 Bars"
		tooltipRows = 2

		req = list(	BAR		=	2)
		built = /obj/Item/Weapons/Dagger

	sword
		name = "Sword"
		icon = 'code/Weapons/Sword.dmi'
		icon_state = "item"

		desc = "It's dangerous to go alone! Take this.<br />\
				3 Bars"
		tooltipRows = 2

		req = list(	BAR		=	3)
		built = /obj/Item/Weapons/Sword

	sabre
		name = "Sabre"
		icon = 'code/Weapons/Sabre.dmi'
		icon_state = "item"
		group_only = 1

		desc = "Strike fear into your enemies!<br />\
				4 Bars<br />\
				1 Hazium Bar"
		tooltipRows = 3

		req = list(	BAR		=	4,
					HBAR	=	1)
		built = /obj/Item/Weapons/Sabre

	longsword
		name = "Longsword"
		icon = 'code/Weapons/Longsword.dmi'
		icon_state = "item"
		group_only = 1

		desc = "Strike THIS into your enemies!<br />\
				5 Bars<br />\
				1 Hazium Bar"
		tooltipRows = 3

		req = list(	BAR		=	5,
					HBAR	=	1)
		built = /obj/Item/Weapons/Longsword

	mace
		name = "Mace"
		icon = 'code/Weapons/Mace.dmi'
		icon_state = "item"
		group_only = 1

		desc = "The perfect blunt weapon<br	/>\
				3 Bars"
		tooltipRows = 2

		req = list(	BAR		=	3)
		built = /obj/Item/Weapons/Mace

	flail
		name = "Flail"
		icon = 'code/Weapons/Flail.dmi'
		icon_state = "item"
		group_only = 1

		desc = "Like a mace, but on a chain<br />\
				3 Bars"
		tooltipRows = 2

		req = list(	BAR		=	3)
		built = /obj/Item/Weapons/Flail

	halberd
		name = "Halberd"
		icon = 'code/Weapons/Halberd.dmi'
		icon_state = "item"
		group_only = 1

		desc = "A long spear with an axe head on the end<br />\
				3 Bars"
		tooltipRows = 2

		req = list(	BAR		=	3)
		built = /obj/Item/Weapons/Halberd

	stoof_plate
		name = "Stoof Plate"
		icon = 'code/Animals/animal_armour.dmi'
		icon_state = "stoof plate"
		group_only = 1
		allowed_races = HUMAN

		desc = "A must have for that special steed<br />\
				4 Hazium Bar<br />\
				6 Bars"
		tooltipRows = 3

		req = list(	HBAR	=	3,
					BAR		=	6)
		built = /obj/Item/Armour/Animal/stoof_plate

	stoof_helm
		name = "Stoof Helmet"
		icon = 'code/Animals/animal_armour.dmi'
		icon_state = "stoof helm"
		group_only = 1
		allowed_races = HUMAN

		desc = "A must have for that special steed<br />\
				2 Hazium Bar<br />\
				3 Bars"
		tooltipRows = 3

		req = list(	HBAR	=	2,
					BAR		=	3)
		built = /obj/Item/Armour/Animal/stoof_helm

	deco_sword
		name = "Decorative Sword"
		icon = 'code/Smithing/deco_sword.dmi'
		group_only = 1

		desc = "It doesn't do much, but at least it looks<br />\
				cool!<br />\
				5 Bars<br />\
				2 Leathers"
		tooltipRows = 4

		req = list(	BAR		=	5,
					LEATHER	=	2)
		built = /obj/Item/Armour/Accessory/deco_sword

	deco_axe
		name = "Decorative Axe"
		icon = 'code/Smithing/deco_axe.dmi'
		group_only = 1

		desc = "It does even less, but at least it looks<br />\
				cool!<br />\
				5 Bars<br />\
				2 Leathers"
		tooltipRows = 4

		req = list(	BAR		=	5,
					LEATHER	=	2)
		built = /obj/Item/Armour/Accessory/deco_axe

	Brump
		name = "Brump"
		icon = 'code/music/brump.dmi'
		icon_state = "item"

		desc = "The fanfare of the Hdroza of yesterwipe!<br />\
				2 Nails<br />\
				5 Hazium Bars"
		tooltipRows = 3

		req = list( NAIL	=	2,
					HBAR	=	5)
		built = /obj/Item/Tools/Instrument/Brump

	amulet
		name = "Amulet"
		icon = 'code/Smithing/amulet.dmi'
		icon_state = "item"

		desc = "Wear a hazium crystal!<br />\
				1 Hazium Bar<br />\
				1 Hazium Crystal"
		tooltipRows = 3

		req = list(	HBAR	=	1,
					CRYSTAL	=	1)

		built = /obj/Item/Armour/Accessory/Amulet

	coin_stamp
		name = "Coin Stamp"
		icon = 'code/tools/coin stamp.dmi'
		icon_state = "item"
		group_only = TRUE

		desc = "Stamp your group's identification onto a stack of coins!<br />\
				Or just remove the coins' existing stamp!<br />\
				1 Bar<br />\
				1 Hazium Bar<br />\
				1 Board"
		tooltipRows = 3

		req = list(	HBAR	=	1,
					BAR		=	1,
					BOARD	=	1)

		built = /obj/Item/Tools/Coin_Stamp

		condition(mob/player/m)
			if(!m.Group || m.Group.rank(m) > 2)
				m.aux_output("You must be rank 2 or above in a group to make this!")
			else return ..()

		success(mob/player/m, products[])
			var obj/Item/Tools/Coin_Stamp/s = products[1]
			if(!condition(m)) del s
			var group/g = m.Group
			s.group_id = g.id
			s.group_name = g.name
			s.name += "\[[g.name]]"