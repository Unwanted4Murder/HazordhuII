var const/WHISPER_RANGE = 16	//	in bounds dist

var max_ooc_length = 500

proc/current_time(format = "MM/DD hh:mm")
	return time2text(world.realtime, format)

var saylog = ""
var ooclog = ""
var ooc_on = TRUE

obj/Arrow
	icon = 'code/Icons/PointArrow.dmi'
	layer = 99
	pixel_y = 32
	mouse_opacity = false

//	Returns the turf of an object.
//	For example,  the turf of an item inside a player is the player's loc.
proc/turf_of(atom/object)
	if(!object) return
	if(isturf(object)) return object
	if(isarea(object)) return locate(object.x, object.y, object.z)
	if(!object.loc) return null
	if(object.z) return locate(object.x, object.y, object.z)
	var atom/container = object.loc.loc
	while(!isturf(container)) container = container.loc
	return container

client/Click(atom/object, l, c, pa)
	var p[] = params2list(pa)
	if(p["right"] && p["alt"])
		var mob/player/player = mob
		player.point_at(object)
	else return ..()

mob/player
	proc/point_at(atom/object)
		if(Pointing || object.loc == src) return
		if(istype(object, /obj/mouse_tracker)) return
		Pointing = true

		var mob/player/p = src
		if(istype(p) && p.Mute) return

		act()

		var obj/Arrow/a = new (turf_of(object))
		if(istype(object, /atom/movable))
			a.set_step(object:step_x, object:step_y)

		spawn(50)
			a.set_loc()
			Pointing = false

		if(isturf(object))
			emote("points over yonder")

		else
			if(!ismob(object))
				emote("points at [object]")

			else
				var name
				if(src == object)
					name = "itself"
					switch(gender)
						if(MALE) name = "himself"
						if(FEMALE) name = "herself"

				var textIcon = textIcon()
				for(var/mob/m in hearers(src))
					if(src != object)
						name = m.nameShown(object)
					m << "*[textIcon]<b>[m.nameShown(src)]</b> points at [name]*"

mob/player
	key_down(k)
		if(k == "return")
			winshow(src, "child_bl")
			winset(src, DMF_INPUT, "focus=true")
		else ..()

	Topic(href,href_list[])
		..()
		if(href_list["action"] == "adminhelp")
			if(is_admin(usr.ckey))
				var reply = input("What do you want to reply to [src.key]?") as null|text
				if(!reply) return

				AdminsOnline << "{ADMIN HELP} [usr.key] replied to [src.key]: [reply]"
				src << "{ADMIN HELP} Reply from [usr.key]: [reply]"
				src << "You can use the AdminHelp command again if you need to follow-up"

		if(href_list["show_url"])
			show_url(href_list["show_url"])

mob/Bump(atom/a)
	if(ismob(a))
		var mob/m = a
		if(locate(/obj/Item/binders/Footcuffs) in m.binders)
			step_away(m, src, 2, step_size)
	..()

var looper/typing_loop = new ("typing tick", 5)

