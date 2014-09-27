#define SUB_PASSPORT "14c8723ec0a0f2cb"

//	Map Save macros
#define LOAD_FLAG	1
#define SAVE_FLAG	2
#define ALL_FLAG	3

//	Holiday preprocessor can be found in the Holidays folder

//	DIET macros
//	HERBIVORE diets are in the first nibble
#define FARM	1 // eats farm plants
#define SPORE	2 // eats spore plants (underground farms)
#define GRASS	4 // eats grass
#define PLANT	8 // eats plants (Tree's, Berry Bushes)

//	CARNIVORE diets are in the second nibble
#define MEAT	16// eats meat OBJECTS
#define CORPSE	32// eats bodies
#define EGG		64// eats eggs (both in nests, and on the ground)
#define FISH	128//eats fish from the water

//	time macros
#define SECOND	10
#define	MINUTE	600
#define	HOUR	36000
#define DAY		864000

#define TIME_ZONE -6

// layer macros
#define MOB_LAYER 15
#define OBJ_LAYER 10
#define TURF_LAYER 5
#define AREA_LAYER 0

#define ADMIN_TELE(m) "<a href=?action=admin_tele&dx=[m.x]&dy=[m.y]&dz=[m.z]>([m.x],[m.y],[m.z])</a>"

#define PI 3.14159265359

#define HUMAN	1
#define ORC		2

#define is_diagonal(d)  (d & (d - 1))
#define is_cardinal(d) !is_diagonal(d)
proc/ceil(n) return -round(-n)

#define PIXEL_MOVEMENT 1
#if PIXEL_MOVEMENT
/*
	To convert from "x1,y1 to x2,y2" to numbers:
		e.g.
			bounds = "1,1 to 32,32"
			=>
				bound_x = 0
				bound_y = 0
				bound_width = 32
				bound_height = 32
		bound_x = x1 - 1
		bound_y = y1 - 1
		bound_width = x2 - x1 + 1
		bound_height = y2 - y1 + 1

	To convert from bound_numbers to text:
		e.g.
			bound_x = 0
			bound_y = 0
			bound_width = 32
			bound_height = 32
			=> bounds = "1,1 to 32,32"
		"[bound_x + 1],[bound_y + 1] to [bound_x + bound_width],[bound_y + bound_height]"
*/
	#define SET_BOUNDS(bx, by, bw, bh) bound_x = bx; bound_y = by; bound_width = bw; bound_height = bh
	#define SET_TBOUNDS(t) bounds = t
	#define SET_STEP_SIZE(n) step_size = n
#else
atom/movable/animate_movement = SLIDE_STEPS
	#define SET_BOUNDS(a, b, c, d)
	#define SET_TBOUNDS(t)
	#define SET_STEP_SIZE(n)
#endif

client/proc/set_keys()