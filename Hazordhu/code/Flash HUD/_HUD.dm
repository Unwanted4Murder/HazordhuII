/*

	Here begins the attempt to make Hazordhu Flash-compatible.

	Known Requirements of Flash:
		Interface with only a map and an output (maybe an input too)
		alert() and input() work (maybe even customizable)

	HUD requirements for Hazordhu:
		Health, Stamina, Hunger, Thirst bars (skipping blood and heat for now)
		Object list for Inventory, Storage, Crafting lists.
		Equipment panel.
		Group interface.

	I'm not sure if the Flash output will be able to use embedded icons.

*/

hud
	label
		parent_type = /hud/button
		screen_loc = "WEST,SOUTH+1"
		icon = 'code/icons/blank.dmi'
		alpha = 224
		text_size = 3
		var shadows[]
		set_text(t)
			if(isnull(t)) t = maptext
			..()
			if(!shadows)
				shadows = newlist(
					/obj { pixel_x =  0; pixel_y = -1; layer = 200; icon = 'code/icons/blank.dmi' },
					/obj { pixel_x =  0; pixel_y =  1; layer = 200; icon = 'code/icons/blank.dmi' },
					/obj { pixel_x =  1; pixel_y =  0; layer = 200; icon = 'code/icons/blank.dmi' },
					/obj { pixel_x = -1; pixel_y =  0; layer = 200; icon = 'code/icons/blank.dmi' },
				)
			else underlays -= shadows
			for(var/obj/shadow in shadows)
				shadow.maptext_width = maptext_width
				shadow.maptext_height = maptext_height
				shadow.maptext = "<font color=[rgb(0, 0, 0)]><text align=center valign=middle>[maptext]"
			maptext = "<font color=[rgb(166, 159, 111)]><text align=center valign=middle>[maptext]"
			underlays += shadows

	button
		parent_type = /obj
		icon = 'code/flash hud/hud icons 32.dmi'
		icon_state = "cell"
		layer = 200

		var client/client
		New(client/c)
			if(istype(c))
				c.screen += src
				client = c

		var expands = FALSE
		var expanded = FALSE
		proc/toggle() expanded ? collapse() : expand()
		proc/expand() if(!expanded)
			expanded = TRUE
			expanded()
			return TRUE
		proc/collapse() if(expanded)
			expanded = FALSE
			collapsed()
			return TRUE
		proc/expanded()
		proc/collapsed()

		Click()
			if(expands) toggle()
			..()

		var text_size = 1
		var text_align = "center"
		var text_valign = "middle"
		proc/set_text(t) maptext = "<font size=[text_size] align=[text_align] valign=[text_valign]>[t]"

		inventory
			icon = 'code/flash hud/hud icons wide.dmi'
			screen_loc = "SOUTH+1,WEST+2:16"
			maptext_width = 48
			text_size = 2
			proc/update(t) set_text(t)
			expands = TRUE
			collapsed()
				var mob/player/p = usr || client && client.mob
				p.inventory_grid.hide()
				p.equipment_grid.hide()
				icon_state = "cell"
			expanded()
				var mob/player/p = usr || client && client.mob
				p.inventory_grid.show()
				p.equipment_grid.show()
				p.menu_button.expand()
				icon_state = "down"

		crafting
			icon = 'code/flash hud/hud icons wide.dmi'
			maptext = "<font size=1 align=center valign=middle>Craft"
			maptext_width = 48
			screen_loc = "SOUTH+1,WEST+4:16"
			expands = TRUE
			collapsed()
				var mob/player/p = usr || client && client.mob
				if(p) p.crafting_grid.hide()
				icon_state = ""

			expand()
				var mob/player/p = usr || client && client.mob
				if(p) // && p.craftables_source)
					if(!p.craftables_source)
						p.fill_crafting_grid(no_tool_list)
					return ..()

			expanded()
				var mob/player/p = usr || client && client.mob
				if(p)
					p.crafting_grid.show()
					p.menu_button.expand()
				icon_state = "down"

		menu
			maptext = "<font size=1 align=center valign=middle>Menu"
			screen_loc = "WEST+1,SOUTH+1"
			expands = TRUE
			var parts[]
			New(client/c, parts)
				..()
				src.parts = parts

			expanded()
				var mob/player/p = usr || client && client.mob
				p.client.screen |= parts
				if(p.inventory_button.expanded)
					p.inventory_grid.show()
					p.equipment_grid.show()
				if(p.crafting_button.expanded)
					p.crafting_grid.show()
				icon_state = "down"

			collapsed()
				var mob/player/p = usr || client && client.mob
				p.client.screen -= parts
				p.inventory_grid.hide()
				p.equipment_grid.hide()
				p.crafting_grid.hide()
				icon_state = "cell"

		channel
			icon = 'code/flash hud/hud icons wide.dmi'
			maptext_width = 48
			screen_loc = "EAST-2:16,SOUTH+1"
			Click()
				var mob/player/p = usr || client && client.mob
				p.change_channel()
				update(p.channel)

			proc/update(t) set_text(t)

