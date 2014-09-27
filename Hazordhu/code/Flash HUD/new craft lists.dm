atom
	proc/craftables()
	proc/view_craftables(mob/player/p)
		var craftables[] = craftables()
		if(craftables)
			if(!p.crafting_tooltip)
				spawn
					if("No" == alert(p, "This is your first time crafting! Would you like some help?", "Crafting", "Yes", "No"))
						alert(p, "Fine, then.", "Crafting")
					else alert(p,
							"Just click and drag something and you'll see a grid around you. \
							Drop the thing onto one of those grids to start making it. \n\
							Of course, you need to make sure you have the right items first!",
							"Crafting", "Got it")
				p.crafting_tooltip = TRUE
			p.craftables_source = src
			p.fill_crafting_grid(craftables)
			p.crafting_button.expand()
			return TRUE

mob/player
	var tmp/atom/craftables_source
	var crafting_tooltip
	move_tick()
		..()
		if(craftables_source)
			if(!(craftables_source in src) && bounds_dist(src, craftables_source) > 16)
				clear_crafting_grid()
				craftables_source = null

obj
	Item/Tools
		Knife/craftables() return carving
		Hatchet/craftables() return hatchet_list
		Hammer/craftables() return carpentry + hammering
		Shovel/craftables() return shoveling + farming
		NeedleThread/craftables() return tailoring + hunting
		Trowel/craftables() return masonry
		Chisel/craftables() return chiseling

		use(mob/player/p)
			view_craftables(p)
			..()

		equipped_by(mob/player/p)
			view_craftables(p)
			..()

		unequipped_by(mob/player/p)
			p.clear_crafting_grid(p)

	Built
		interact(mob/player/p)
			if(!view_craftables(p))
				..()

		Forge/craftables() return forging
		Anvil/craftables() return smithing
		Barrel/craftables() return brewing
		Counter
			craftables() return food_prep
			Breakdown/craftables() return breakdown
		Cauldron/craftables() return alchemy
		Oven/craftables() return baking
		Range/craftables() return global.cooking