var const/TOS_PATH = "Data/tos.sav"

world/New()
	loadTOS()
	..()

world/Del()
	saveTOS()
	..()

proc/saveTOS()
	fdel(TOS_PATH)
	if(!TOS_List.len) return
	new /savefile (TOS_PATH) << TOS_List

proc/loadTOS()
	if(!fexists(TOS_PATH)) return
	var savefile/tos = new (TOS_PATH)
	tos >> TOS_List

mob/player
	verb/terms()
		set hidden = TRUE
		winshow(src, "tos", FALSE)
		TOS_List.Add(key)

	proc/LoginCheck()
		var days = DevelopmentServer || client.CheckPassport(SUB_PASSPORT)
		if(days)
			if(DevelopmentServer)
				aux_output("You have subscriber status inside this development server.")
			else
				if(days == -1)
					aux_output("You're a lifetime subscriber!")
				else aux_output("You're a subscriber for [days] more day\s!")
			isSubscriber = TRUE
			if(!SubBens)
				MaxHealth	+=	10
				Health		+=	10

				Stamina		+=	10
				MaxStamina	+=	10

				Strength	+=	5
				Item_Limit	=	20
				SubBens		=	TRUE

		else if(SubBens)
			MaxHealth	-=	10
			Health		-=	10
			Stamina		-=	10
			MaxStamina	-=	10
			Strength	-=	5
			Item_Limit	=	15
			SubBens		=	FALSE

		if(client.IsByondMember())
			aux_output("You are a BYOND member!")
			isBYONDMember	=	TRUE
			if(!MemBens)
				MaxHealth	+=	10
				Health		+=	10

				Stamina		+=	10
				MaxStamina	+=	10

				Strength	+=	5
				Item_Limit	=	20
				MemBens		=	TRUE

		else if(MemBens)
			MaxHealth	-=	10
			Health		-=	10

			Stamina		-=	10
			MaxStamina	-=	10

			Strength	-=	5
			Item_Limit	=	15

		//	this is to update the number of items text
		InventoryGrid()
