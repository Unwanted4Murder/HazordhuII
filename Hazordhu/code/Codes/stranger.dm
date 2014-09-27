var const
	CHAR_WINDOW = "character_window"
	CHAR_NAME = "character_name"
	CHAR_DESC = "character_desc"

var looper/char_desc_loop = new ("desc tick", 10)

mob/player
	var tmp/mob/player/viewing_char
	var char_desc = ""

	proc/view_player(mob/player/p)
		viewing_char = p
		winset(src,  CHAR_NAME, "text=[url_encode(nameShown(p))]")
		winset(src,  CHAR_DESC, "text=[url_encode(p.char_desc)]")
		winshow(src, CHAR_WINDOW)
		char_desc_loop.add(src)

	proc/desc_tick()
		if(!viewing_char || "false" == winget(src, CHAR_WINDOW, "is-visible"))
			char_desc_loop.remove(src)
			winshow(src, CHAR_WINDOW, 0)

		var name = winget(src, CHAR_NAME, "text")

		if(!viewing_char)
			return

		if(name != nameShown(viewing_char))
			memNames[viewing_char.charID] = name || viewing_char.stranger_name()

		if(src == viewing_char)
			char_desc = winget(src, CHAR_DESC, "text")

		else
			var desc = winget(src, CHAR_DESC, "text")
			if(desc != viewing_char.char_desc)
				winset(src, CHAR_DESC, "text=[url_encode(viewing_char.char_desc)]")

	rightClick(mob/player/p)
		if(!Hood_Concealed && istype(p))
			p.view_player(src)
		..()

	verb/close_char_window()
		set hidden = TRUE
		viewing_char = null