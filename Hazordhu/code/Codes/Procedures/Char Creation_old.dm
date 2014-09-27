/*
CharCreation		window ID
nameInput			input containing the user's name
heritageGrid		grid containing heritage choices
heritageInfo		output containing information about chosen heritage
hairGrid			grid containing hair choices
hairSelected		label containing current selection
finishCharCreate	finish button
*/

mob/player/var/creatingChar

mob/player/proc/newCharacter()
	if(fexists(save_path()))
		if(s_alert("You already have a character. Creating a new one will overwrite it. Continue?", "New Character","Yes","No")=="No")
			return
		else
			// REMAKING!
			// Handle group ownership!
			var group/g
			for(g in groups)
		//		for(var/_key in g.members) if(g.members[_key] == 1) world << "Leader of [g] is [_key]!"
				if(key in g.members)
					if(g.members[key] == 1) break
					else
						g.members -= key
			if(g)
				CHOOSE
				var choice = (g.members.len == 1 ? (s_alert("You are the only member of your group. It will be disbanded.","Disbanded","OK") && "Disband") : s_alert("You are the leader of the group, \"[g.name].\" Do you want to disband it or transfer ownership?", "Group Leader", "Disband", "Transfer"))
				switch(choice)
					if("Transfer")
						TRANSFER
						var/totransfer = input("Who will you transfer group ownership to?") as null|anything in g.members-key
						if(totransfer)
							if("Yes" == s_alert("Are you sure you want [totransfer] to own your group?", "Transfer Ownership", "No", "Yes"))
								g.members[totransfer] = 1
								g.members -= key

								var mob/m
								for(m in Players) if(m.key == totransfer) break
								if(m) spawn m.s_alert("You are now the leader of your group.","Ownership Transferred","OK")
							else goto TRANSFER
						else goto CHOOSE
					else
						for(var/mob/m in Players) if(m.key in g.members)
							spawn m.s_alert("The group has been disbanded.","Disbanded","OK")
						del g

			fdel(save_path())
	charCreation()
	return 1


mob/player
	var/charCreator/charCreator
	proc
		charCreation()
			creatingChar = TRUE
			charCreator = new

			winset(src, "nameInput", "text=[key]")
			heritageGrid()
			hairGrid()

			client.center_window("char_creation")
			winshow(src, "char_creation")

		heritageGrid()
			var/h
			var/list/Hlist = list("Southshores","Plainsman","Northern","Chiprock", "Warcry","Stonehammer","Windhowl")
			for(var/t in Hlist)
				var/obj/heritageType/a = new
				a.name = t
				a.icon = 'code/Mobs/Human/m_tan.dmi'
				switch(t)
					if("Southshores")
						a.icon = 'code/Mobs/Human/m_black.dmi'
						a.desc = "You are of the Southshores bloodline.  Your people are from the southern coast of the Mainland.<br><u><b>Stats:</b></u><br>Health: <b>130</b><br>Stamina: <b>120</b><br>Strength: <b>10</b>"
					if("Plainsman")
						a.icon = 'code/Mobs/Human/m_tan.dmi'
						a.desc = "You are a plainsman.  Your people have lived on the open plains of the land since time immemorable.<br><u><b>Stats:</b></u><br>Health: <b>100</b><br>Stamina: <b>85</b><br>Strength: <b>20</b>"
					if("Northern")
						a.icon = 'code/Mobs/Human/m_white.dmi'
						a.desc = "You are a Northerner.  You and your kin hail from the snowy peaks of the north.<br><u><b>Stats:</b></u><br>Health: <b>90</b><br>Stamina: <b>145</b><br>Strength: <b>15</b>"
					if("Chiprock")
						a.icon = 'code/Mobs/Human/m_pale.dmi'
						a.desc = "You are from the Chiprock clan.  Your ancestors were noble warriors who have recently emerged from the underground.<br><u><b>Stats:</b></u><br>Health: <b>85</b><br>Stamina: <b>70</b><br>Strength: <b>30</b>"
					if("Warcry")
						a.icon = 'code/Mobs/Orc/m_warcry.dmi'
						a.desc = "You are a member of Clan Warcry.  Once the most powerful Orc clan in Hazordhu.<br><u><b>Stats:</b></u><br>Health: <b>130</b><br>Stamina: <b>40</b><br>Strength: <b>25</b>"
					if("Windhowl")
						a.icon = 'code/Mobs/Orc/m_windhowl.dmi'
						a.desc = "You are a member of Clan Windhowl.  Your ancestors were revered as mighty hunters.<br><u><b>Stats:</b></u><br>Health: <b>185</b><br>Stamina: <b>50</b><br>Strength: <b>20</b>"
					if("Stonehammer")
						a.icon = 'code/Mobs/Orc/m_stonehammer.dmi'
						a.desc = "You are a member of Clan Stonehammer.  You live for combat, and yearn for an honorable death.<br><u><b>Stats:</b></u><br>Health: <b>140</b><br>Stamina: <b>20</b><br>Strength: <b>35</b>"
				charCreator.heritages += a
				src << output(a,"heritageGrid:1,[++h]")

		hairGrid()
			var/h = 0
			for(var/t in Hairs)
				var obj/hairType/a = new
				a.name = t
				a.icon = Hairs[t]
				charCreator.hairs += a
				src << output(a,"hairGrid:1,[++h]")


