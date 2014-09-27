mob
	proc/InventoryGrid()
	proc/StorageGrid()

var num_overlays[0]

obj/Item
	bound_x = 8
	bound_y = 8
	bounds = "16,16"

	var Stacked = 1
	var weight = 1
	var complete_delete
	var Stackable = 1
	var fingerprints[]
	var can_get = TRUE

	proc
		store_item(mob/m, amount)
		unstore_item(mob/m, amount)
		grabbed_by(mob/m)
		dropped_by(mob/m)
		surface_check(dir = 2)
		DropInFront(mob/m)
		GetAll(mob/m)
		DropAll(mob/m, ignorebulk)
		Drop(mob/m, location)
		Get(mob/humanoid/m)
		Stack_Check(remove = 0)
		num2overlay(n = 0)