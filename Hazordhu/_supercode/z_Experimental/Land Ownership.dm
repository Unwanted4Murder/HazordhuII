/*
Jesse Woodland:
	We should add property deeds.
	I know it takes from the realism.

	Everybody gets one. They get it when they complete the tutorial.

	Plop it down. Like totems.

	And add permissions.
	We could also.
	Add regions for groups to control.
	The group members of high enough rank can evict people.

	You think that faction thing would be a good idea?
	Tie it in to property deeds. Factions can set their regions to allow or disallow people to build in them without a signed deed or something
*/

//	A global list of PropertyDeeds in the world because why not.
var deeds[0]

var const/DEED_SAVE = "Data/Map/deeds.sav"
proc/load_deeds()
	if(!fexists(DEED_SAVE)) return
	var savefile/s = new (DEED_SAVE)
	s >> deeds
	if(!deeds) deeds = new

proc/save_deeds()
	if(fexists(DEED_SAVE)) fdel(DEED_SAVE)
	if(!(deeds || deeds.len)) return
	var savefile/s = new (DEED_SAVE)
	s << deeds

PropertyDeed
	New()
		if(!deeds) deeds = list(src)
		else deeds |= src

	//	Contains all the turfs belonging to this property.
	var region[0]

	//	Convert between save-able and non-save-able formats
	proc/tile2coords(turf/t) return list(t.x, t.y, t.z)
	proc/coords2tile(c[]) return locate(c[1], c[2], c[3])

	proc/add_tile(turf/t)
		region |= t
		if(!t.deeds) t.deeds = list(src)
		else t.deeds |= src
		return TRUE

	proc/remove_tile(turf/t)
		region -= t
		t.deeds -= src
		return TRUE

	proc/add_tiles(tiles[]) for(var/turf/t in tiles) add_tile(t)
	proc/remove_tiles(tiles[]) for(var/turf/t in tiles) remove_tile(t)

	proc/has_tile(turf/t) return t in region

	//	When this datum is saved in a savefile,
	// the region list is converted into coordinates.
	Write()
		for(var/n in 1 to region.len) region[n] = tile2coords(region[n])
		..()

	//	When this datum is loaded from a savefile,
	// the region list is converted to turfs.
	Read()
		..()
		if(!deeds) deeds = list(src)
		else deeds  |= src
		for(var/n in 1 to region.len) region[n] = coords2tile(region[n])
		add_tiles(region)

	//	Contains charIDs associated to a list of permissions
	var permissions[0]

	//	Returns TRUE if m has the permission after giving it
	proc/add_permission(mob/player/m, permission)
		if(!permissions[m.charID])
			permissions[m.charID] = list(permission)
			return TRUE
		else if(permission in permissions[m.charID]) return TRUE
		permissions[m.charID] |= permission
		return TRUE

	//	Returns TRUE if m does not have the permission after taking it
	proc/remove_permission(mob/player/m, permission)
		if(!permissions[m.charID]) return TRUE
		if(!(permission in permissions[m.charID])) return TRUE
		permissions[m.charID] -= permission
		return TRUE

	//	Returns TRUE if m has the permission
	proc/has_permission(mob/player/m, permission)
		if(!permissions[m.charID]) return FALSE
		return permission in permissions[m.charID]

	//	Permission addition
	proc/add_owner			(mob/player/m)	return add_permission		(m, "owner")
	proc/add_builder		(mob/player/m)	return add_permission		(m, "build")
	proc/add_destroyer		(mob/player/m)	return add_permission		(m, "destroy")

	//	Permission removal
	proc/remove_owner		(mob/player/m)	return remove_permission	(m, "owner")
	proc/remove_builder		(mob/player/m)	return remove_permission	(m, "build")
	proc/remove_destroyer	(mob/player/m)	return remove_permission	(m, "destroy")

	//	Permission check
	proc/is_owner			(mob/player/m)	return has_permission		(m, "owner")
	proc/can_build			(mob/player/m)	return has_permission		(m, "build")
	proc/can_destroy		(mob/player/m)	return has_permission		(m, "destroy")

//	turfs can know what deed(s) they belong to
turf
	var deeds[]

//	returns TRUE if src can attack args[1]
// mob/is_attackable(obj/Built/b)

//	This returns TRUE if p can build on t
// builder/valid_loc(turf/t, mob/player/p)