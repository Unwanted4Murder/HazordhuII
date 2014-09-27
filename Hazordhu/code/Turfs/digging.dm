turf
	proc/dig(mob/humanoid/digger)
	//	if(locate(/obj/Item) in src)	return
	//	if(locate(/obj/Built) in src)	return
		var item_name
		var item_path
		switch(name)
			if("Grass", "Dirt")
				item_name = "dirt"
				item_path = /obj/Item/Ores/Dirt
			if("Sand")
				item_name = "sand"
				item_path = /obj/Item/Ores/Sand
		if(!item_name || !item_path) return
		digger.emote("begins digging [item_name]")
		digger._do_work(30)
		digger.emote("digs up some [item_name]")
		for(var/n in 1 to 3)
			var obj/Item/item = new item_path
			item.move_to(digger.loc, digger.step_x, digger.step_y)
		return TRUE

	proc/forage(mob/humanoid/forager)
