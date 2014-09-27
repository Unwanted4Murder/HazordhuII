
var
	Population
	maxAnimalPop = 2000

mob/Animal
	var
		tmp/can_lay = TRUE

		//	defaults to basic herbivore
		diet = GRASS | FARM

		//	"aggressive" "defensive" "passive" "friendly"
		//	this is what we'll use to determine if an animal will attack
		mood = "friendly"

		mountSpeed = 5
		bred
		colour

		charge_list[] = list("thunders towards","charges at","runs at","rushes forward at")
		warn_list[] = list("growls","wails","snarls","paws at the ground","stomps the ground")
		attack_list[] = list("attacks", "claws", "tramples", "bashes", "bites")

		passive_sounds[]
		aggressive_sounds[]

		obj/Built/Boat/on_boat

	SET_TBOUNDS("9,9 to 24,24")
	SET_STEP_SIZE(2)

	Strength = 5
	MeatType = /obj/Item/Food/Meat/Lar
	SkinType = /obj/Item/Fur

	interact(mob/humanoid/m)
		if(boat)
			if(boat.take_off(src))
				m.emote("takes the [src] off of the [boat.name]")

		else if(can_harness)
			if(locate(/obj/Item/Tailoring/Harness) in src)
				m.mount_animal(src)

			else
				var obj/Item/Tailoring/Harness/h = m.equipment["main"]
				if(istype(h))
					h.place(src, m)

	interact_right(mob/humanoid/m)
		if(can_harness && (locate(/obj/Item/Tailoring/Harness) in src))
			remove_harness(m)

	Bux
		icon = 'Bux.dmi'
		Health = 40
		mood = "passive"
		diet = GRASS | FARM
		Strength = 15
		SET_TBOUNDS("10,1 to 23,12")

	Mur
		mood = "passive"
		SET_TBOUNDS("10,1 to 23,12")
		diet = GRASS | FARM
		icon = 'Mur.dmi'
		Health = 40
		mountSpeed = 2
		var milked

	Sty
		icon = 'sty.dmi'
		can_harness = FALSE
		mood = "defensive"
		diet = GRASS | FARM
		MeatType = /obj/Item/Food/Meat/Sma
		SkinType = /obj/Item/Farming/crop/Phluf
		Health = 10
		passive_sounds = list(sound('code/Sounds/Lamb.wav', volume=25))

		SET_BOUNDS(13, 11, 6, 2)

		interact(mob/humanoid/m) return shear(m)

		var sheared
		proc/shear(mob/humanoid/m)
			if(Locked || m.Locked || !m.has_scissors()) return
			if(sheared) return m.aux_output("That [src] has been sheared this year.")
			m.used_tool()
			sheared = TRUE
			Locked = TRUE
			m.emote("starts shearing the sty")
			m._do_work(30)
			m.emote("finishes shearing the sty")
			Locked = FALSE
			new /obj/Item/Farming/crop/Phluf (loc)
			return TRUE

	Peek
		icon = 'Peek.dmi'
		can_harness = FALSE
		mood = "passive"
		diet = GRASS | FARM
		Health = 35
		MeatType = /obj/Item/Food/Meat/Sma
		SkinType = /obj/Item/Feather
		Strength = 3
		passive_sounds = list('code/Sounds/CROW3.wav')
		SET_TBOUNDS("13,14 to 20,19")

	Ret
		icon = 'Ret.dmi'
		can_harness = FALSE
		diet = MEAT | SPORE
		mood = "aggressive"
		Strength = 10
		Health = 50
		MaxHealth = 50
		MeatType = /obj/Item/Food/Meat/Sma
		attack_list = list("attacks", "claws", "hits", "paws", "bites")
		charge_list = list("scampers towards","scurries to","runs at","rushes forward at")
		warn_list = list("wails","squeaks","paws at the ground","claws the ground")
		passive_sounds = list(	sound('code/Sounds/rat1.wav', volume = 20),
								sound('code/Sounds/rat3.wav', volume = 20))
		aggressive_sounds = list(sound('code/Sounds/rat2.wav', volume = 20))

	Rar
		icon = 'Rar.dmi'
		can_harness = FALSE
		mood = "aggressive"
		diet = MEAT
		Health = 250
		Strength = 50
		passive_sounds = list(sound('code/Sounds/bearbackground.wav', volume = 20))
		aggressive_sounds = list(sound('code/Sounds/bearbackground.wav', volume = 20))

	Ruff
		icon = 'Ruff.dmi'
		can_harness = FALSE
		diet = MEAT
		mood = "aggressive"
		Health = 100
		Strength = 20
		attack_list = list("attacks", "claws", "hits", "paws", "bites")
		charge_list = list("leaps towards","scurries to","runs at","rushes forward at")
		warn_list = list("barks","howls","paws at the ground","claws the ground")
		passive_sounds = list(sound('code/Sounds/dog.wav', volume = 25))
		aggressive_sounds = list(sound('code/Sounds/dog.wav', volume = 25))

	Flurm
		icon = 'flurm.dmi'
		can_harness = FALSE
		diet = MEAT
		mood = "aggressive"
		Strength = 40
		charge_list = list("charges at","runs at","rushes forward at")
		warn_list = list("wails","squeaks","shreiks","squirts")
		attack_list = list("attacks", "spews at", "body slams", "bashes", "bites")
		Flurm1
			icon = 'flurm1.dmi'
			name = "Flurm"
			Strength = 40

	Olihant
		icon = 'olihant.dmi'
		can_harness = TRUE
		mood = "aggressive"
		diet = FARM | PLANT | FISH
		Strength = 100
		Health = 700
		SET_BOUNDS(4, 0, 24, 16)
		pixel_x = -16
		mountSpeed = 3

	Stoof
		icon = 'Stoof.dmi'
		mountSpeed = 6
		mood = "defensive"
		diet = GRASS | FARM | PLANT
		SET_TBOUNDS("10,1 to 23,12")
		passive_sounds = list(
			sound('code/Sounds/horse.wav', volume=10),
			sound('code/Sounds/horsebg1.wav', volume=25),
			sound('code/Sounds/horsebg2.wav', volume=25))

	Grawl
		SkinType = /obj/Item/Grawl_Fur
		SET_TBOUNDS("10,1 to 23,12")
		icon = 'Grawl.dmi'
		diet = MEAT
		mood = "aggressive"
		Strength = 50
		can_harness = TRUE
		charge_list = list("pounces at","runs at","charges at")
		warn_list = list("roars","growls")
		attack_list = list("attacks", "claws at", "bites", "pounces on")
		Health = 500
		Stamina = 5000
		North
			SkinType = /obj/Item/North_Grawl_Fur
			icon = 'Grawl1.dmi'
			name = "Grawl"

	Hoge
		icon = 'Hoge.dmi'
		icon_state = "1"
		diet = MEAT | CORPSE
		mood = "aggressive"
		can_harness = FALSE
		charge_list = list("runs at","rushes forward at")

	Troll
		icon='code/Mobs/Troll.dmi'
		can_harness = FALSE
		diet = MEAT
		mood = "aggressive"
		Health = 1000
		Stamina = 5000
		Strength = 70
		SkinType = /obj/Item/Skin/Troll_Skin

	Flargl
		pixel_x = -24
		icon='code/Animals/flargl.dmi'
		SkinType=/obj/Item/Skin/Flargl_Skin
		can_harness = FALSE
		diet = MEAT
		mood = "aggressive"
		Health = 5000
		Stamina = 5000
		Strength = 70
		SET_TBOUNDS("-8,2 to 40,24")
		warn_list = list(
			"lets out a fearsome cry",
			"roars to the sky",
			"grunts a puff of smoke",
			"beats its wings")

	Agriner
		pixel_x = -24
		icon = 'code/Animals/Agriner.dmi'
		can_harness = FALSE
		diet = GRASS | FARM | PLANT
		mood = "aggressive"
		Health = 500
		Stamina = 5000
		Strength = 100
		SET_BOUNDS(0, 0, 32, 16)
		warn_list = list("rears back its horn","snorts loudly","stomps the ground")
		charge_list = list("charges at", "thunders towards")
		attack_list = list("tramples", "bashes", "smashes into")

	Shomp
		pixel_x = -16
		pixel_y = -16
		icon = 'code/Animals/Shomp.dmi'
		can_harness = FALSE
		diet = MEAT | CORPSE
		mood = "aggressive"
		Health = 200
		Stamina = 5000
		Strength = 50
		warn_list = list("whips back its tail","bites at the air","rears its head")
		charge_list = list("scurries to")
		attack_list = list("bites at")

	Ramar
		pixel_x = -16
		pixel_y = -16
		density = FALSE
		layer = TURF_LAYER
		icon='code/Animals/Ramar.dmi'
		can_harness = FALSE
		diet = MEAT | CORPSE
		mood = "aggressive"
		Health = 170
		Stamina = 5000
		Strength = 30
		warn_list = list("hides in the water","silently stalks its prey")
		charge_list = list("swims toward")
		attack_list = list("bites at","tears at")

	Kaw
		icon = 'Kawsmaller.dmi'
		can_harness = 0
		diet = MEAT
		mood = "aggressive"
		MeatType = /obj/Item/Food/Meat/Sma
		SkinType = /obj/Item/Feather
		Health = 200
		Strength = 30
		charge_list = list("swoops down on","flies toward")
		warn_list = list("screeches","flaps its wings")
		attack_list = list("attacks", "claws at")

		passive_sounds = list('code/Sounds/CROW3.wav')
		aggressive_sounds = list('code/Sounds/CROW3.wav')

	Scree
		icon='Scree.dmi'
		can_harness = 0
		diet = MEAT | CORPSE
		mood = "aggressive"
		MeatType = /obj/Item/Food/Meat/Sma
		SkinType = /obj/Item/Feather
		Health = 200
		Strength = 30
		charge_list = list("swoops down on","flies toward")
		warn_list = list("screeches","flaps its wings")
		attack_list = list("attacks", "claws at")

		passive_sounds = list('code/Sounds/CROW3.wav')
		aggressive_sounds = list('code/Sounds/CROW3.wav')

mob/slith
	icon = 'Slith.dmi'
	New()
		..()
		flick("go", src)
		sleep 7
		set_loc()