
var groups[0]
var const/group_save = "Data/Map/groups.sav"
proc
	savegroups()
		if(fexists(group_save))
			fdel(group_save)

		for(var/group/g in groups)
			if(!g.members.len)
				groups -= g

		if(groups.len)
			fdel(group_save)
			var savefile/f = new (group_save)
			f << groups

	loadgroups() if(fexists(group_save))
		var savefile/f = new (group_save)
		f >> groups

mob
	//	Get nearby players associated with their visible name.
	proc/nearby_player_names(mob/player/center = usr)
		var players[0], duplicates[0]
		for(var/mob/player/p in ohearers(src))
			if(center.see_invisible < p.invisibility) continue
			if(center.is_stranger(p)) continue
			var name = nameShown(p)
			if(name in players)
				duplicates |= name
			else players[name] = p
		players -= duplicates
		return players

	proc/is_stranger(mob/player/p)
		if(!istype(p)) return FALSE
		return nameShown(p) == p.stranger_name()

obj
	var tmp/col_icon

group
	New()
		..()
		groups += src
		if(!id) id = string()

	Del()
		..()
		groups -= src

	var
		prim_col = "#000000"	//	The group's primary color
		sec_col	="#000000"		//	The group's secondary color
		flag_design = "2"		//	The icon state of their flag design

		id
		name
		members[0]
		keys[0]

		tmp/obj/Flag/Neutral/flag_display

	proc
		members_online()
			. = list()
			for(var/mob/m in Players)
				if(m.key in members)
					. += m

		get_member(key)
			for(var/mob/m in Players)
				if(m.key == key)
					return m

		rank(mob/m)
			if(ismob(m))
				return members[m.key]
			else if(istext(m))
				return members[m]
			else CRASH("Invalid group member tag: [m]")

		out(text, mob/player/speaker, target)
			if(!target) target = members_online()
			if(speaker)
				text = html_encode(text)
				for(var/mob/m in target)
					m << output("<B>{[rank(speaker)]}[m.nameShown(speaker)]</B>: [text]", "group_chat")
			else target << output("<I>[text]</I>", "group_chat")

		//	Called when the player does it
		Login(mob/player/player)
		Logout(mob/player/player)

		add(mob/player/player, rank)

		remove(mob/player/player)

		update_flag()
			if(!flag_display)
				flag_display = new
				flag_display.name = "Flag of [name]"
				flag_display.screen_loc = "group_flag_display:1,1"
			flag_display.apply_group(src)

		flag_display()
			if(!flag_display) update_flag()
			return flag_display

	verb
		leave()
			var mob/player/player = usr
			var group/group = player.Group

			if("Yes" == player.s_alert("Are you sure you want to leave your group?","Leave","Yes","No"))
				if(group.members.len > 1 && group.rank(player) == 1 && "Yes" == player.s_alert("You are the leader of your group. Would you consider transferring ownership instead of disbanding your group?", "Leave", "Yes", "No"))
					call(player, /group/verb/transfer_ownership)()
					return

				//	todo: hide group stuff

				if(group.rank(player) == 1)
					group.out("The group has been disbanded.")
					del group

				else
					group.members -= player.key
					if(!group.members.len)
						del group
					player.Group = null
					//	todo: hide group stuff

		invite()
			var mob/player/player = usr
			var group/group = player.Group

			if(group.rank(player) > 2)
				group.out("You don't have high enough rank to invite new members!", target = player)
				return

			var invites[0]
			var names[] = player.nearby_player_names()
			for(var/name in names)
				var mob/player/p = names[name]
				if(p.client && !p.Group && p.Race == player.Race)
					invites[name] = names[name]
			if(!invites.len)
				group.out("There is nobody nearby you can invite!", target = player)
				return

			var choice = input(player, "Who would you like to invite?") as null|anything in invites
			if(choice)
				var mob/player/invited = invites[choice]
				var uname = choice
				var iname = invited.nameShown(player)
				if("Yes" == invited.s_alert("[iname] has invited you to join their group, do you accept?","Invite","Yes","No"))
					player.s_alert_bg("[uname] has accepted your invitation.","Accepted","Yay!")
					group.members += invited.key
					group.members[invited.key] = 4
					invited.Group = group
					for(var/mob/m in group.members_online())
						group.out("[m.nameShown(invited)] has joined the group!", target = m)
				else group.out("[uname] has declined your invitation.", target = player)

		kick()
			var mob/player/player = usr
			var group/group = player.Group

			if(group.rank(player) > 2)
				group.out("You don't have high enough rank to kick someone!", target = player)
				return

			if(group.members.len > 1)
				var/tokick = input("Who will you kick from the group?")	as null|anything in group.members - player.key
				if(tokick)
					if(group.rank(tokick) > group.rank(player))
						group.members -= tokick
						var mob/player/k = group.get_member(tokick)
						if(k)
							k.Group = null
							k << "You have been kicked from your group by [player]."
						group.out("You have kicked [tokick] from the group", target = player)

					else group.out("[tokick] is [group.rank(tokick)>group.rank(player)?"a higher rank than":"the same rank as"] you.", target = player)

		change_rank()
			var mob/player/player = usr
			var group/group = player.Group

			if(group.rank(player) > 2)
				group.out("You don't have high enough rank to change someone's rank!", target = player)
				return

			if(group.members.len > 1)
				var membas[0]
				for(var/mem in group.members) if(mem != player.key)
					membas["[mem] ([group.rank(mem)])"] = mem

				var/tochange = membas[input("Who will you change the rank of from the group?") as null|anything in membas]
				if(tochange)
					if(group.rank(tochange) > group.rank(player))
						var/newrank = input("What will you make [tochange]'s rank? (Currently [group.members["[tochange]"]])","Rank",group.members["[tochange]"]) in list(2,3,4)
						group.members[tochange] = newrank

					else group.out("[tochange] is [group.rank(tochange)>group.rank(player)?"a higher rank than":"the same rank as"] you.", target = player)

		transfer_ownership()
			var mob/player/player = usr
			var group/group = player.Group

			if(group.rank(player) > 1)
				group.out("Only the owner can transfer ownership!", target = player)
				return

			if(group.members.len > 1)
				var/totransfer = input("Who will you transfer group ownership to?") as null|anything in player.Group.keys - player.key
				if(totransfer && "Yes" == player.s_alert("Are you sure you want [totransfer] to own your group?", "Transfer Ownership", "No", "Yes"))
					group.members[totransfer] = 1
					group.members[player.key] = 2
					player.s_alert_bg("Your rank is now 2.","New Rank")
					var mob/player/m
					for(m in Players) if(m.key == totransfer) break
					if(m) m.s_alert_bg("You are now the leader of your group.","Ownership Transferred", "OK")

			else group.out("There is no one to transfer ownership of your group to.", target = player)

		change_flag()
			var mob/player/player = usr
			var group/group = player.Group
			player.change_flag()
			group.update_flag()

		group_chat(t as text)
			var mob/player/player = usr
			var group/group = player.Group
			group.out(t, usr)

