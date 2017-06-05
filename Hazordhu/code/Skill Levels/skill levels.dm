var const
	WOODCUTTING	=	"Woodcutting"
	MINING		=	"Mining"
	FARMING		=	"Farming"
	HUNTING		=	"Hunting"
	CARVING		=	"Carving"
	CARPENTRY	=	"Carpentry"
	MASONRY		=	"Masonry"
	FORGING		=	"Forging"
	SMITHING	=	"Smithing"
	TAILORING	=	"Tailoring"
	ALCHEMY		=	"Alchemy"
	COOKING		=	"Cooking"
	FISHING   = "Fishing"

mob/player
	var skill_levels[]

	PostLogin()
		..()
		if(!skill_levels)
			skill_levels = new

		for(var/skill in typesof(/skill_level) - /skill_level)
			if(!get_skill(skill))
				skill_levels += new skill (src)

		for(var/skill_level/skill in skill_levels)
			skill.owner = src
		
		display_skills()

	proc/get_skill(name)
		if(!name) return

		if(istype(name, /skill_level))
			if(name in skill_levels)
				return name
			var skill_level/skill = name
			return locate(skill.type) in skill_levels

		if(ispath(name))
			return locate(name) in skill_levels

		if(istext(name))
			for(var/skill_level/skill in skill_levels)
				if(cmptext(skill.name, name))
					return skill

	proc/gain_experience(skill, amount)
		if(amount <= 0) return
		var skill_level/s = get_skill(skill)
		if(!s) return
		s.gain_experience(amount)

	proc/skill_level(skill)
		var skill_level/s = get_skill(skill)
		if(!s) return
		return s.level

	proc/display_skills()
		var n = 0
		for(var/skill_level/skill in skill_levels)
			n ++
			src << output(skill.name, "skill_level_grid:1,[n]")
			src << output("[skill.level || 0] ([skill.percent * 100 || 0]%)", "skill_level_grid:2,[n]")
		winset(src, "skill_level_grid", "cells=2x[n]")

	proc/display_skill(skill_level/skill)
		var n = skill_levels.Find(skill)
		src << output(skill.name, "skill_level_grid:1,[n]")
		src << output("[skill.level || 0] ([skill.percent * 100 || 0]%)", "skill_level_grid:2,[n]")

	// #if !THIN_SKIN
	// Stat()
	// 	..()
	// 	display_skills()
	// #endif

skill_level
	var name = ""
	var level = 0
	var experience = 0
	var max_experience = 10
	var tmp/mob/player/owner
	var percent

	New(mob/player/owner)
		src.owner = owner

	proc/get_max_experience(level)
		return level * 10

	proc/level_up(n = 1)
		if(n <= 0) return
		level += n
		owner << "Leveled up[n > 1 ? " ([n] times)" : ""]: [name] ([level])"
		owner.display_skill(src)

	proc/gain_experience(n = 1)
		experience += n
		var levels = 0
		while(experience >= max_experience)
			experience -= max_experience
			levels ++
			max_experience = get_max_experience(level + levels)
		percent = experience / max_experience
		if(levels)
			level_up(levels)
		else
			owner.display_skill(src)

	//	affect an object based on level, e.g. better quality items
	proc/apply(obj/o)

	proc/time_bonus()
		return level * 5

	woodcutting
		name = "Woodcutting"

		//	return a list of extra logs based on level
		proc/log_bonus()
			. = list()
			for(var/n in 1 to round(level / 5))
				if(prob(10))
					. += new /obj/Item/Wood/Log

	mining
		name = "Mining"

		//	extra ore
		proc/mine_bonus(ore)
			. = list()
			for(var/n in 1 to round(level / 5))
				if(prob(10))
					. += new ore

	farming
		name = "Farming"
		proc/hunger_bonus()
			return level * 20

		//	better quality crops give more hunger
		apply(obj/Item/Farming/crop/crop)
			if(istype(crop))
				crop.Hunger += hunger_bonus()

	hunting
		name = "Hunting"

	carving
		name = "Carving"
		proc/durability_bonus()
			return level * 10

		apply(obj/Item/i)
			if(is_weapon(i) || is_shield(i) || is_tool(i))
				i.set_max_health(i.max_health + durability_bonus())

	carpentry
		name = "Carpentry"

		proc/built_bonus()
			return level * 50

		apply(obj/Built/b)
			if(istype(b))
				b.set_max_health(b.MaxHealth + built_bonus())

	masonry
		name = "Masonry"

		proc/built_bonus()
			return level * 50

		apply(obj/Built/b)
			if(istype(b))
				b.set_max_health(b.MaxHealth + built_bonus())

	forging
		name = "Forging"

	smithing
		name = "Smithing"
		proc/durability_bonus()
			return level * 10

		proc/built_bonus()
			return level * 50

		apply(obj/Item/i)
			if(is_weapon(i) || is_shield(i) || is_tool(i))
				i.set_max_health(i.max_health + durability_bonus())

			else if(istype(i, /obj/Built))
				var obj/Built/b = i
				b.set_max_health(b.MaxHealth + built_bonus())

	tailoring
		name = "Tailoring"

	alchemy
		name = "Alchemy"

	cooking
		name = "Cooking"

		proc/hunger_bonus()
			return level * 20

		apply(obj/Item/i)
			if("Hunger" in i.vars)
				i.vars["Hunger"] += hunger_bonus()
	
	fishing
		name = "Fishing"

		proc
			Duration() return max(0, 80 - level * 5)
			FishChance() return min(100, 40 + level * 5)
