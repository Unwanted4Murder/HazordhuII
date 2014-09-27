obj/Item
	parent_type = /item

	Stack_Check(n)
		if(n) lose_amount(n)
		stack_check()

	set_amount()
		. = ..()
		if(.)
			overlays = amount > 1 ? list(num2overlay(amount)) : null
			Stacked = amount
			if(ismob(loc))
				var mob/m = loc
				m.InventoryGrid()

	dropped_by(mob/m)
	grabbed_by(mob/m)

	proc/drop(mob/m, amount = 1)
		var item/i = split_item(amount, m.loc)
		i.step_x = m.step_x
		i.step_y = m.step_y
		dropped_by(m)

	proc/grab(mob/m, amount = 1)
		return split_item(amount, m)

	Drop(mob/m) return drop(m)
	DropAll(mob/m) return drop(m, 10)
	DropInFront(mob/m)
		var obj/Item/i = drop(m, 1)
		var offset[] = vec2_scale(dir2offset(m.dir), 16)
		i.step_x = m.step_x + offset[1]
		i.step_y = m.step_y + offset[2]
		i.surface_check(m.dir)

	Get(mob/m) return grab(m)
	GetAll(mob/m) return grab(m, 10)

	interact(mob/m)
		if(loc == m)
			if(m.is_equipped(src))
				m.unequip(src)
			else
				if(m.has_key("ctrl"))
					DropAll(m)
				else if(m.has_key("shift"))
					DropInFront(m)
				else Drop(m)
		else
			if(m.has_key("ctrl"))
				GetAll(m)
			else Get(m)

item
	parent_type = /obj

	//	does the item stack at all?
	var stackable = TRUE
	var amount = 1

	New(new_loc, new_amount = 1)
		..()
		set_amount(new_amount)
		stack_check()

	Move()
		. = ..()
		stack_check()

	//	Checks the surrounding area or container
	//	for items to merge with
	proc/stack_check()
		if(!stackable) return
		var around[] = isturf(loc) ? obounds() : loc
		for(var/item/i in around)
			if(stacks_with(i))
				add_item(i)

	//	Returns whether this item stacks with another item
	proc/stacks_with(item/i)
		return src != i && stackable && i.stackable && type == i.type

	//	Adds an entire item stack to this one
	//	Destroys the other item stack
	//	Returns TRUE on success
	proc/add_item(item/i)
		if(!stacks_with(i)) return FALSE
		gain_amount(i.amount)
		i.set_amount(0)
		return TRUE

	//	n = initial amount in new stack
	//	new_loc = initial loc of the new stack
	//	Returns a new item
	proc/split_item(n, new_loc)
		n = min(n, amount)
		if(new_loc)
			var item/new_stack
			for(new_stack in new_loc)
				if(stacks_with(new_stack))
					break
			if(new_stack)
				new_stack.gain_amount(n)
				. = new_stack
			else . = new type (new_loc, n)
		lose_amount(n)

	proc/set_amount(new_amount)
		. = TRUE
		amount = max(new_amount, 0)
		if(!amount)
			loc = null

	proc/gain_amount(n = 1) return set_amount(amount + n)
	proc/lose_amount(n = 1) return set_amount(amount - n)