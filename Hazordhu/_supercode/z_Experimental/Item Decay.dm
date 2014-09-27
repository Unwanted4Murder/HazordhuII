/*

	Certain items disappear after a while when on the ground for too long.
	However, items won't disappear if they're on top of a built object (dirt, floors)
		and items won't disappear if they're inside something (players, chests)

*/

#if ITEM_DECAY
// #warn Item decay enabled.

decay_timer
	var life
	var obj/Item/item

	proc/go()
		set waitfor = FALSE
		sleep life
		if(check())
			item.complete_delete = TRUE
			del item

	proc/check()
		if(!item) del src
		if(src != item.decay_timer) del src
		return item.check_decay()

	New(item, life)
		src.item = item
		src.life = life
		go()

obj/Item
	//	so wild plants and growing crops don't decay
	Farming/plant/decays = FALSE

	var decay_time = HOUR
	var decays = TRUE
	var tmp/decay_timer/decay_timer

	proc/check_decay()
		var turf/c = cloc()
		if(decays && isturf(c) && !(locate(/obj/Built) in c))
			decay_timer = decay_timer || new (src, decay_time)
			return TRUE
		del decay_timer

	New()
		..()
		check_decay()

	map_loaded()
		..()
		check_decay()

	dropped_by()
		..()
		check_decay()
#endif