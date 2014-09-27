mob
	verb/emote(msg as text)
		var mob/player/p = is_player(src) && src
		if(p && p.Mute)
			src << "You're muted."
			return
		if(!msg) return

		if(p)
			p.emoting = FALSE
			p.status_overlay_remove("emote")
			p.status_overlay("emote", 10)

		world.log << "([current_time()])(Emote)*[p && GodMode? p.Ael : name] [html_encode(msg)]*"
		saylog += "([current_time()])(Emote)*[p && GodMode? p.Ael : name] [html_encode(msg)]*<br>"

		var textIcon = textIcon()
		for(var/mob/player/M in (hearers(src) | viewers(src)))
			M << "*[textIcon] [p && p.GodMode ? p.Ael : M.nameShown(src)] [msg]*"

	player
		verb/RP(msg as message)
			if(Mute)
				src << "You're muted."
				return

			msg = html_encode(msg)

			world.log << "([current_time()])(RP)<b>[GodMode? Ael : name]</b>\n[html_encode(msg)]"
			saylog += "([current_time()])(RP)<b>[GodMode? Ael : name]</b><br>[html_encode(msg)]<br>"

			emoting = FALSE
			status_overlay_remove("emote")
			status_overlay("emote", 10)
			var textIcon = textIcon()
			for(var/mob/player/p in (hearers(src) | viewers(src)))
				p << "<b>[textIcon] <u>[GodMode ? Ael : p.nameShown(src)]</u>\n[msg]</b>"