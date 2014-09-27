obj
	Built
		Cauldron
			interact(mob/m) return filled ? be_emptied(m) : be_filled(m)

			proc/scoop(mob/m, obj/Item/Alchemy/Bottle/b)
				if(!elements || !elements.len) return

				var e[] = list(
					"Metals" = 0,	"Haziums" = 0,	"Clays" = 0,
					"Stones" = 0,	"Dirts"   = 0,	"Sands" = 0,
					"Meats"	 = 0,	"Plants"  = 0,	"Woods" = 0)

				for(var/t in elements) e[t] ++

				var newpotion
				for(var/obj/Alchemy/o in Alchemy_List)
					var match = 1
					for(var/t in e)
						if(e[t] != o.vars[t])
							match = 0
					if(match)
						newpotion = o.Built
						break

				m.emote("takes out some of the mixture. Looks like [--filled] bottle-full\s left.")

				if(filled <= 0)
					icon_state = ""
					elements = new

				del b

				if(newpotion) return new newpotion (m)
				return new /obj/Item/Alchemy/Bottle/Potion/MessUp (m)

obj
	Alchemy
		icon = 'code/Alchemy/Bottle.dmi'

		rightClick(mob/m)
			m.aux_output("\icon[src] [src]")
			for(var/v in list("Metals", "Sands", "Stones", "Meats", "Haziums", "Dirts", "Clays", "Woods", "Plants"))
				if(vars[v]) m.aux_output("[vars[v]] [v]\s")
			..()

		DblClick()
			usr.aux_output("To make potions, right click elements to pour them in.")
			usr.aux_output("Then, double click the cauldron with a bottle to take some out.")
			..()

		var
			Experience

			Metals	=	0
			Sands	=	0
			Stones	=	0
			Meats	=	0
			Haziums	=	0
			Dirts	=	0
			Clays	=	0
			Woods	=	0
			Plants	=	0

			Built

		Ink
			icon_state="Dirt"
			name="Ink"
			Dirts = 1
			Experience = 10
			Built = /obj/Item/Alchemy/Bottle/Potion/Ink

		Health_1
			icon_state="Meat"
			name="Weak Health"
			Meats = 1
			Experience = 10
			Built = /obj/Item/Alchemy/Bottle/Potion/Health_1

		Health_2
			icon_state="Meat"
			name="Health"
			Meats = 3
			Experience = 30
			Built = /obj/Item/Alchemy/Bottle/Potion/Health_2

		Health_3
			icon_state="Meat"
			name="Strong Health"
			Meats = 5
			Experience = 50
			Built = /obj/Item/Alchemy/Bottle/Potion/Health_3

		Health_Max
			icon_state="Meat"
			name="Full Health"
			Meats = 10
			Experience = 100
			Built = /obj/Item/Alchemy/Bottle/Potion/Health_Max

		Poison_1
			icon_state="Meat"
			name="Weak Poison"
			Meats = 5
			Plants = 3
			Metals = 1
			Dirts = 1
			Experience = 100
			Built = /obj/Item/Alchemy/Bottle/Potion/Poison_1

		Poison_2
			icon_state="Meat"
			name="Poison"
			Meats = 5
			Plants = 3
			Metals = 2
			Dirts = 2
			Experience = 120
			Built = /obj/Item/Alchemy/Bottle/Potion/Poison_2

		Poison_3
			icon_state="Meat"
			name="Strong Poison"
			Meats = 5
			Plants = 3
			Metals = 3
			Dirts = 3
			Experience = 140
			Built = /obj/Item/Alchemy/Bottle/Potion/Poison_3

/*
		Stoneskin_1
			icon_state="Stone"
			name="Weak Stoneskin"
			Stones = 3
			Dirts = 2
			Experience = 50
			Built = /obj/Item/Alchemy/Bottle/Potion/Stoneskin_1

		Stoneskin_2
			icon_state="Stone"
			name="Stoneskin"
			Stones = 5
			Dirts = 2
			Experience = 70
			Built = /obj/Item/Alchemy/Bottle/Potion/Stoneskin_2

		Stoneskin_3
			icon_state="Stone"
			name="Strong Stoneskin"
			Stones = 8
			Dirts = 2
			Experience = 100
			Built = /obj/Item/Alchemy/Bottle/Potion/Stoneskin_3
*/

		Strength_1
			icon_state="Metal"
			name="Weak Strength"
			Metals = 3
			Dirts = 2
			Experience = 50
			Built = /obj/Item/Alchemy/Bottle/Potion/Strength_1

		Strength_2
			icon_state="Metal"
			name="Strength"
			Metals = 5
			Dirts = 2
			Experience = 70
			Built = /obj/Item/Alchemy/Bottle/Potion/Strength_2

		Strength_3
			icon_state="Metal"
			name="Strong Strength"
			Metals = 8
			Dirts = 2
			Experience = 100
			Built = /obj/Item/Alchemy/Bottle/Potion/Strength_3

		Water
			icon_state="Wood"
			name="Waterwalk"
			Woods = 5
			Sands = 3
			Experience = 80
			Built = /obj/Item/Alchemy/Bottle/Potion/Waterwalk

		Suffocation
			icon_state="Wood"
			name="Suffocation"
			Woods = 5
			Dirts = 3
			Experience = 80
			Built = /obj/Item/Alchemy/Bottle/Potion/Suffocation

