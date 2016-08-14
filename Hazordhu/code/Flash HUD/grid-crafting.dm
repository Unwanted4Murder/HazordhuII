hud/grid
	crafting
		x = 13
		y = 3
		px = 0
		py = 0
		width = 11
		height = 9
		horizontal_padding = 0
		vertical_padding = 0

		var index
		var craftables[]

		var hud/grid/crafting/arrow
			next/next
			previous/previous

		New()
			..()
			next = new (src)
			previous = new (src)

		show()
			if(!craftables) craftables = no_tool_list
			. = ..()
			if(.)
				client.screen |= list(next, previous)
		//		var mob/player/p = client.mob
		//		p.storage_grid.hide()

		hide()
			. = ..()
			if(.)
				client.screen -= list(next, previous)
		//		var mob/player/p = client.mob
		//		if(p.storage) p.storage_grid.show()

		add_cell(hud/grid/cell/cell, x, y)
			cell.alpha = 224

		mouse_enter(hud/grid/cell/cell)
			if(cell.object)
				animate(cell, alpha = 255, time = 1)
				var builder/builder = cell.object
				#if DM_VERSION < 510
				label.set_text(replaceall("<b>[builder.name]</b>: [builder.desc]", "<br />", "\n"))
				#else
				label.set_text(replacetext("<b>[builder.name]</b>: [builder.desc]", "<br />", "\n"))
				#endif

		mouse_exit(hud/grid/cell/cell)
			if(cell.object)
				animate(cell, alpha = 224, time = 1)
				label.set_text()

		arrow
			parent_type = /obj
			icon = 'code/flash hud/hud icons 32.dmi'
			alpha = 128
			layer = 201
			var hud/grid/crafting/grid
			New(g) grid = g

			MouseEntered()
				animate(src, alpha = 224, transform = matrix()*(5/4), time = 1)

			MouseExited()
				animate(src, alpha = 128, transform = null, time = 1)

			next
				icon_state = "next"
				screen_loc = "22,13"
				Click()
					var a = grid.width * grid.height
					var i = grid.index + a
					if(i >= grid.craftables.len) i = 0
					grid.index = i

					var mob/player/p = usr
					p.fill_crafting_grid(grid.craftables, grid.index)

			previous
				icon_state = "previous"
				screen_loc = "14,13"
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

		var hud/grid/crafting/label/label
		New()
			..()
			label = new
			label.grid = src

		show()
			. = ..()
			if(.) client.screen |= label

		hide()
			. = ..()
			if(.) client.screen -= label

		label
			parent_type = /hud/grid/cell
			icon = 'code/flash hud/hud icons medium.dmi'
			screen_loc = "15,12"
			maptext_width = 224
			maptext_height = 96
			proc/set_text(t)
				maptext = "<font size=2 align=left valign=top>[t]"
				if(t) animate(src, alpha = 224, time = 1)
				else animate(src, alpha = 128, time = 1)

		filled(hud/grid/cell/cell)
			cell.alpha = 224
			cell.mouse_opacity = TRUE

		emptied(hud/grid/cell/cell)
			cell.alpha = 0
			cell.mouse_opacity = FALSE