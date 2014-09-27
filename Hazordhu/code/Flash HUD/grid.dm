hud/grid
	//	who this HUD is shown to
	var client/client

	//	in cells
	var width = 4
	var height = 5

	//	in pixels
	var cell_width = 32
	var cell_height = 32

	//	a list of cells
	var cells[]

	//	anchor position, origin of growth
	var x = "WEST"
	var y = "SOUTH"

	var px = 0
	var py = 0

	var horizontal_padding = 0
	var vertical_padding = 0

	//	direction of growth
	var dir = NORTHEAST

	//	show/hide stuff
	var _visible = FALSE
	proc/show() if(!_visible)
		_visible = TRUE
		client.screen |= cells
		return TRUE

	proc/hide() if(_visible)
		_visible = FALSE
		client.screen -= cells
		return TRUE

	proc/toggle() _visible ? hide() : show()

	proc/is_visible() return _visible

	//	mouse interactions (usr-friendly)
	proc/mouse_down(hud/grid/cell/cell)
	proc/click(hud/grid/cell/cell)
	proc/right_click(hud/grid/cell/cell)
	proc/mouse_up(hud/grid/cell/cell)
	proc/dblclick(hud/grid/cell/cell)

	proc/mouse_enter(hud/grid/cell/cell)
	proc/mouse_exit(hud/grid/cell/cell)

	proc/drag(hud/grid/cell/cell, atom/over_object)
	proc/drop(hud/grid/cell/cell, atom/over_object)

	proc/is_full()

	//	handy events
	proc/add_cell(hud/grid/cell/cell, x, y)
	proc/filled(hud/grid/cell/cell)
	proc/emptied(hud/grid/cell/cell)

	// return the name of the cell
	proc/cell_name(hud/grid/cell/cell) return cell.object ? cell.object.name : "cell"

	//	initialize and populate cells
	New(client/client)
		src.client = client
		cells = new
		for(var/y in height to 1 step -1) for(var/x in 1 to width)
			var dx = 0, dy = 0
			if(dir & NORTH) dy = y - 1
			if(dir & SOUTH) dy = 1 - y
			if(dir & EAST)  dx = x - 1
			if(dir & WEST)  dx = 1 - x
			var hud/grid/cell/c = new
			var sx = "[src.x]:[src.px + dx * cell_width + (x - 1) * horizontal_padding]"
			var sy = "[src.y]:[src.py + dy * cell_height + (y - 1) * vertical_padding]"
			c.screen_loc = "[sx],[sy]"
			c.grid = src
			cells += c
			add_cell(c, x, y)

	cell
		parent_type = /obj
		icon = 'code/flash hud/hud icons 32.dmi'
		icon_state = "cell"
		layer = 200
		var atom/object
		var hud/grid/grid
		var id
		Click(l, c, p[])
			p = params2list(p)
			if(p["left"]) grid.click(src)
			if(p["right"]) grid.right_click(src)
		DblClick() grid.dblclick(src)
		MouseDrag(o) grid.drag(src, o)
		MouseDrop(o) grid.drop(src, o)
		MouseDown() grid.mouse_down(src)
		MouseUp() grid.mouse_up(src)
		MouseEntered()
			grid.mouse_enter(src)
			..()
		MouseExited()
			grid.mouse_exit(src)
			..()

		proc/empty()
			object = null
			overlays = list()
			name = grid.cell_name(src)
			grid.emptied(src)

		proc/fill(atom/o)
			if(!o)
				empty()

			else if(!grid.is_full())
				object = o
				name = grid.cell_name(src)

				var image/i = image(o.icon, o.icon_state, layer = 201)
				i.pixel_x = o.pixel_x
				i.pixel_y = o.pixel_y
				overlays = list(i) + o.overlays
				grid.filled(src)

		proc/swap(hud/grid/cell/cell)
			var atom/a = object
			var atom/b = cell.object
			empty()
			cell.empty()
			if(b) fill(b)
			if(a) cell.fill(a)

	inventory
		x = 2
		y = 3
		width = 5
		height = 9

		show()
			. = ..()
			if(.)
				var mob/player/p = client.mob
				if(p.storage)
					p.storage_grid.show()

		hide()
			. = ..()
			if(.)
				var mob/player/p = client.mob
				p.stop_storage()

		add_cell(hud/grid/cell/cell)
			cell.alpha = 224

		mouse_enter(hud/grid/cell/cell)
			animate(cell, alpha = 255, time = 1)

		mouse_exit(hud/grid/cell/cell)
			animate(cell, alpha = 224, time = 1)

		cell_name()
			. = ..()
			if(. == "cell")
				. = "inventory"

		drop(hud/grid/cell/a, hud/grid/cell/b)
			var mob/player/p = usr

			//	swap cells
			if(b in cells)
				var obj/Item/A = a.object
				var obj/Item/B = b.object
				if(A && B) A.MouseDrop(B)
				a.swap(b)

			//	equip
			else if(b in p.equipment_grid.cells)
				p.equip(a.object)

			//	store
			else if(b in p.storage_grid.cells)
				if(a.object)
					var obj/Item/i = a.object
					if(i.store_item(p, p.has_key("ctrl") || p.client.mouse.right))
						b.fill(i)

			//	other
			else if(a.object)
				a.object.MouseDrop(b, usr, b.loc)

		//	drop
		click(hud/grid/cell/cell)
			var obj/Item/item = cell.object
			if(istype(item))
				item.interact(client.mob)
			cell.fill(cell.object)

		//	interact
		right_click(hud/grid/cell/cell)
			var obj/Item/item = cell.object
			if(istype(item))
				//	alternate use
				if(client.has_key("ctrl"))
					item.use_alt(client.mob)

				//	normal use
				else item.use(client.mob)

	storage
		x = 8
		px = -16
		y = 3
		width = 5
		height = 9

		add_cell(hud/grid/cell/cell)
			cell.alpha = 224

		mouse_enter(hud/grid/cell/cell)
			animate(cell, alpha = 255, time = 1)

		mouse_exit(hud/grid/cell/cell)
			animate(cell, alpha = 224, time = 1)

		cell_name()
			. = ..()
			if(. == "cell")
				. = "storage"

		var hud/grid/storage/capacity/capacity

		New()
			..()
			capacity = new (client)

		drop(hud/grid/cell/a, hud/grid/cell/b)
			var mob/player/p = client.mob
			var obj/Item/i = a.object
			if(b in cells)
				a.swap(b)
			else if(i)
				if(b in p.inventory_grid.cells)
					if(i.unstore_item(p, p.has_key("ctrl") || p.client.mouse.right))
						b.fill(i)
				else if(b in p.equipment_grid.cells)
					if(p.equip(i))
						i.unstore_item(p, p.has_key("ctrl") || p.client.mouse.right)

		capacity
			parent_type = /obj
			layer = 200
			screen_loc = "9,2"
			icon = 'hud icons wide.dmi'
			maptext_width = 48
			proc/set_text(t) maptext = "<text align=center valign=middle><font size=1>[t]"

		show()
			. = ..()
			if(.)
				client.screen += capacity

		hide()
			. = ..()
			if(.)
				client.screen -= capacity

	equipment
		x = 3
		y = 13
		px = 0
		py = -16
		width = 3
		height = 4

		//	unequip
		drop(hud/grid/cell/a, hud/grid/cell/b)
			var mob/player/p = usr
			if(a.object && ((b in p.inventory_grid.cells) || (b in p.storage_grid.cells)) && p.unequip(a.object) && !b.object)
				b.fill(a.object)

		click(hud/grid/cell/cell)
			var mob/player/p = usr
			if(cell.object)
				p.unequip(cell.object)

		//	interact
		right_click(hud/grid/cell/cell)
			var obj/Item/item = cell.object
			if(istype(item))
				//	alternate use
				if(client.has_key("ctrl"))
					item.use_alt(client.mob)

				//	normal use
				else item.use(client.mob)

		//	specified slots
		var global/equipment_slots[] = list(
			"1,1" = "misc",
			"2,1" = "feet",
			"3,1" = "bag",
			"1,2" = "belt",
			"2,2" = "legs",
			"3,2" = "hands",
			"1,3" = "main",
			"2,3" = "body",
			"3,3" = "off",
			"1,4" = "helmet",
			"2,4" = "head",
			"3,4" = "back")

		cell_name(hud/grid/cell/cell)
			. = ..()
			if(. == "cell")
				. = cell.id

		add_cell(hud/grid/cell/cell, x, y)
			cell.id = equipment_slots["[x],[y]"]
			cell.alpha = 224

		mouse_enter(hud/grid/cell/cell)
			animate(cell, alpha = 255, time = 1)

		mouse_exit(hud/grid/cell/cell)
			animate(cell, alpha = 224, time = 1)

		filled(hud/grid/cell/cell)
			cell.icon_state = "cell"

		emptied(hud/grid/cell/cell)
			cell.icon_state = cell.id