mob/player
	var tmp
		typing
		emoting

	proc/typing_check()
		typing_loop.add(src)

	proc/typing_tick()
		typing = false
		emoting = false

		if(client && !Dead && !KO)
			//	todo: decide whether or not to use emote popup
			if(0 && winget(src, "emote", "is-visible") == "true")
				emoting = true
				status_overlay("emote")

			else
				var text = winget(src, DMF_INPUT, "text")
				var pos

				var global/commands[] = list(
					"say", "yell", "whisper", "emote")
				var command
				for(command in commands)
					if(findtext(text, command) == 1)
						break

				if(command)
					var quote = {"""}
					var quote_pos = length(command) + 2
					var quote_after = quote_pos + 1
					if(quote == copytext(text, quote_pos, quote_after))
						pos = quote_after
					else pos = quote_pos

					typing = copytext(text, pos)
					if(typing)
						act()
						if(command == "emote")
							emoting = true
							status_overlay("emote")
						else status_overlay("typing")

		if(!typing)  status_overlay_remove("typing")
		if(!emoting) status_overlay_remove("emote")

	proc/show_url(url)
		src << browse({"
			<meta http-equiv="Refresh" content="0; url=[url]">
		"})
		winshow(src, "browser_window")


	verb/login_message() view_login_message()

	verb/help()
	//	show_url("http://www.hazordhu.com/wiki/index.php/Kaiochao's_Game_Guide")

	verb/changes() show_url("http://hazordhu.com/forum/viewtopic.php?f=5&t=320&p=1034#p1034")
	verb/ToU() show_url("http://hazordhu.com/forum/viewtopic.php?f=5&t=316&p=1026#p1026")
	verb/bug_report() show_url("http://www.byond.com/forum/?forum=2393&command=add_post")
	verb/feature_request() show_url("http://www.hazordhu.com/forum/posting.php?mode=post&f=13")

	verb/credits()
		client.center_window("credits")
		winshow(src, "credits")

	verb/controls()
		src << output(null, "controls.out")
		src << output(control_info, "controls.out")
		client.center_window("controls")
		winshow(src, "controls")

var const/movement_info = \
{"
<u>Movement</u>
W - Move north
S - Move south
D - Move east
A - Move west
Shift - Run (while held, drains stamina)
* Hold two movement keys to move diagonally (or stand still, if opposing)
"}

var const/interface_info = \
{"
<u>Interface</u>
Z - Toggle the "Items" panel, which displays your inventory and equipment
C - Toggle the "Character" panel, which contains the Crafting, Group, and Skill Levels tabs
Enter - Give focus to the chat bar to start typing.
"}

var const/interaction_info = \
{"
<u>Interaction</u>
Left-click, E, or Space - Interact with most things in the world, like picking up items.
Right-click, Alt+E, Alt+Space - Alternate interaction
"}

var const/inventory_info = \
{"
<u>Inventory</u>
Left-click items you're holding to drop them. Hold Ctrl to move 10 at a time.
Middle-click equipment to equip. Can also drag equipment anywhere in the equipment area to equip.
Left-click equipped items to unequip them.
Middle-Click anywhere to automatically cycle through the tools in your inventory.
"}

var const/storage_info = \
{"
<u>Storage</u>
When viewing a storage object (chests, carts, bags), drag items between your inventory and the storage area that shows up.
You can also left-click items in storage to take them out.
Hold Ctrl to move 10 items at a time.
"}

var const/combat_info = \
{"
<u>Combat</u>
Tab - Toggle Combat Mode. A sword overlay appears on your character.
Left-click, E, or Space - Attack what's in the red circle.
Right-click or R - Hold to parry or block. Incoming damage is reduced.
"}

var control_info = {"[movement_info][interface_info][interaction_info][inventory_info][storage_info][combat_info]"}

mob
	player
		verb/AdminHelp(msg as text)
			set desc = "What do you need assistance with?"

			if(!can_admin_help)
				src << "Your Admin Help feature has been disabled."
				return

			if(!AdminsOnline.len)
				src << "Unfortunately there aren't any admins online \
						at the moment, please check the \
						<a href=http://hazordhu.com/forum>forums</a> \
						to see if your problem is mentioned."
				return

			var t = html_encode(msg)
			var link = {"<a href="?src=\ref[src]&action=adminhelp">[key]</a>"}
			AdminsOnline << "{ADMIN HELP} [link] ([src.name]): [t]"
			src << "Sent to Admins: [t]"

		verb/ooc(msg as text)
			if(!AtTitleScreen) map_focus()

			if(Mute)
				src << "<b>You're muted."
				return

			if(!ooc_on && !IsAdmin())
				src << "<b>OOC is disabled.</b>"
				return

			if(!can_ooc)
				src << "Your OOC access has been removed."
				return

			if(!ooc_listen)
				src << "You have your OOC turned off."
				return

			if(msg)
				msg = copytext(msg, 1, max_ooc_length)
				msg = replaceall(msg, "\n", " | ")

			if(!msg) return

			var out = "<font color=#332211>[OOC_Color?"<font color=[OOC_Color]>":](<b>[key]</b>): [html_encode(msg)]"

			var listeners[0]
			for(var/mob/player/m) if(m.ooc_listen) listeners += m
			listeners << out

			var log = "([current_time()])(OOC)[key]: [html_encode(msg)]"
			world.log << log
			ooclog += "[log]<br>"

		verb/who()
			src << output(null, "who.who_output")

			for(var/mob/player/m in (AdminsOnline | Players))
				if(!m.client) continue

				var display = m.key

				//	show m's name for him/herself
				if(isAdmin) display	= "([m.nameShown(m)]) [display]"
				if(m.isAdmin)
					if(m.ghost_logged)
						if(isAdmin)
							display = "(Ghost-Logged) [display]"
						else continue
					display += "-Admin-"
				if(m.isSubscriber) display += "-Subscriber-"
				if(m.isBYONDMember) display += "-BYOND Member-"
				if(isAdmin)
					var p = list2params(list(
						"src" = "\ref[src]",
						"action" = "checkid",
						"id" = m.client.computer_id))
					display += \
						{"(CID: <a href="?[p]">[m.client.computer_id]</a>)"}
				src << output(display, "who.who_output")

			winset(src,
				"who.players_online",
				"text=\"[Players.len] player\s online.\"")

			client.center_window("who")
			winshow(src, "who")

	verb/say(msg as text)
		map_focus()
		if(!msg) return

		var mob/player/p = is_player(src) && src
		if(p)
			if(!p.Made)
				return

			if(p.Mute)
				src << "You're muted."
				return

			if(p.drunk >= 50)
				if(prob(p.drunk - 20))
					p.yell(msg)
					return

		for(var/t in list("\n", "\t"))
			msg = replaceall(msg, t, " | ")

		if(client)
			var log = "([current_time()])([muzzle() && "Muffled "]Say)[src]: [html_encode(msg)]"
			world.log << html_decode(log)
			saylog += "[log]<br/>"

		if(muzzle()) msg = muffle(msg)

		status_overlay_remove("typing")
		status_overlay("chat", 10)
		act()

		if(!GodMode) Hood_Concealed = false

		for(var/mob/M in (hearers(src) | viewers(src)))
			if(GodMode)
				if(M.GodMode || M.see_invisible >= invisibility)
					M.Hear(msg, "Common", src)
			else if(M.GodMode)
				M.Hear(msg, "Common", src)
			else M.Hear(speak(msg), Speaking, src)

			if(istype(M, /mob/Animal/Ruff))
				var mob/Animal/Ruff/r = M
				r.Command(src, msg)

	humanoid
		verb/whisper(msg as text)
			map_focus()
			if(!msg) return

			var mob/player/p = is_player(src) && src
			if(istype(p))
				if(!p.Made)
					return

				if(p.Mute)
					src << "You're muted."
					return

				if(p.drunk >= 50)
					if(prob(p.drunk - 20))
						say(msg)
						return

			for(var/t in list("\n","\t"))
				msg = replaceall(msg, t, " | ")

			if(client)
				var log = "([current_time()])([muzzle() && "Muffled "]Whisper)[src]: [html_encode(msg)]"
				world.log << log
				saylog+="[log]<br/>"

			if(muzzle()) msg = muffle(msg)

			status_overlay_remove("typing")
			status_overlay("chat", 10)

			var textIcon = textIcon()
			for(var/mob/M in (hearers(src) | viewers(src)))
				if(M.GodMode || bounds_dist(src, M) <= WHISPER_RANGE)
					var mob/player/p1 = src
					var mob/player/p2 = M
					if(istype(p1) && p1.GodMode || istype(p2) && p2.GodMode)
						M.Hear(msg, "Common", src, "whisper")
					else M.Hear("[speak(msg)]", Speaking, src, "whisper")
				else M << "*[textIcon]<b>[M.nameShown(src)]</b> whispers something*"

		verb/yell(msg as text)
			map_focus()
			if(!msg) return

			var mob/player/p = src
			if(istype(p))
				if(!p.Made) return
				if(p.Mute) return aux_output("You're muted.")

			for(var/t in list("\n","\t")) msg = replaceall(msg, t, " | ")

			if(client)
				var log = "([current_time()])([muzzle() && "Muffled "]Yell)[src]: [html_encode(msg)]"
				world.log << log
				saylog += "[log]<br/>"

			if(muzzle()) msg = muffle(msg)

			status_overlay_remove("typing")
			status_overlay("chat", 10)
			act()

			if(!GodMode) Hood_Concealed = false

			for(var/mob/M in (hearers(src) | viewers(src)))
				if(M.GodMode || get_dist(src, M) <= 15)
					var mob/player/p1 = src
					var mob/player/p2 = M
					if(istype(p1) && p1.GodMode || istype(p2) && p2.GodMode)
						M.Hear(msg, "Common", src, "yell")
					else M.Hear(speak(msg), Speaking, src, "yell")
				else M << "You hear yelling from [dir2name(get_dir(M, src))]!"

client/Topic(href, href_list[], hsrc)
	..()
	if(href_list["action"] == "setName")
		var mob/player/p = mob
		p.setName(href_list["charID"])

proc/overlay_layer_quicksort(Overlay/a, Overlay/b)
	if(a.Layer() < b.Layer()) return -1
	if(a.Layer() > b.Layer()) return  1
	return 0

mob
	var tmp/flat_icon

	proc/reset_flat_icon()
		flat_icon = null

	proc/flat_icon()
		flat_icon = icon(icon, icon_state)
		return flat_icon

	humanoid/flat_icon()
		var icon/i = ..()
		if(hair_showing())
			i.Blend(
				icon(HairObj.icon, HairObj.icon_state),
				ICON_OVERLAY)

		var equip_images[0]
		for(var/obj/Item/item in Equipment())
			if(item == equipment["bag"]) continue
			if(!item.overlay) continue
			equip_images += item.overlay

		if(equip_images.len > 1)
			ls_quicksort_cmp(
				equip_images,
				/proc/overlay_layer_quicksort)

		for(var/Overlay/overlay in equip_images)
			i.Blend(
				icon(overlay.Icon(), overlay.IconState()),
				ICON_OVERLAY)

		if(rotated_angle)
			i.Turn(rotated_angle)

		flat_icon = i
		return i

	proc/textIcon()
		return "<BIG>\icon[flat_icon || flat_icon()]</BIG>"

	proc/nameShown()

	player
		proc/setName(ID)
			var setName = s_alert(
				"What name will you give [nameShown(ID)]?", "Give Name",
				default = nameShown(ID))

			if(setName)
				memNames[ID] = setName

		//	the name shown to strangers
		proc/stranger_name()
			return "[_Gender] [Race] Stranger"

		var memNames[]
		nameShown(mob/player/m)
			if(!m) return

			//	initialize
			if(!memNames)
				//	create new memory, including the player's own name
				memNames = new
				memNames[charID] = name

			//	m is a charID
			if(m in memNames)
				return memNames[m]

			if(ismob(m))
				if(!istype(m)) return m.name

				if(m.GodMode) return m.Ael

				//	wearing a hood conceals your identity
				if(m.Hood_Concealed) return "Hooded Figure"

				//	the player knows the other player
				if(m.charID in memNames)
					return memNames[m.charID]

				return m.stranger_name()


	proc/Hear(msg, Speaking, mob/Speaker, speakType)
		var mob/player/player_speaker = Speaker
		if(istype(player_speaker) && player_speaker.GodMode)
			if(player_speaker.invisibility > see_invisible && speakType != "yell")
				return
			src << "<b>[player_speaker.Ael]</b> says: [msg]"

		else
			var nameShown = nameShown(Speaker)
			if(istype(player_speaker) && !player_speaker.Hood_Concealed && player_speaker.charID)
				nameShown = "<a href=\"?charID=[player_speaker.charID];action=setName\">[html_encode(nameShown)]</a>"

			var textIcon = Speaker.textIcon()

			var translated_msg = racial_language(msg, Speaking)

			var start = "[textIcon]<b>[nameShown]</b>"
			var method = speakType ? "[speakType]s" : "says"
			var message = translated_msg
			if(speakType == "whisper")
				message = "<i>[message]</i>"
			else if(speakType == "yell")
				message = "<b>[message]</b>"

			var language = " in [Speaking]"
			if(Speaking == "Common")
				language = null

			src << "<font face='Tempus Sans ITC'>[start] [method][language]: [message]</font>"

			/*
			if(client)
				var image/mt = image('blank.dmi', Speaker, layer = 50)
				mt.pixel_y = 32
				mt.maptext = message
				client.images += mt
				spawn(30 * length(msg))
					client.images -= mt
			*/

proc/dir2name(n) switch(n)
	if(1)	return	"north"
	if(2)	return	"south"
	if(4)	return	"east"
	if(8)	return	"west"
	if(5)	return	"northeast"
	if(6)	return	"southeast"
	if(9)	return	"northwest"
	if(10)	return	"southwest"