//	Group procedures
mob
	proc/change_flag()

	player
		change_flag()
			if(!Group) return
			if(Group.rank(src) > 2)
				Group.out("You're not a high enough rank to change the group's flag!", target = src)
				return

			var new_prim = input(src, "Choose the group's Primary color.", "Primary Group Color", Group.prim_col) as null|color
			if(!new_prim) return

			var new_sec = input(src, "Choose the group's Secondary color.", "Secondary Group Color", Group.sec_col) as null|color
			if(!new_sec) return

			Group.prim_col = new_prim
			Group.sec_col = new_sec

			Group.out("The group's colors have been changed.")



obj/flag_design
	icon = 'code/Icons/groupcreate.dmi'
	next
		icon_state = "next"
		screen_loc = "flag_preview:3,1"
		Click()
			var mob/player/p = usr
			var n = text2num(p.making_group.flag_design)
			if(++ n > 12) n = 1
			p.making_group.flag_design = "[n]"
			p.update_flag_preview()

	prev
		icon_state = "prev"
		screen_loc = "flag_preview:1,1"
		Click()
			var mob/player/p = usr
			var n = text2num(p.making_group.flag_design)
			if(-- n < 1) n = 12
			p.making_group.flag_design = "[n]"
			p.update_flag_preview()

mob/player
	var tmp/group/Group
	var tmp/group/making_group
	var tmp/obj/Flag/Neutral/flag_preview

	verb/update_flag_preview()
		if(!flag_preview)
			flag_preview = new
			flag_preview.screen_loc = "flag_preview:2,1"
			client.screen += flag_preview
		var/icon/over = making_group.Group_Icon(flag_preview.col_icon, icon('code/Icons/group_flags.dmi', making_group.flag_design))
		var/icon/i = icon(flag_preview.icon)
		i.Blend(over, ICON_OVERLAY)
		flag_preview.icon = i

	verb/primcolor()
		set hidden = 1
		if(!making_group) return
		making_group.prim_col = input(src, "Choose a primary color for your group.","Primary Color", making_group.prim_col) as color
		update_flag_preview()

	verb/seccolor()
		set hidden = 1
		if(!making_group) return
		making_group.sec_col = input(src, "Choose a secondary color for your group.","Secondary Color", making_group.sec_col) as color
		update_flag_preview()

	verb/finish_groupcreate()
		set hidden = 1
		if(!making_group) return
		var gname = winget(src, "group_create.groupname", "text")
		if(length(gname) < 5 || length(gname) > 50)
			s_alert_bg("Your group name must be between 5 and 50 characters!","New Group","Oh no!")
			cancel_groupcreate()
			return
		for(var/group/g in groups) if(g.name == gname)
			s_alert_bg("That name is already taken.","New Group","Oh no!")
			cancel_groupcreate()
			return
		making_group.name = gname
		making_group = null

	verb/cancel_groupcreate()
		set hidden = TRUE
		del making_group
		making_group = FALSE

	verb/group_create()
		set hidden = TRUE
		if(making_group) return
		if(Group) return
		if(!isSubscriber) return aux_output("Only subscribers can create groups!")
		if("Yes" == s_alert("Would you like to create a new Group?", "New Guild", "No", "Yes"))
			var group/grp = new
			making_group = grp

			var global/flag_design_buttons[] = newlist(
				/obj/flag_design/next,
				/obj/flag_design/prev)

			client.screen += flag_design_buttons
			winshow(src, "group_create")
			update_flag_preview()
			while(making_group) sleep 5
			client.screen -= flag_design_buttons
			winshow(src, "group_create", 0)
			if(making_group == FALSE) return
			grp.members[key] = 1
			Group = grp
			Group.update_flag()