/*
		Explosion_1
			icon_state="Dirt"
			name="Weak Explosion"
			Dirts = 10
			Haziums = 1
			Experience = 110
			Built = /obj/Item/Alchemy/Bottle/Potion/Explosion_1

		Explosion_2
			icon_state="Dirt"
			name="Explosion"
			Dirts = 10
			Haziums = 3
			Experience = 130
			Built = /obj/Item/Alchemy/Bottle/Potion/Explosion_2

		Explosion_3
			icon_state="Dirt"
			name="Strong Explosion"
			Dirts = 10
			Haziums = 5
			Experience = 150
			Built = /obj/Item/Alchemy/Bottle/Potion/Explosion_3
*/


obj/Item/Alchemy
	Bottle
		icon = 'code/Alchemy/Bottle.dmi'
		var drinkable = 1
		value = 9
		use(mob/m) if(loc == m)
			if(m.Locked) return
			var front[] = m.front()
			var obj/Built/Well/well = locate() in front
			if(well)
				new /obj/Item/Alchemy/Bottle/Water (m)
				del src

			var obj/Built/Fountain/fountain = locate() in front
			if(fountain)
				if(get_season() == WINTER) return
				new /obj/Item/Alchemy/Bottle/Water (m)
				del src

			var turf/Environment/Water/water = locate() in front
			if(water)
				if(get_season() == WINTER) return
				new /obj/Item/Alchemy/Bottle/Water (m)
				del src

			var mob/Animal/Mur/mur = locate() in front
			if(mur)
				new /obj/Item/Alchemy/Bottle/Mylk (m)
				del src

			var obj/Built/Cauldron/cauldron = locate() in front
			if(cauldron)
				cauldron.scoop(m, src)

		Water
			icon_state = "Water"
			use(mob/m) if(loc == m)
				if(m.can_drink(src))
					if(m.Thirst)
						m.emote("starts drinking water from the bottle")
						m.Locked = TRUE
						while(m.Thirst > 0)
							m.status_overlay("thirst", 1)
							sleep 1
							m.Thirst --
						m.Thirst = 0
						m.emote("finishes drinking water from the bottle")
						m.Locked = FALSE
						m.lose_item(src)
						m.get_item(/obj/Item/Alchemy/Bottle)
					else m.aux_output("You don't need to drink.")

		Mylk
			icon_state = "Mylk"
			use(mob/m) if(loc == m)
				if(m.can_drink(src))
					if(m.Thirst)
						m.Locked = TRUE
						m.emote("starts drinking mylk from the bottle")
						while(m.Thirst > 0)
							m.status_overlay("thirst", 1)
							sleep 1
							m.Thirst --
						m.emote("finishes drinking mylk from the bottle")
						m.Locked = FALSE
						m.Thirst = 0
						m.lose_item(src)
						m.get_item(/obj/Item/Alchemy/Bottle)
					else m.aux_output( "You don't need to drink.")


		Potion
			//Metal		Blue
			//Hazium	Purple
			//Clay		Lime Green
			//Stone		Pink
			//Dirt		Black
			//Sand		Light Blue
			//Meat		Red
			//Plant		Yellow
			//Wood		Green
			name = "Potion"
			Stackable = FALSE
			proc/activate(mob/m)

			use(mob/m) if(loc == m)
				if(m.can_drink(src))
					Move(m.loc)
					set_loc()
					new /obj/Item/Alchemy/Bottle (m)
					if(drinkable)
						m.aux_output("You drink [src].")
						activate(m)

			MessUp	//	When you mess up the mixture, this comes out.
				icon_state = "Bad"
				activate(mob/m)
					m.aux_output(pick(
						"Tasteless potion.",
						"Reminds you of cardboard.",
						"Tastes like air."))

			Ink
				icon_state = "Dirt"
				drinkable = FALSE

			Healing
				icon_state = "Meat"
				var strength
				activate(mob/mortal/m)
					m.gain_health(strength)
			Health_1
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Healing
				strength = 10
			Health_2
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Healing
				strength = 25
			Health_3
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Healing
				strength = 50
			Health_Max
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Healing
				strength = 1.#INF


			Poison
				icon_state = "Meat"
				var min_strength
				var max_strength
				var duration = 600
				activate(mob/mortal/m)
					m.Poisoned ++
					for(var/n in 1 to duration)
						if(!m) return
						m.take_damage(randn(min_strength, max_strength), "poison")
						if(m && m.Dead)
							m.Poisoned = FALSE
							return TRUE
						sleep 1
					if(m) m.Poisoned = FALSE
			Poison_1
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Poison
				min_strength = 0.1
				max_strength = 0.3
			Poison_2
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Poison
				min_strength = 0.5
				max_strength = 1
			Poison_3
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Poison
				min_strength = 1
				max_strength = 2

