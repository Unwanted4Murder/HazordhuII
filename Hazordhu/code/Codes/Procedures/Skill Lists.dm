
var tmp
	Grinding_List[]		= newtypesof(/obj/Grinding)
	Breakdown_List[]	= newtypesof(/obj/Alchemy/Breakdown)
	Alchemy_List[]		= newtypesof(/obj/Alchemy) | newtypesof(/obj/Alchemy/Breakdown)

proc/newtypes()
	. = list()
	for(var/list/X in args)
		for(var/Y in X)
			. += new Y

proc/newtypesof(parent, exclude = TRUE)
	. = list()
	var paths[] = typesof(parent)
	if(exclude) paths -= parent
	for(var/path in paths)
		. += new path

proc/alchemy_list()
	. = list()
	for(var/path in typesof(/obj/Alchemy) - typesof(/obj/Alchemy/Breakdown) - /obj/Alchemy)
		. += new path

proc/smithing_list()
	. = list()
	for(var/builder/smithing/s in newtypesof(/builder/smithing))
		if(s.needs_anvil)
			. += s

proc/hammering_list()
	. = list()
	for(var/builder/smithing/s in newtypesof(/builder/smithing))
		if(!s.needs_anvil)
			. += s

proc/shoveling_list()
	return newlist(
		/builder/masonry/path,
		/builder/masonry/sand_path
	)

proc/chiseling_list()
	return newlist(
		/builder/masonry/brick,
		/builder/masonry/sandstone_brick
	)

proc/no_tool_list()
	. = list()
	for(var/path in typesof(/builder))
		if(length(typesof(path)) == 1)
			var builder/b = path
			if(!initial(b.main_tool))
				. += new path

proc/hatchet_list()
	return newlist(
		/builder/carving/boards
	)

proc/carving_list()
	#if THIN_SKIN
	. = list()
	for(var/path in typesof(/builder))
		if(length(typesof(path)) == 1)
			var builder/b = path
			if(initial(b.main_tool) == /obj/Item/Tools/Knife)
				. += new path
	#else
	return newtypesof(/builder/carving)
	#endif

proc/masonry_list()
	#if THIN_SKIN
	. = list()
	for(var/path in typesof(/builder))
		if(length(typesof(path)) == 1)
			var builder/b = path
			if(initial(b.main_tool) == /obj/Item/Tools/Trowel)
				. += new path
	#else
	return newtypesof(/builder/masonry)
	#endif

var
	hatchet_list[] = hatchet_list()
	no_tool_list[] = no_tool_list()
	alchemy[]	= alchemy_list()
	breakdown[]	= newtypesof(/obj/Alchemy/Breakdown)
	carpentry[]	= newtypesof(/builder/carpentry)
	carving[]	= carving_list()
	farming[]	= newtypesof(/builder/farming)
	forging[]	= newtypesof(/builder/forging)
	hunting[]	= newtypesof(/builder/hunting)
	masonry[]	= masonry_list()
	smithing[]	= smithing_list()
	hammering[] = hammering_list()
	shoveling[] = shoveling_list()
	chiseling[] = chiseling_list()
	tailoring[]	= newtypesof(/builder/tailoring)
	brewing[]	= newtypesof(/builder/brewing)
	baking[]	= newtypesof(/builder/baking)
	cooking[]	= newtypesof(/builder/cooking)
	food_prep[]	= newtypesof(/builder/food_prep)

var
	orc_carpentry	[0]
	orc_carving		[0]
	orc_farming		[0]
	orc_forging		[0]
	orc_hunting		[0]
	orc_masonry		[0]
	orc_smithing	[0]
	orc_tailoring	[0]
	orc_brewing		[0]
	orc_baking		[0]
	orc_cooking		[0]
	orc_food_prep	[0]

	human_carpentry	[0]
	human_carving	[0]
	human_farming	[0]
	human_forging	[0]
	human_hunting	[0]
	human_masonry	[0]
	human_smithing	[0]
	human_tailoring	[0]
	human_brewing	[0]
	human_baking	[0]
	human_cooking	[0]
	human_food_prep	[0]

proc/load_crafting_lists()
	for(var/builder/b in carpentry)
		if(b.allowed_races & HUMAN)	human_carpentry	+=	b
		if(b.allowed_races & ORC)	orc_carpentry	+=	b

	for(var/builder/b in carving)
		if(b.allowed_races & HUMAN)	human_carving	+=	b
		if(b.allowed_races & ORC)	orc_carving		+=	b

	for(var/builder/b in farming)
		if(b.allowed_races & HUMAN)	human_farming	+=	b
		if(b.allowed_races & ORC)	orc_farming		+=	b

	for(var/builder/b in forging)
		if(b.allowed_races & HUMAN)	human_forging	+=	b
		if(b.allowed_races & ORC)	orc_forging		+=	b

	for(var/builder/b in hunting)
		if(b.allowed_races & HUMAN)	human_hunting	+=	b
		if(b.allowed_races & ORC)	orc_hunting		+=	b

	for(var/builder/b in masonry)
		if(b.allowed_races & HUMAN)	human_masonry	+=	b
		if(b.allowed_races & ORC)	orc_masonry		+=	b

	for(var/builder/b in hammering|smithing)
		if(b.allowed_races & HUMAN)	human_smithing	+=	b
		if(b.allowed_races & ORC)	orc_smithing	+=	b

	for(var/builder/b in tailoring)
		if(b.allowed_races & HUMAN) human_tailoring	+=	b
		if(b.allowed_races & ORC)	orc_tailoring	+=	b

	for(var/builder/b in brewing)
		if(b.allowed_races & HUMAN)	human_brewing	+=	b
		if(b.allowed_races & ORC)	orc_brewing		+=	b

	for(var/builder/b in baking)
		if(b.allowed_races & HUMAN)	human_baking	+=	b
		if(b.allowed_races & ORC)	orc_baking		+=	b

	for(var/builder/b in cooking)
		if(b.allowed_races & HUMAN)	human_cooking	+=	b
		if(b.allowed_races & ORC)	orc_cooking		+=	b

	for(var/builder/b in food_prep)
		if(b.allowed_races & HUMAN)	human_food_prep	+=	b
		if(b.allowed_races & ORC)	orc_food_prep	+=	b

world/New()
	load_crafting_lists()
	..()
