builder/hunting
	main_tool = /obj/Item/Tools/NeedleThread
	skill = HUNTING
	allowed_in_tutorial = TRUE

	book
		name = "Book"
		icon = 'code/Hunting/book.dmi'

		desc = "Knowledge is power!  Share yours!<br />\
				3 Threads<br />\
				2 Leathers"
		tooltipRows = 4

		req = list(	THREAD	=	3,
					LEATHER	=	2)
		built = /obj/Item/Book

	canteen
		name = "Canteen"
		icon = 'code/Hunting/Canteen.dmi'

		desc = "Used for holding more water than unusual<br />\
				1 Thread<br />\
				3 Leathers"
		tooltipRows = 3

		req = list(	THREAD	=	1,
					LEATHER	=	3)
		built = /obj/Item/Canteen

	loincloth_top
		name = "Loincloth Top"
		icon = 'code/Hunting/Top.dmi'

		desc = "Primitive clothing for a woman's chest<br />\
				1 Fur"
		tooltipRows = 2

		req = list(	FUR		=	1)
		built = /obj/Item/Clothing/Shirt/Loincloth_Top

	loincloth
		name = "Loincloth"
		icon = 'code/Hunting/Loin Cloths.dmi'

		desc = "Primitive clothing for the legs<br />\
				1 Fur"
		tooltipRows = 2

		req = list(	FUR		=	1)
		built = /obj/Item/Clothing/Pants/Loincloth

	grawl_loincloth
		name = "Grawl Loincloth"
		icon = 'code/Hunting/Grawl Loincloth.dmi'

		desc = "Primitive grawl clothing for the legs<br />\
				1 Fur"
		allowed_races = ORC
		tooltipRows = 2

		req = list(	GFUR		=	1)
		built = /obj/Item/Clothing/Pants/Grawl_Loincloth

	ngrawl_loincloth
		name = "North Grawl Loincloth"
		icon = 'code/Hunting/NGrawl Loincloth.dmi'

		desc = "Primitive clothing for the cold legs<br />\
				1 Fur"
		allowed_races = ORC
		tooltipRows = 2

		req = list(	NGFUR		=	1)
		built = /obj/Item/Clothing/Pants/North_Grawl_Loincloth

	fur_coat
		name = "Fur Coat"
		icon = 'code/Hunting/Fur Coat.dmi'

		desc = "A very warm fur coat<br />\
				3 Furs"
		tooltipRows = 2

		req = list(	FUR		=	3)
		built = /obj/Item/Clothing/Shirt/Fur_Coat

	fur_pants
		name = "Fur Pants"
		icon = 'code/Hunting/Fur Trousers.dmi'

		desc = "A very warm pair of fur pants<br />\
				3 Furs"
		tooltipRows = 2

		req = list(	FUR		=	3)
		built = /obj/Item/Clothing/Pants/Fur_Pants

	fur_boots
		name = "Fur Boots"
		icon = 'code/Hunting/Fur Boots.dmi'

		desc = "A very warm pair of fur boots<br />\
				2 Furs"
		tooltipRows = 2

		req = list(	FUR		=	2)
		built = /obj/Item/Clothing/Feet/Fur_Boots

	mittens
		name = "Mittens"
		icon = 'code/Hunting/Mittens.dmi'

		desc = "A very warm pair of fur mittens<br />\
				2 Furs"
		tooltipRows = 2

		req = list(	FUR		=	2)
		built = /obj/Item/Clothing/Hands/Mittens

	fur_cape
		name = "Fur Cape"
		icon = 'code/Hunting/Fur Cape.dmi'

		desc = "A very warm fur cape<br />\
				3 Furs"
		tooltipRows = 2

		req = list(	FUR		=	3)
		built = /obj/Item/Clothing/Back/Fur_Cape

	grawl_coat
		name = "Grawl Coat"
		icon = 'code/Hunting/Grawl Shirt.dmi'

		desc = "A very fuzzy fur coat<br />\
				3 Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	GFUR		=	3)
		built = /obj/Item/Clothing/Shirt/Grawl_Shirt

	grawl_pants
		name = "Grawl Pants"
		icon = 'code/Hunting/Grawl Pants.dmi'

		desc = "A very fuzzy pair of fur pants<br />\
				3 Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	GFUR		=	3)
		built = /obj/Item/Clothing/Pants/Grawl_Pants

	grawl_boots
		name = "Grawl Boots"
		icon = 'code/Hunting/Grawl Shoes.dmi'

		desc = "A very fuzzy pair of fur boots<br />\
				2 Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	GFUR		=	2)
		built = /obj/Item/Clothing/Feet/Grawl_Boots

	grawl_mittens
		name = "Grawl Mittens"
		icon = 'code/Hunting/Grawl gloves.dmi'

		desc = "A very fuzzy pair of fur mittens<br />\
				2 Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	GFUR		=	2)
		built = /obj/Item/Clothing/Hands/Grawl_Gloves

	grawl_cape
		name = "Grawl Cape"
		icon = 'code/Hunting/Grawl Cape.dmi'

		desc = "A very fuzzy fur cape<br />\
				3 Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	GFUR		=	3)
		built = /obj/Item/Clothing/Back/Grawl_Cape

	grawl_mask
		name = "Grawl Mask"
		icon = 'code/Hunting/Grawl Mask.dmi'

		desc = "A fiercely fuzzy mask<br />\
				5 Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	GFUR		=	5)
		built = /obj/Item/Clothing/Helmet/Grawl_Mask

	grawl_hood
		name = "Grawl Hood"
		icon = 'code/Hunting/Grawl Hood.dmi'

		desc = "Look at the perky ears!<br />\
				3 Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	GFUR		=	3)
		built = /obj/Item/Clothing/Hood/Grawl_Hood

	ngrawl_coat
		name = "North Grawl Coat"
		icon = 'code/Hunting/NGrawl Shirt.dmi'

		desc = "A very fuzzy fur coat<br />\
				3 North Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	NGFUR		=	3)
		built = /obj/Item/Clothing/Shirt/North_Grawl_Shirt

	ngrawl_pants
		name = "North Grawl Pants"
		icon = 'code/Hunting/NGrawl Pants.dmi'

		desc = "A very fuzzy pair of fur pants<br />\
				3 North Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	NGFUR		=	3)
		built = /obj/Item/Clothing/Pants/North_Grawl_Pants

	ngrawl_boots
		name = "North Grawl Boots"
		icon = 'code/Hunting/NGrawl Shoes.dmi'

		desc = "A very fuzzy pair of fur boots<br />\
				2 North Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	NGFUR		=	2)
		built = /obj/Item/Clothing/Feet/North_Grawl_Boots

	ngrawl_mittens
		name = "North Grawl Mittens"
		icon = 'code/Hunting/NGrawl Gloves.dmi'

		desc = "A very fuzzy pair of fur mittens<br />\
				2 North Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	NGFUR		=	2)
		built = /obj/Item/Clothing/Hands/North_Grawl_Gloves

	ngrawl_cape
		name = "North Grawl Cape"
		icon = 'code/Hunting/NGrawl Cape.dmi'

		desc = "A very fuzzy fur cape<br />\
				3 North Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	NGFUR		=	3)
		built = /obj/Item/Clothing/Back/North_Grawl_Cape

	ngrawl_mask
		name = "North Grawl Mask"
		icon = 'code/Hunting/NGrawl Mask.dmi'

		desc = "A fiercely fuzzy mask<br />\
				5 North Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	NGFUR		=	5)
		built = /obj/Item/Clothing/Helmet/North_Grawl_Mask

	ngrawl_hood
		name = "North Grawl Hood"
		icon = 'code/Hunting/NGrawl Hood.dmi'

		desc = "Look at the perky ears!<br />\
				3 North Grawl Furs"
		tooltipRows = 2
		allowed_races = ORC

		req = list(	NGFUR		=	3)
		built = /obj/Item/Clothing/Hood/North_Grawl_Hood

	leather_hood
		name = "Leather Hood"
		icon = 'code/Hunting/Leather Hood.dmi'

		desc = "A warm leather hood<br />\
				1 Thread<br />\
				2 Leathers"
		tooltipRows = 3

		req = list(	THREAD	=	1,
					LEATHER	=	2)
		built = /obj/Item/Clothing/Hood/Leather_Hood

	leather_mask
		name = "Leather Mask"
		icon = 'code/Hunting/leatherhelmet.dmi'

		desc = "A must-have for the woodsman<br />\
				2 Thread<br />\
				2 Leathers"
		tooltipRows = 3

		req = list(	THREAD	=	2,
					LEATHER	=	2)
		built = /obj/Item/Clothing/Helmet/Leather_Mask

	leather_gloves
		name = "Leather Gloves"
		icon = 'code/Hunting/Leather Gloves.dmi'

		desc = "A warm pair of leather gloves<br />\
				1 Thread<br />\
				1 Leather"
		tooltipRows = 3

		req = list(	THREAD	=	1,
					LEATHER	=	1)
		built = /obj/Item/Clothing/Hands/Leather_Gloves

	leather_pants
		name = "Leather Pants"
		icon = 'code/Hunting/Leather_Pants.dmi'

		desc = "A warm pair of leather pants<br />\
				1 Thread<br />\
				2 Leathers"
		tooltipRows = 3

		req = list(	THREAD	=	1,
					LEATHER	=	2)
		built = /obj/Item/Clothing/Pants/Leather_Pants

	leather_shirt
		name = "Leather Shirt"
		icon = 'code/Hunting/Leather_Shirt.dmi'

		desc = "A warm leather shirt<br />\
				1 Thread<br />\
				3 Leathers"
		tooltipRows = 3

		req = list(	THREAD	=	1,
					LEATHER	=	3)
		built = /obj/Item/Clothing/Shirt/Leather_Shirt

	leather_shoes
		name = "Leather Shoes"
		icon = 'code/Hunting/Leather_Shoes.dmi'

		desc = "A warm pair of leather shoes<br />\
				1 Thread<br />\
				1 Leather"
		tooltipRows = 3

		req = list(	THREAD	=	1,
					LEATHER	=	1)
		built = /obj/Item/Clothing/Feet/Leather_Shoes

	flargl_leather_hood
		name = "Flargl Leather Hood"
		icon = 'code/Hunting/flargl Hood.dmi'

		desc = "Made from the skin of the most feared<br />\
				creature ever known<br />\
				1 Thread<br />\
				2 Flargl Leathers"
		tooltipRows = 4
		allowed_races = ORC

		req = list(	THREAD	=	1,
					FLEATH	=	2)
		built = /obj/Item/Clothing/Hood/Flargl_Leather_Hood

	flargl_leather_gloves
		name = "Flargl Leather Gloves"
		icon = 'code/Hunting/flargl Gloves.dmi'

		desc = "Made from the skin of the most feared<br />\
				creature ever known<br />\
				1 Thread<br />\
				1 Flargl Leather"
		tooltipRows = 4
		allowed_races = ORC

		req = list(	THREAD	=	1,
					FLEATH	=	1)
		built = /obj/Item/Clothing/Hands/Flargl_Leather_Gloves

	flargl_leather_pants
		name = "Flargl Leather Pants"
		icon = 'code/Hunting/flargl Pants.dmi'

		desc = "Made from the skin of the most feared<br />\
				creature ever known<br />\
				1 Thread<br />\
				2 Flargl Leathers"
		tooltipRows = 4
		allowed_races = ORC

		req = list(	THREAD	=	1,
					FLEATH	=	2)
		built = /obj/Item/Clothing/Pants/Flargl_Leather_Pants

	flargl_leather_shirt
		name = "Flargl Leather Shirt"
		icon = 'code/Hunting/flargl Shirt.dmi'

		desc = "Made from the skin of the most feared<br />\
				creature ever known<br />\
				1 Thread<br />\
				3 Flargl Leathers"
		tooltipRows = 4
		allowed_races = ORC

		req = list(	THREAD	=	1,
					FLEATH	=	3)
		built = /obj/Item/Clothing/Shirt/Flargl_Leather_Shirt

	flargl_leather_shoes
		name = "Flargl Leather Shoes"
		icon = 'code/Hunting/flargl Shoes.dmi'

		desc = "Made from the skin of the most feared<br />\
				creature ever known<br />\
				1 Thread<br />\
				1 Flargl Leather"
		tooltipRows = 4
		allowed_races = ORC

		req = list(	THREAD	=	1,
					FLEATH	=	1)
		built = /obj/Item/Clothing/Feet/Flargl_Leather_Shoes

	necro_helm
		name = "Necro Helm"
		icon = 'code/Hunting/necro helm.dmi'

		desc = "Fused with demonic energy<br />\
				10 Bones"
		tooltipRows = 2

		req = list(	BONES	=	10)
		built = /obj/Item/Armour/Helmet/Necro_Helm

	necro_shirt
		name = "Necro Shirt"
		icon = 'code/Hunting/necro shirt.dmi'

		desc = "Fused with demonic energy<br />\
				20 Bones"
		tooltipRows = 2

		req = list(	BONES	=	20)
		built = /obj/Item/Armour/Shirt/Necro_Shirt

	necro_greaves
		name = "Necro Greaves"
		icon = 'code/Hunting/necro legs.dmi'

		desc = "Fused with demonic energy<br />\
				15 Bones"
		tooltipRows = 2

		req = list(	BONES	=	15)
		built = /obj/Item/Armour/Pants/Necro_Greaves

	quiver
		name = "Quiver"
		icon = 'code/Hunting/quiver.dmi'

		desc = "An item to store all of your arrows in<br />\
				1 Thread<br />\
				3 Leathers"
		tooltipRows = 3

		req = list(	THREAD	=	1,
					LEATHER	=	3)
		built = /obj/Item/Clothing/Back/Quiver

	harness
		name = "Harness"
		icon = 'code/Hunting/Harness.dmi'
		icon_state = "item"

		desc = "Used to tame certain animals with<br />\
				2 Leathers<br />\
				2 Ropes"
		tooltipRows = 3

		req = list(	LEATHER	=	2,
					ROPE	=	2)
		built = /obj/Item/Tailoring/Harness

	collar
		name = "Collar"
		icon = 'code/Hunting/Collar.dmi'

		desc = "Used to tame man (or Orc)'s best friend!<br />\
				5 Leathers<br />\
				1 Metal Coin"
		tooltipRows = 3

		req = list(	LEATHER						=	5,
					/obj/Item/Metal/Metal_Coins	=	1)
		built = /obj/Item/Tailoring/Collar

	ball
		name = "Ball"
		icon = 'code/Icons/ball.dmi'

		desc = "A ball that you can kick and use for sports!<br />\
				2 Threads<br />\
				4 Leathers<br />\
				2 Stones<br />\
				2 Phlufs"
		tooltipRows = 5

		req = list(	THREAD	=	2,
					LEATHER	=	4,
					STONE	=	2,
					PHLUF	=	2)
		built = /obj/Item/Ball

		density = TRUE