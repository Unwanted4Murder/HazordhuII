hud/grid
	crafting
		x = 8
		y = 4
		px = -18
		py = -16
		width = 2
		height = 4
		horizontal_padding = 226
		vertical_padding = 66

		var index
		var craftables[]

		var hud/grid/crafting/arrow
			next/next
			previous/previous

		New()
			..()
			next = new (src)
			previous = new (src)

		show() if(craftables)
			. = ..()
			if(.)
				client.screen |= list(next, previous)
				var mob/player/p = client.mob
				p.storage_grid.hide()

		hide()
			. = ..()
			if(.)
				client.screen -= list(next, previous)
				var mob/player/p = client.mob
				if(p.storage) p.storage_grid.show()

		add_cell(hud/grid/cell/cell, x, y)
			cell.alpha = 224

		mouse_enter(hud/grid/cell/cell)
			animate(cell, alpha = 255, time = 1)
			var hud/grid/crafting/label/label = get_label(cell)
			animate(label, alpha = 224, time = 1)

		mouse_exit(hud/grid/cell/cell)
			animate(cell, alpha = 224, time = 1)
			var hud/grid/crafting/label/label = get_label(cell)
			animate(label, alpha = 128, time = 1)

		arrow
			parent_type = /obj
			icon = 'code/flash hud/hud icons 32.dmi'
			alpha = 128
			var hud/grid/crafting/grid
			New(g) grid = g

			MouseEntered()
				animate(src, alpha = 224, transform = matrix()*(5/4), time = 1)

			MouseExited()
				animate(src, alpha = 128, transform = null, time = 1)

			next
				icon_state = "next"
				screen_loc = "24:-16,14:19"
				layer = 201
				Click()
					var a = grid.width * grid.height
					var i = grid.index + a
					if(i >= grid.craftables.len) i = 0
					grid.index = i

					var mob/player/p = usr
					p.fill_crafting_grid(grid.craftables, grid.index)

			previous
				icon_state = "previous"
				screen_loc = "7:14,14:19"
				layer = 201
				Click()
					var a = grid.width * grid.height
					var i = grid.index - a
					if(i < 0) i = round(grid.craftables.len - a / 2, a)
					grid.index = i

					var mob/player/p = usr
					p.fill_crafting_grid(grid.craftables, grid.index)

		drag(hud/grid/cell/cell)
			if(cell.object)
				var mob/player/p = client.mob
				p.BuildGrid.show(cell.object)
				p.crafting_grid.hide()

		drop(hud/grid/cell/cell, BuildGrid/build_cell/build_cell)
			if(cell.object)
				var mob/player/p = client.mob
				var builder/b = cell.object
				if(istype(build_cell) && istype(b))
					build_cell.parent.select(build_cell)
					b.craft(p, build_cell.loc)
				p.BuildGrid.hide()
				if(p.crafting_button.expanded)
					p.crafting_grid.show()

		dblclick(hud/grid/cell/cell)
			if(cell.object)
				var mob/player/p = client.mob
				var builder/b = cell.object
				hide()
				if(istype(b))
					b.craft(p)
				if(p.crafting_button.expanded)
					show()

		var obj/bg
		New()
			..()
			bg = new
			bg.icon = 'code/flash hud/hud icons 32.dmi'
			bg.icon_state = "bg"
			bg.layer = 199
			bg.screen_loc = "5,1 to 23,10"
			bg.name = "crafting"

		show()
			. = ..()
	//		if(.) client.screen |= bg

		hide()
			. = ..()
	//		if(.) client.screen -= bg

		var labels[]
		New()
			..()
			labels = new
			for(var/y in height to 1 step -1) for(var/x in 1 to width)
				var hud/grid/crafting/label/c = new
				var dx = 0, dy = 0
				if(dir & NORTH) dy = y - 1
				if(dir & SOUTH) dy = 1 - y
				if(dir & EAST)  dx = x - 1
				if(dir & WEST)  dx = 1 - x
				var sx = "[src.x]+1:[src.px + dx * cell_width + (x - 1) * horizontal_padding]"
				var sy = "[src.y]-1:[src.py + dy * cell_height + (y - 1) * vertical_padding]"
				c.screen_loc = "[sx],[sy]"
				c.grid = src
				labels += c

		show()
			. = ..()
			if(.) client.screen |= labels

		hide()
			. = ..()
			if(.) client.screen -= labels

		label
			parent_type = /hud/grid/cell
			icon = 'code/flash hud/hud icons medium.dmi'
			maptext_width = 224
			maptext_height = 96
			proc/set_text(t) maptext = "<font size=2 align=left valign=top>[t]"
			MouseEntered()
				var mob/player/p = usr
				p.crafting_grid.mouse_enter(p.crafting_grid.get_cell_from_label(src))
			MouseExited()
				var mob/player/p = usr
				p.crafting_grid.mouse_exit(p.crafting_grid.get_cell_from_label(src))

		proc/get_label(hud/grid/cell/cell) return labels[cells.Find(cell)]
		proc/get_cell_from_label(hud/grid/crafting/label/label) return cells[labels.Find(label)]

		filled(hud/grid/cell/cell)
			var hud/grid/crafting/label/label = get_label(cell)
			var builder/builder = cell.object
			label.set_text(replaceall("<b>[builder.name]</b>: [builder.desc]", "<br />", "\n"))
			label.alpha = 128
			cell.alpha = 224

		emptied(hud/grid/cell/cell)
			var hud/grid/crafting/label/label = get_label(cell)
			label.set_text()
			label.alpha = 0
			cell.alpha = 0