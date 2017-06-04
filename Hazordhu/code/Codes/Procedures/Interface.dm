client
	//	Centers a window in the screen.
	proc/center_window(id) if(winexists(src, id))
		var main_size[] = text2dim(winget(src, DMF_WINDOW, "size"))
		var sub_size[] = text2dim(winget(src, id, "size"))
		var sub_pos[] = vec2_divide(vec2_sub(main_size, sub_size), 2)
		var origin[] = text2dim(winget(src, DMF_MAP, "pos"), ",")
		winset(src, id, "pos=[origin[1] + sub_pos[1]],[origin[2] + sub_pos[2]]")

mob
	proc/s_alert()
	proc/s_alert_bg()
		set waitfor = FALSE
		return s_alert(arglist(args))

	proc/medalMsg()
	proc/map_focus()

mob/player
	map_focus()
		winset(src, DMF_MAP, "focus=true")

	medalMsg(medal)
		set waitfor = FALSE
		if(world.SetMedal(medal, src))
			src << "<font color = [rgb(0,0,255)]>You've gained the '[medal]' medal!"

	s_alert(message, title, button1, button2, button3, default)
		var buttons[0]
		if(button1) buttons += button1
		if(button2) buttons += button2
		if(button3) buttons += button3
		switch(buttons.len)
			if(1) return alert(src, message, title, buttons[1])
			if(2) return alert(src, message, title, buttons[1], buttons[2])
			if(3) return alert(src, message, title, buttons[1], buttons[2], buttons[3])
			else return input(src, message, title, default)

	var ooc_toggles
	verb/ooc_toggle()
		if(ooc_toggles >= 6)
			src << "<b>You can only toggle OOC 3 times a minute.</b>"
			return

		ooc_toggles ++
		spawn(600)
			ooc_toggles --

		if(!ooc_listen)
			winset(src, "ooc_button", "is-disabled=false")
			world << "[key] has joined the OOC Channel."
			ooc_listen = TRUE

		else
			winset(src, "ooc_button", "is-disabled=true")
			world << "[key] has left the OOC Channel."
			ooc_listen = FALSE
