var
	CurrentZombies = 0
	MaxZombies = 40

mob

	var
		zombie_infection = 0
		infection_leader
		tmp
			infection_damage = 0

	proc/ZombieInfected()
		if(infection_damage) return
		infection_damage = TRUE

		while(zombie_infection > 0)
			new /obj/Blood/Zombie (loc)

			zombie_infection -= 0.1
			take_damage(1, "a serious infection")
			sleep 30

		zombie_infection = 0
		infection_damage = FALSE

	NPC
		Zombie
			name = "undead"
			icon = 'code/Mobs/zombie.dmi'
			strength = 15
			Race = "Zombie"
			MeatType = null
			SkinType = null
			defense = 1
			MaxHealth = 100
			friendly_types = list(/mob/NPC/Undead/Archer,/mob/NPC/Undead/Skeleton,/mob/NPC/Undead/Skeleton_War,/mob/NPC/Undead/Soul,/mob/NPC/Zombie,/mob/NPC/Zombie/Archer,/mob/NPC/Zombie/Enforcer, /mob/NPC/Undead/Shadow)
			Health = 100
			new_ai = 1
			attack_delay = 10
			ranged_attack = 0
			follow_blood = 1
			opens_doors = FALSE

			Archer
				ranged_attack = 5

			Enforcer
				strength = 30
				defense = 1
				MaxHealth = 400
				Health =  400

			attack_target()
				. = ..()
				if(. && target.type != type)
					if(prob(25))
						target.zombie_infection += randn(1, 10)

					target.infection_leader = leader
					spawn(1)
						if(target)
							target.ZombieInfected()

			New()
				..()
				CurrentZombies++
				clothe()

			Del()
				CurrentZombies--
				..()

			killed_target()
				if(target.zombie_infection)
					target.zombify()
				target = null

mob
	Admin
		verb
			ClearZombies()
				for(var/mob/NPC/Zombie/z)
					del z

			Max_Zombies(n as num)
				MaxZombies = n

			CheckZombies()
				usr << "Zombies in world: [CurrentZombies]"
				usr << "Max zombies: [MaxZombies]"

			GotoZombie()
				var mob/NPC/Zombie/Z = locate() in world
				if(Z) set_loc(Z.loc)
				else usr << "There are no zombies in the world."

