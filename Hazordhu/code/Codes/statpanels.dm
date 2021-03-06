//var looper/stat_loop = new ("updateStats", 1)

mob
	proc/item_paths()
		. = list()
		for(var/obj/Item/item in src)
			.[item.type] += item.Stacked

mob/player
#if !THIN_SKIN
	Stat() if(key && Made)
		var Orc = Race == "Orc"
		var Human = Race == "Human"

		if(statpanel("Carpentry"))
			if(Orc)			stat(orc_carpentry)
			else if(Human)	stat(human_carpentry)

		if(statpanel("Carving"))
			if(Orc)			stat(orc_carving)
			else if(Human)	stat(human_carving)

		if(statpanel("Farming"))
			if(Orc)			stat(orc_farming)
			else if(Human)	stat(human_farming)

		if(statpanel("Forging"))
			stat("Forge required")
			if(Orc)			stat(orc_forging)
			else if(Human)	stat(human_forging)

		if(statpanel("Hunting"))
			if(Orc)			stat(orc_hunting)
			else if(Human)	stat(human_hunting)

		if(statpanel("Masonry"))
			if(Orc)			stat(orc_masonry)
			else if(Human)	stat(human_masonry)

		if(statpanel("Smithing"))
			if(Orc)			stat(orc_smithing)
			else if(Human)	stat(human_smithing)

		if(statpanel("Tailoring"))
			if(Orc)			stat(orc_tailoring)
			else if(Human)	stat(human_tailoring)

		if(statpanel("Alchemy"))
			stat("Cauldron required")
			stat(alchemy)
			stat("Breakdown Counter required")
			stat(breakdown)

		if(statpanel("Grinding"))
			stat("Spinning Grinding Stone required")
			stat(Grinding_List)

		if(statpanel("Brewing"))
			stat("Barrel required")
			stat(brewing)

		if(statpanel("Baking"))
			stat("Oven required")
			if(Orc)			stat(orc_baking)
			else if(Human)	stat(human_baking)

		if(statpanel("Cooking"))
			stat("Cooking Range required")
			if(Orc)			stat(orc_cooking)
			else if(Human)	stat(human_cooking)

		if(statpanel("Food Prep"))
			stat("Counter required")
			if(Orc)			stat(orc_food_prep)
			else if(Human)	stat(human_food_prep)

		..()

#endif
/*
	var tmp
		preHealth
		preMaxHealth

		preStamina
		preMaxStamina

		preThirst
		preHunger

		preBlood

	proc/updateStats()
		var params[0]

		if(preHealth != Health || preMaxHealth != MaxHealth)
			preHealth = Health
			preMaxHealth = MaxHealth
			params["health_bar.value"] = round(Health / MaxHealth * 100)

		if(preStamina != Stamina || preMaxStamina != MaxStamina)
			preStamina = Stamina
			preMaxStamina = MaxStamina
			params["stamina_bar.value"] = round(Stamina / MaxStamina * 100)

		if(preThirst != Thirst)
			preThirst = Thirst
			params["thirst_bar.value"] = round(Thirst)

		if(preHunger != Hunger)
			preHunger = Hunger
			params["hunger_bar.value"] = round(Hunger)

		if(preBlood != Blood)
			preBlood = Blood
			params["blood_bar.value"] = round(Blood)

		if(params.len)
			winset(src, null, list2params(params))
*/