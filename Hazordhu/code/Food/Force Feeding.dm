mob
	var tmp/force_feed = FALSE

	proc/can_force_feed(mob/m) return m != src && ismob(m) && (m.KO || m.handcuffs()) && bounds_dist(src, m) <= 4

	can_drink() return force_feed || ..()

obj/Item/proc/force_feed(mob/victim, mob/feeder)
	feeder << "You force feed [feeder.nameShown(victim)] [src]."
	victim << "[victim.nameShown(feeder)] force feeds you [src]."

	victim.force_feed = TRUE
	Move(victim)	//	food needs to be inside the eater when trying to eat
	use(victim)		//	initiate eating!
	if(loc) Move(victim)
	victim.force_feed = FALSE

obj/Item/Food/MouseDrop(mob/m)
	if(usr.can_force_feed(m)) force_feed(m, usr)
	..()

obj/Item/Bucket/MouseDrop(mob/m)
	if(type != /obj/Item/Bucket && usr.can_force_feed(m)) force_feed(m, usr)
	..()

obj/Item/Bowl/Water/MouseDrop(mob/m)
	if(usr.can_force_feed(m)) force_feed(m, usr)
	..()

obj/Item/Canteen/Water/MouseDrop(mob/m)
	if(usr.can_force_feed(m)) force_feed(m, usr)
	..()

obj/Item/Alchemy/Bottle/MouseDrop(mob/m)
	if(type != /obj/Item/Alchemy/Bottle && usr.can_force_feed(m)) force_feed(m, usr)
	..()