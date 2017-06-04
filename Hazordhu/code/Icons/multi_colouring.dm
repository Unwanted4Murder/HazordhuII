

group
	proc
		Group_Icon(prim_icon, sec_icon)
			var icon/prim = icon(prim_icon)
			var icon/sec = icon(sec_icon)

			prim.Blend(prim_col, ICON_ADD)
			sec.Blend(sec_col, ICON_ADD)

			prim.Blend(sec, ICON_OVERLAY)
			return prim

obj/Item
	proc/GroupColour(coli, grpi, mob/player/user, rank)
		var/group/grp = user.Group
		if(grp && grp.rank(user) < rank && (user.s_alert("You are in a group, will you colour this your group colours?", "Group Colouring", "Yes", "No")=="Yes"))
			icon = initial(icon)
			icon = grp.Group_Icon(coli, grpi)

	proc/Multi_Color(colour_icon, user)
		var/colour = input(user,"Choose the color of the item.","Color") as color
		if(!colour) return
		Color = colour

		var/icon/i = icon(colour_icon)
		i.Blend(colour, ICON_ADD)
		icon = initial(icon)
		var/icon/ret_icon = icon(icon)
		ret_icon.Blend(i, ICON_OVERLAY)
		return ret_icon

	Weapons/Flag
		col_icon = 'bearer_col.dmi'

		//ctrlKey(mob/player/m, right)
		use_alt(mob/player/m)
			if(/*right && */loc == m)
				var group/g = m.Group
				if(g && g.rank(m) < 4 && "Yes" == m.s_alert("You are in a group, will you colour this your group colours?", "Group Colouring", "Yes", "No"))
					var icon/over = g.Group_Icon(col_icon, icon('group_bearer.dmi'))
					var icon/i = icon(initial(icon))
					i.Blend(over, ICON_OVERLAY)
					icon = i
				else icon = Multi_Color(col_icon, m)

	Armour
		Helmet
			Plate_Helmet_Plume_Visor
				col_icon = 'plume.dmi'
				use_alt(mob/humanoid/m)
					if(!m.is_equipped(src))
						icon = Multi_Color(col_icon, m)

			Plate_Helmet_Plume
				col_icon = 'plume.dmi'
				use_alt(mob/humanoid/m)
					if(!m.is_equipped(src))
						icon = Multi_Color(col_icon, m)
		Back
			Plated_Cape
				col_icon = 'shouldercape.dmi'
				set_color(mob/player/m)
					var/group/grp = m.Group
					if(grp && grp.rank(m) < 4 && (m.s_alert("You are in a group, will you colour this your group colours?", "Group Colouring", "Yes", "No")=="Yes"))
						var/icon/over = grp.Group_Icon(col_icon, icon('shouldercape_group.dmi'))
						var/icon/i = icon(initial(icon))
						i.Blend(over, ICON_OVERLAY)
						icon = i
					else icon = Multi_Color(col_icon, m)

	Clothing
		Back
			Cloak
				col_icon = 'group_cloak.dmi'
				set_color(mob/player/m)
					var/group/grp = m.Group
					if(grp && grp.rank(m) < 4 && (m.s_alert("You are in a group, will you colour this your group colours?", "Group Colouring", "Yes", "No")=="Yes"))
						icon = initial(icon)
						icon = grp.Group_Icon(icon, col_icon)
					else return ..()
			Cape
				col_icon = 'group_cape.dmi'
				set_color(mob/player/m)
					var/group/grp = m.Group
					if(grp && grp.rank(m) < 4 && (m.s_alert("You are in a group, will you colour this your group colours?", "Group Colouring", "Yes", "No")=="Yes"))
						icon = initial(icon)
						icon = grp.Group_Icon(icon, col_icon)
					else return ..()
			Tabard
				col_icon = 'group_tabard.dmi'
				set_color(mob/player/m)
					var/group/grp = m.Group
					if(grp && grp.rank(m) < 4 && (m.s_alert("You are in a group, will you colour this your group colours?", "Group Colouring", "Yes", "No")=="Yes"))
						icon = initial(icon)
						icon = grp.Group_Icon(icon, col_icon)
					else return ..()
		Hood
			Hood
				col_icon = 'group_hood.dmi'
				set_color(mob/player/m)
					var/group/grp = m.Group
					if(grp && grp.rank(m) < 4 && (m.s_alert("You are in a group, will you colour this your group colours?", "Group Colouring", "Yes", "No")=="Yes"))
						icon = initial(icon)
						icon = grp.Group_Icon(icon, col_icon)
					else return ..()


obj
	Flag
		col_icon = 'flag_col.dmi'
		var group_id
		proc/get_group()
			for(var/group/g in groups)
				if(g.id == group_id)
					return g

		var Color
		var can_color = TRUE

		proc/Multi_Color(colour_icon, user)
			if(!can_color) return

			var colour = input(user, "Choose the color of the flag.", "Color") as null | color
			Color = colour
			return get_colored_icon(Color)

		//	col_icon is the part of the flag icon that gets colored
		//	it's overlayed on top of the wooden part

		proc/get_colored_icon(color)
			if(!color) color = src.Color
			src.Color = color
			if(!color) return initial(icon)

			var icon/i = icon(col_icon)
			i.Blend(color, ICON_ADD)

			var icon/result = icon(initial(icon))
			result.Blend(i, ICON_OVERLAY)

			return result

		proc/apply_color() icon = get_colored_icon()

		proc/apply_group(group/G)
			group_id = G.id
			var icon/over = G.Group_Icon(col_icon, icon('group_flags.dmi', G.flag_design))
			var icon/i = icon(icon)
			i.Blend(over, ICON_OVERLAY)
			icon = i

		interact_right(mob/player/m)
			if(!can_color) return

			var group/G = m.Group
			if(G && G.rank(m) < 3)
				if("Yes" == m.s_alert("You are in a group, will you colour this your group colours?", "Group Colouring", "Yes", "No") && G)
					apply_group(G)
					return

			group_id = null
			icon = Multi_Color(col_icon, m)