mob/player
	PostLogin()
		..()
		for(var/group/g in groups)
			if(key in g.members)
				Group = g
				g.Login(src)
				break

	PreLogout()
		..()
		for(var/group/g in groups) if(key in g.members) g.Logout(src)
#if !THIN_SKIN
	Stat()
		..()
		var const
			yes = "true"
			no = "false"

		var s[0]

		//	Has group
		if(Group)
			client.screen |= Group.flag_display()

			verbs += typesof(/group/verb)
			s["group_name.text"] = Group.name

			//	Normal member commands
			s["create_group.is-visible"] = no
			s["leave.is-visible"] = yes
			s["group_flag_display.is-visible"] = yes
			s["group_chat.is-visible"] = yes
			s["group_input.is-visible"] = yes

			//	Has leader-like commands
			var rank = Group.rank(src)
			if(rank <= 2)
				s["ranks.is-visible"] = yes
				s["invite.is-visible"] = yes
				s["kick.is-visible"] = yes

				//	Has leader commands
				if(rank <= 1)
					s["leader.is-visible"] = yes
					s["change_flag.is-visible"] = yes

			//	Not leader-like rank
			else
				s["ranks.is-visible"] = no
				s["invite.is-visible"] = no
				s["kick.is-visible"] = no
				s["leader.is-visible"] = no
				s["change_flag.is-visible"] = no

		//	No group
		else
			verbs -= typesof(/group/verb)
			s["group_name.text"] = "Group"
			s["create_group.is-visible"] = yes
			s["ranks.is-visible"] = no
			s["invite.is-visible"] = no
			s["kick.is-visible"] = no
			s["leader.is-visible"] = no
			s["change_flag.is-visible"] = no
			s["leave.is-visible"] = no
			s["group_chat.is-visible"] = no

		if(s.len)
			winset(src, null, list2params(s))
#endif