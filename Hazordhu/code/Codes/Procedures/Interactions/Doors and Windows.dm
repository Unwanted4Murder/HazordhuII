proc/is_window(obj/Built/Windows/o) return istype(o)
proc/is_door(obj/Built/Doors/o) return istype(o)

mob
	proc/_use_door(obj/Built/Doors/door)
		if(!is_door(door))
			return FALSE

		if(has_key("shift"))
			return _knock_door(door)

		if(door.Locked && !door.interact_right(src))
			return aux_output("The [door] is locked.")

		else
			return door.toggle()

	/obj/Built/Doors
		var knockable = TRUE
		skin_door/knockable = FALSE

	proc/_knock_door(obj/Built/Doors/door) if(is_door(door))
		if(!door.knockable) return

		emote("knocks on the [lowertext(door)]")

		var knock_hearers[] = ohearers(door) - hearers(src)
		knock_hearers << "\icon[door] <b>You hear knocking on the [lowertext(door)]."

		for(var/mob/h in knock_hearers)
			h.hear_sound('code/Sounds/knock_knock.wav')

		return TRUE
