proc/combat_result(mob/mortal/attacker, mob/mortal/defender)
	var combat/c = new (attacker, defender)
	return c.result

combat	// the combat datum.
	var
		result = 0

		mob/mortal
			attacker
			defender

		//	Attacker's attack power, defender's defense power
		att
		def

		obj/Item/Weapons
			attwep
			defshi

	proc/calcDmg() return max(1, att - def / 3)

	proc/calcBuiltDmg() return (att + (attwep && randn(attwep.Sharpness - 1, attwep.Sharpness + 1))) * randn(0.1, 1)

	New(mob/mortal/a, mob/mortal/d)
		if(a && d && a != d && d.Health > 0 && a.Health > 0 && !istype(d, /mob/Corpse))
			attacker = a
			att = attacker.Attack()
			if(is_humanoid(a))
				var mob/humanoid/h = a
				attwep = h.is_weapon_equipped()

			if(ismob(d))
				defender = d
				def = max(1, d.Defense() + d.DefenseBuff)
				if(is_humanoid(d))
					var mob/humanoid/h = d
					defshi = h.is_shield_equipped()
				result = calcDmg()

				if(is_humanoid(d))
					var mob/humanoid/h = d
					if(h.is_blocking(a))
						if(defshi)
							if(prob(50))
								result = "block"
							else result /= 2
							h.used_shield()

						else if(h.is_weapon_equipped() && prob(75))
							result = "parry"
							h.used_weapon()

			else if(istype(d, /obj/Built) || istype(d, /obj/Nest) || istype(d, /obj/Flag))
				result = calcBuiltDmg(d)

mob/humanoid
	proc/is_blocking(mob/attacker)
		if(istype(attacker, /mob/Animal/Flargl)) return FALSE
		return blocking && abs(angle_difference(is_player(src) ? client.mouse.angle : dir2angle(dir), angle_to(src, attacker))) < 45

proc
	is_shield(obj/Item/Weapons/i) return istype(i) && i.Type == "Defense" && i
	is_weapon(obj/Item/Weapons/i) return istype(i) && i.Type != "Defense" && i
	is_tool(obj/Item/Tools/i) return istype(i)

mob/proc
	is_weapon_equipped() return is_weapon(equipment["main"])
	is_shield_equipped() return is_shield(equipment["off" ])

	Weapon() return is_weapon_equipped()

	Shield() return is_shield_equipped()

	Attack()
		var obj/Item/Weapons/weapon = Weapon()
		return max(1, max(0, Strength + StrengthBuff) + max(0, weapon && weapon.Sharpness / 5))

	Defense()
		. = Defense + DefenseBuff
		var Equipment[] = Equipment()
		for(var/obj/Item/Weapons/shield in Equipment) . += shield.Defense
		for(var/obj/Item/Armour/armor in Equipment) . += armor.Defense