var looper/inventory_loop = new ("item tick")

mob/player
	var tmp
		hud
			label
				info_bar

			button
				menu/menu_button
				inventory/inventory_button
				crafting/crafting_button
				channel/channel_button

			grid
				inventory/inventory_grid
				equipment/equipment_grid
				crafting/crafting_grid
				storage/storage_grid

		_inventory_stale
		_equipment_stale
		_storage_stale

	proc/item_tick()
		if(_inventory_stale)
			_inventory_stale = FALSE
			update_inventory_grid()
		if(_equipment_stale)
			_equipment_stale = FALSE
			update_equipment_grid()
		if(_storage_stale)
			_storage_stale = FALSE
			update_storage_grid()

	PostLogin()
		info_bar = new (client)
		info_bar.maptext_width = (client.view_size[1] * 2 + 1) * 32

		inventory_grid = new (client)
		equipment_grid = new (client)
		crafting_grid = new (client)
		storage_grid = new (client)
		inventory_button = new
		crafting_button = new
		channel_button = new (client)
		menu_button = new (client, list(
			inventory_button,
			crafting_button
		))
		..()
		spawn(1)
			InventoryGrid()
			crafting_button.collapse()
			inventory_loop.add(src)

	//	The inventory grid can have cells that can swap to other cells
	InventoryGrid()
		_inventory_stale = TRUE

		Items = 0
		for(var/obj/Item/i in src)
			if(is_equipped(i)) continue
			if(i.weight)
				Items += i.weight * i.Stacked

	proc/update_inventory_grid()
		var visible_items[0]
		var empty_cells[0]

		for(var/hud/grid/cell/c in inventory_grid.cells)
			if(c.object)
				if((c.object in visible_items) || !(c.object in src) || is_equipped(c.object))
					c.empty()
				else
					//	update c
					c.fill(c.object)
					visible_items += c.object

			if(!c.object)
				empty_cells += c
				c.empty()

		for(var/obj/Item/item in src)
			if(!is_equipped(item) && !(item in visible_items))
				if(!empty_cells.len) return

				//	add the item to the first empty cell found
				var hud/grid/cell/c = empty_cells[1]
				empty_cells -= c
				c.fill(item)

		inventory_button.update("Items<br>[round(Items / Item_Limit * 100, 1)]% Full")

		EquipmentGrid()

	//	The equipment grid has specialized cells for specific equipment types
	EquipmentGrid()
		_equipment_stale = TRUE

	proc/update_equipment_grid()
		for(var/hud/grid/cell/c in equipment_grid.cells)
			c.fill(equipment[c.id])

	StorageGrid()
		_storage_stale = TRUE

		if(storage)
			storage.Items = 0
			for(var/obj/Item/i in storage)
				if(i.weight)
					storage.Items += i.weight * i.Stacked
			storage_grid.capacity.set_text("[storage]<br>[round(storage.Items / storage.Item_Limit * 100, 1)]% Full")

	proc/update_storage_grid()
		var visible_items[0]
		var empty_cells[0]

		for(var/hud/grid/cell/c in storage_grid.cells)
			if(!storage)
				c.empty()
				continue

			if(c.object)
				if((c.object in visible_items) || !(c.object in storage))
					c.empty()
				else
					//	update c
					c.fill(c.object)
					visible_items += c.object

			if(!c.object)
				empty_cells += c
				c.empty()

		if(!storage) return

		for(var/obj/Item/item in storage.contents - visible_items)
			if(item in visible_items) continue
			if(!empty_cells.len) return

			//	add the item to the first empty cell found
			var hud/grid/cell/c = empty_cells[1]
			empty_cells -= c
			c.fill(item)

	//	The crafting grid is semi-static.
	//	When a craftables list is loaded, it doesn't often change.
	//	This is actually a pretty generic proc for filling a grid with a list.
	proc/fill_crafting_grid(craftables[], index)
		crafting_grid.craftables = craftables
		for(var/n in 1 to crafting_grid.cells.len)
			var hud/grid/cell/c = crafting_grid.cells[n]
			var i = index + n
			var builder/b = i <= craftables.len && craftables[i]
			c.fill(b)
	//		world << "[c]<<[b]"

	proc/clear_crafting_grid()
		for(var/hud/grid/cell/c in crafting_grid.cells)
			c.empty()
		craftables_source = null
		crafting_grid.craftables = null
		crafting_grid.index = 0
		crafting_grid.hide()
		crafting_button.collapse()

