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

		statpanel("Carpentry")
		if(Orc)			stat(orc_carpentry)
		else if(Human)	stat(human_carpentry)

		statpanel("Carving")
		if(Orc)			stat(orc_carving)
		else if(Human)	stat(human_carving)

		statpanel("Farming")
		if(Orc)			stat(orc_farming)
		else if(Human)	stat(human_farming)

		statpanel("Forging")
		if(Orc)			stat(orc_forging)
		else if(Human)	stat(human_forging)

		statpanel("Hunting")
		if(Orc)			stat(orc_hunting)
		else if(Human)	stat(human_hunting)

		statpanel("Masonry")
		if(Orc)			stat(orc_masonry)
		else if(Human)	stat(human_masonry)

		statpanel("Smithing")
		if(Orc)			stat(orc_smithing)
		else if(Human)	stat(human_smithing)

		statpanel("Tailoring")
		if(Orc)			stat(orc_tailoring)
		else if(Human)	stat(human_tailoring)

		var range1 = range(1, src)
		var obj/Built
			Cauldron/C = locate() in range1
			Counter/Breakdown/B = locate() in range1
			Barrel/Barrel = locate()in range1
			Oven/O = locate() in range1
			Range/R = locate() in range1
			Counter/D = locate() in range1

		if(C || B)
			statpanel("Alchemy")
			if(C) stat(Alchemy_List)
			if(B) stat(Breakdown_List)

		if(locate(/obj/Built/Grinding_Stone) in range1)
			statpanel("Grinding")
			stat(Grinding_List)

		if(Barrel)
			statpanel("Brewing")
			stat(brewing)

		if(O)
			statpanel("Baking")
			if(Orc)			stat(orc_baking)
			else if(Human)	stat(human_baking)

		if(R)
			statpanel("Cooking")
			if(Orc)			stat(orc_cooking)
			else if(Human)	stat(human_cooking)

		if(D)
			statpanel("Food Prep")
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