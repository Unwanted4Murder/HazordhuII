mob
	var
		Hair
		HairColor
		Naturalhair

	proc/Gethair()
		Remhair()

		if(hair_showing())
			var path = text2path("/obj/Hair/[Hair]")
			if(ispath(path))
				HairObj				=	new path
				HairObj.layer		=	FLOAT_LAYER-1
				if(HairColor)
					HairObj.icon	+=	HairColor
				overlays			+=	HairObj

	proc/Remhair()
		overlays -= HairObj
//		overlays -= rotated_hair

obj/Hair
	layer = FLOAT_LAYER - 1
	None/icon = 'code/Mobs/Hair/Hair.dmi'
	Long/icon = 'code/Mobs/Hair/Long.dmi'
	Short/icon = 'code/Mobs/Hair/Short.dmi'
	Mohawk/icon = 'code/Mobs/Hair/Mohawk.dmi'
	Tail/icon = 'code/Mobs/Hair/Tail.dmi'
	Matted/icon = 'code/Mobs/Hair/Matted.dmi'
	Ponytail/icon = 'code/Mobs/Hair/Ponytail.dmi'
	Curly/icon = 'code/Mobs/Hair/Curly.dmi'
	LongCurly/icon = 'code/Mobs/Hair/Long_Curly.dmi'
	Dreadlocks/icon = 'code/Mobs/Hair/Rasta.dmi'