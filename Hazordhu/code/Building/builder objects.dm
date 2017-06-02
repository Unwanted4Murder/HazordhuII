	/************************
	*						*
	*	Builder macros		*
	*	Defined under their	*
	*	most commonly used	*
	*	skill, but may be	*
	*	used outside their	*
	*	respective skills	*
	*						*
	************************/

//	Woodworking
	#define LOG		/obj/Item/Wood/Log
	#define BOARD	/obj/Item/Wood/Board
	#define NAIL	/obj/Item/Metal/Nails

//	Masonry
	#define BRICK	/obj/Item/Stone/Brick
	#define SSBRICK	/obj/Item/Stone/Sandstone_Brick
	#define TAR		/obj/Item/Stone/Tar
	#define DIRT	/obj/Item/Ores/Dirt
	#define STONE	/obj/Item/Ores/Stone
	#define SANDSTONE /obj/Item/Ores/Sandstone
	#define CLAY	/obj/Item/Ores/Clay

//	Tailoring
	#define THREAD	/obj/Item/Tailoring/Thread
	#define ROPE	/obj/Item/Tailoring/Rope
	#define PHLUF	/obj/Item/Farming/crop/Phluf

//	Hunting
	#define FUR		/obj/Item/Fur
	#define GFUR	/obj/Item/Grawl_Fur
	#define NGFUR	/obj/Item/North_Grawl_Fur
	#define LEATHER	/obj/Item/Leather
	#define OSKIN	/obj/Item/Skin/Orc_Skin
	#define HSKIN	/obj/Item/Skin/Human_Skin
	#define FSKIN	/obj/Item/Skin/Flargl_Skin
	#define TSKIN	/obj/Item/Skin/Troll_Skin
	#define FLEATH	/obj/Item/Leather/Flargl_Leather
	#define BONES	/obj/Item/Bone

//	Forging
	#define	MORE	/obj/Item/Ores/Metal
	#define	HORE	/obj/Item/Ores/Hazium
	#define	GLASS	/obj/Item/Ores/Glass
	#define	CHAZ	/obj/Item/Ores/Crystalized_Hazium

//	Smithing
	#define BAR		/obj/Item/Bars/Metal
	#define HBAR	/obj/Item/Bars/Hazium
	#define	POLE	/obj/Item/Metal/Pole
	#define CRYSTAL	/obj/Item/Hazium/Crystal
	#define SAND	/obj/Item/Ores/Sand
	#define COIN	/obj/Item/Metal/Metal_Coins
	#define HCOIN	/obj/Item/Metal/Coins

//	Farming
	#define SEED_HUFF			/obj/Item/Farming/seed/Huff
	#define SEED_KARET			/obj/Item/Farming/seed/Karet
	#define SEED_LETTIF			/obj/Item/Farming/seed/Lettif
	#define SEED_SHURGERCANE	/obj/Item/Farming/seed/Shurgercane
	#define SEED_KURN			/obj/Item/Farming/seed/Kurn
	#define SEED_PHLUF			/obj/Item/Farming/seed/Phluf
	#define SEED_PUTETA			/obj/Item/Farming/seed/Puteta
	#define SEED_TUMETA			/obj/Item/Farming/seed/Tumeta
	#define SEED_YEESE			/obj/Item/Farming/crop/Yeese
	#define SEED_MURSH			/obj/Item/Food/crop/Murshum

/*************************
*						 *
*	Builder definitions	 *
*						 *
*************************/

var skill_description_stylesheet = {"
<style type="text/css">
body {
	background: rgb(180, 160, 82);
	font-family: 'Tempus Sans ITC';
}

h3 {
	text-align: center;
}
</style>
"}

mob/player
	PostLogin()
		..()
		src << output(skill_description_stylesheet,
			"skill_description")

builder
	MouseEntered()
		usr << output(
{"
[skill_description_stylesheet]
<body>
	<h3>[name]</h3>
	<p>[desc]</p>
</body>
"}, "skill_description")
		..()

	New()
		if(group_only)
			overlays += image('code/Building/group_only.dmi', layer = 203)

		if(!built || !ispath(built))
			CRASH("Invalid built for [type].")
		..()