/*
			Defense_Buff
				icon_state = "Stone"
				var strength
				var duration = 300
				activate(mob/m)
					m.DefenseBuff += strength
					spawn(duration)
						if(m)
							m.DefenseBuff -= strength

			Stoneskin_1
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Defense_Buff
				strength = 20
			Stoneskin_2
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Defense_Buff
				strength = 30
			Stoneskin_3
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Defense_Buff
				strength = 50
			Silkskin_1
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Defense_Buff
				strength = -20
			Silkskin_2
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Defense_Buff
				strength = -30
			Silkskin_3
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Defense_Buff
				strength = -50
*/
			Strength_Buff
				icon_state = "Metal"
				var strength
				var duration = 300
				activate(mob/m)
					set waitfor = FALSE
					m.StrengthBuff += strength
					sleep duration
					if(m) m.StrengthBuff -= strength

			Strength_1
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Strength_Buff
				strength = 20
			Strength_2
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Strength_Buff
				strength = 30
			Strength_3
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Strength_Buff
				strength = 50

			Weak_1
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Strength_Buff
				strength = -20
			Weak_2
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Strength_Buff
				strength = -30
			Weak_3
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Strength_Buff
				strength = -50

			Waterwalk
				icon_state = "Wood"
				activate(mob/mortal/m)
					set waitfor = FALSE
					m.Waterwalk ++
					sleep 300
					if(m)
						m.Waterwalk --
						if(is_water(m.loc))
							if(locate(/obj/Built) in m.loc) return
							var turf/Environment/Water/w = m.loc
							if(istype(w) && w.is_frozen()) return
							m.die("drowning")

			Suffocation
				icon_state = "Wood"
				activate(mob/mortal/m)
					//	Suffocates them, draining stamina by 10 points every second for 30 seconds.
					m.aux_output("<b>You are suffocating!")
					for(var/n in 1 to 30)
						if(!m) return
						m.lose_stamina(10)
						sleep(10)

			Explosion
				icon_state = "Dirt"
				drinkable = FALSE
				var strength
			Explosion_1
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Explosion
				strength = 1
			Explosion_2
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Explosion
				strength = 2
			Explosion_3
				parent_type = /obj/Item/Alchemy/Bottle/Potion/Explosion
				strength = 3

	Element
		value = 36
		icon = 'code/Alchemy/Element.dmi'
		use(mob/player/m) if(loc == m)
			if(!m.is_equipped(/obj/Item/Tools/Spoon))
				m.aux_output("You need a spoon to mix this in with!")
				return

			var front[] = m.front()
			var obj/Built/Cauldron/c = locate() in front
			if(!c) return
			for(c in front)
				if(c.filled)
					break
			if(!c)
				m.aux_output("The cauldron isn't filled.")
				return
			m.emote("starts pouring a [src] element into the cauldron")
			m._do_work(30)
			m.emote("finishes mixing the element into the cauldron")
			m.used_tool()
			c.elements += "[name]s"
			del src

		Metal
			icon_state = "Metal"
		Hazium
			icon_state = "Hazium"
		Clay
			icon_state = "Clay"
		Stone
			icon_state = "Stone"
		Dirt
			icon_state = "Dirt"
		Sand
			icon_state = "Sand"
		Meat
			icon_state = "Meat"
		Plant
			icon_state = "Plant"
		Wood
			icon_state = "Wood"