mob/player/verb/finishCharCreate()
	set hidden = 1
	if(!charCreator) return

	var newname = winget(src,"nameInput","text")
	if(!newname)
		s_alert("You need a name!", "Name Required", "OK")
		return

	var obj/newheritage = charCreator.heritageSelected
	if(!newheritage)
		s_alert("You need to choose a heritage!", "Heritage Required","OK")
		return
	var obj/newhair = charCreator.hairSelected
	if(!newhair)
		s_alert("You need to choose a hair type!", "Hair Type Required","OK")
		return

	if(winget(src, "gendermale", "is-checked") == "true")
		gender = "male"
	else gender = "female"

	Heritage	=	newheritage.name
	Speaking	=	"Common"

	switch(Heritage)
		if("Southshores")
			MaxHealth	=	130
			MaxStamina	=	120
			Strength	=	10
			Race = "Human"
		if("Plainsman")
			MaxHealth	=	100
			MaxStamina	=	85
			Strength	=	20
			Race = "Human"
		if("Northern")
			MaxHealth	=	90
			MaxStamina	=	145
			Strength	=	15
			Race = "Human"
		if("Chiprock")
			MaxHealth	=	85
			MaxStamina	=	70
			Strength	=	25
			Race = "Human"

		if("Warcry")
			MaxHealth	=	140
			MaxStamina	=	125
			Strength	=	30
			Race = "Orc"
		if("Stonehammer")
			MaxHealth	=	140
			MaxStamina	=	95
			Strength	=	35
			Race = "Orc"
		if("Windhowl")
			MaxHealth = 100
			MaxStamina = 160
			Strength = 15
			Race = "Orc"

	Languages += native_language()

	HeritageIcon()

	Health = MaxHealth
	Stamina = MaxStamina

	Hair = newhair.name
	HairColor = charCreator.hairColor
	Gethair()

	name = copytext(html_encode(newname), 1, 20)

	del charCreator
	creatingChar = 0

	winshow(src, "char_creation", FALSE)

//	call(src, "bux")(0)

	src << "<i>You are now in the tutorial area. There are NPCs that you can talk to for some information about the game.</i>"
	src << "<B><I>Hit E while standing on the Rune Circle at the end of this path to leave this area.</I></B>"

	Respawn(1)

	contents = newlist(	/obj/Item/Tools/Hatchet,
						/obj/Item/Tools/Knife,
						/obj/Item/Tools/Tongs)

	equip(new /obj/Item/Clothing/Pants/Loincloth (src))
	equip(new /obj/Item/Clothing/Back/Fur_Cape (src))
	equip(new /obj/Item/Clothing/Feet/Fur_Boots (src))
	if(gender == FEMALE)
		equip(new /obj/Item/Clothing/Shirt/Loincloth_Top (src))

	moon = get_moon()
	src << "Your birthmoon is Moon [moon] of the celestial Aeon [get_aeon()]."
	charID = string()

charCreator
	var
		list/heritages = list()
		heritageSelected

		list/hairs = list()
		hairSelected
		hairColor

obj/heritageType
	Click()
		var mob/player/p = usr
		p.charCreator.heritageSelected = src
		p << output(null, "heritageInfo")
		p << output(desc, "heritageInfo")

obj/hairType
	Click()
		var mob/player/p = usr
		p.charCreator.hairSelected = src
		winset(p, "hairSelected", "text=\"Selected: [name]\"")

mob/player/verb/hairColor()
	set hidden = TRUE
	if(creatingChar && charCreator)
		charCreator.hairColor = input("What color is your hair?", "Hair Color")as color
		winset(src, "hairColorButton", "background-color=[charCreator.hairColor]")