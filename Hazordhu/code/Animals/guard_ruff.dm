
obj/Item/Tailoring/Collar
	icon = 'code/Hunting/Collar.dmi'
	use(mob/player/m) if(loc == m)
		var mob/Animal/Ruff/r = locate() in m.front()
		if(!r) return ..()

		if(locate(type) in r)
			return m.aux_output("[r] already has a collar on.")

		m.emote("tries to put a collar on [r]")

		r.Locked = 0
		m._do_work(30)
		r.Locked = 0

		if(get_dist(m, r) < 2)
			if(prob(50))
				m.emote("puts a collar on [r]")
				r.owner = m.charID
				r.obey(m)
				r.mood = "defensive"
				var obj/Item/o = Drop(m)
				o.Get(r)

				overlayo = icon(icon, "on")
				r.overlays += overlayo

				var new_name = input(m, "Name your [r.gender] Ruff", r.name) as text
				r.name = new_name || "Ruff"

			else
				m.emote("fails to put a collar on [r]")
				step_away(r, m)

var looper/RuffAILoop = new ("RuffAI")

mob/Animal/Ruff
	var owner
	var friends[0]
	var commanders[0]

	interact_right(mob/player/m)
		if(owner != m.charID)
			var ti = textIcon()
			for(var/mob/M in ohearers(src)) M <<"*[ti] <b>[src]</b> growls at [M.nameShown(m)].*"
			return

		if(on_boat)
			return m.aux_output("[src] is on a boat right now.")

		var obj/Item/Tailoring/Collar/c = locate() in src
		if(c)
			var obj/Item/o = c.Drop(src)
			o.Get(m)
			m.emote("takes the collar off of [src]")
			Command = null
			owner = null
			commanders = null
			mood = "aggressive"
			name = "Ruff"
			overlays = null

	New()
		set waitfor = FALSE
		..()
		sleep
		if(owner)
			mood = "defensive"

		if(icon_state == "sit")
			SetCommand("sit")

	Move()
		. = ..()
		if(. && icon_state == "sit")
			icon_state = ""

	can_wander() return !Command

	proc/emote_confusion()
		emote("tilts [gender == MALE ? "his" : "her"] head in confusion")

	proc/befriend(mob/player/to_befriend)
		friends |= to_befriend.charID

	proc/unfriend(mob/player/to_unfriend)
		if(to_unfriend.charID == owner) return
		friends -= to_unfriend.charID
		commanders -= to_unfriend.charID

	proc/obey(mob/player/to_obey)
		commanders |= to_obey.charID
		befriend(to_obey)

	proc/disobey(mob/player/to_disobey)
		if(to_disobey.charID == owner) return
		commanders -= to_disobey.charID

	proc/obeys(mob/player/m)
		return m.charID in commanders

	proc/is_friend(mob/player/m)
		return istype(m) && (m.charID in friends)

	proc/bark() emote("barks")

	proc/growl(mob/target)
		var textIcon = textIcon()
		for(var/mob/m in ohearers(src))
			m << "*[textIcon] <b>[src]</b> growls at [m.nameShown(target)]*"

	proc/sit()
		Command = "Stay"
		icon_state = "sit"

	proc/Command(mob/player/m, msg)
		set waitfor = FALSE
		if(m == src) return
		sleep randn(5, 10)
		var tmp/command[0]
		var words[0]
		for(var/t in words2list(msg)) words += lowertext(t)

		msg = list2words(words)
		var Name[0]
		for(var/t in words2list(name)) Name += lowertext(t)

		var wordsInName = Name.len

		var nameToFind = ""
		for(var/n in 1 to wordsInName) nameToFind += "[Name[n]] "
		nameToFind = copytext(nameToFind, 1, length(nameToFind))

		if(!findtext(msg, nameToFind)) return

		//	generic word list to be ignored (incomplete)
		var global/generic_word_list[] = list("some","a","an","the","few","couple","several","and","more","that")
		for(var/t in words.Copy() - Name)
			if(t in generic_word_list) continue
			command += lowertext(t)

		if(!obeys(m))
			growl(m)
			return

		if(!command.len)
			emote_confusion()

		if(on_boat)
			var/obj/Built/Boat/B = on_boat
			B.passengers -= src
			on_boat = null
			pixel_x = 0
			pixel_y = 0

		if(command.len >= 1)
			if(command.len == 1)
				if(command[1] == "follow")
					return emote_confusion()

			if(command.len >= 1)
				switch(command[1])
					if("come") return SetCommand("come", m.loc, commander = m)
					if("stop") return SetCommand()
					if("sit", "stay") return SetCommand("sit", commander = m)

					if("peace") return SetCommand("peace")

					if("guard", "attack", "kill")
						if(command.len < 2)
							SetCommand("guard", commander = m)
							return bark()

					if("good")
						if(command.len >= 2)
							if(gender == MALE && command[2] == "girl" || gender == FEMALE && command[2] == "boy")
								return emote_confusion()

						emote("wags [gender == MALE ? "his" : "her"] tail")

			if(command.len >= 2)
				switch(command[1])
					if("follow")
						var mob/to_follow = WordAI.getMobByName(src, m, list2words(command.Copy(2)))
						if(!to_follow) return emote_confusion()
						SetCommand("follow", to_follow, commander = m)

					if("obey")
						var mob/to_obey = command[2] != "me" && WordAI.getMobByName(src, m, list2words(command.Copy(2)))
						if(!to_obey) return emote_confusion()
						obey(to_obey)

					if("befriend")
						var mob/to_befriend = command[2] != "me" && WordAI.getMobByName(src, m, list2words(command.Copy(2)))
						if(!to_befriend) return emote_confusion()
						befriend(to_befriend)

					if("unfriend")
						var mob/to_unfriend = command[2] != "me" && WordAI.getMobByName(src, m, list2words(command.Copy(2)))
						if(!to_unfriend) return emote_confusion()
						if(is_player(to_unfriend) && to_unfriend:charID == owner) return growl(m)
						unfriend(to_unfriend)

					if("ignore")
						var mob/to_disobey = command[2] != "me" && WordAI.getMobByName(src, m, list2words(command.Copy(2)))
						if(!to_disobey) return emote_confusion()
						if(is_player(to_disobey) && to_disobey:charID == owner) return growl(m)
						disobey(to_disobey)

					if("attack", "kill", "sic", "rape")
						var mob/target = command[2] != "me" && WordAI.getMobByName(src, m, list2words(command.Copy(2)))
						if(!target) return emote_confusion()

						if(is_friend(target)) return growl(target)

						SetCommand("attack", target, commander = m)

	var tmp/Command				//	what the command is
	var tmp/mob/Commander		//	person who gave the command
	var tmp/atom/CommandTarget	//	what the command is targeting

	var tmp/LastCommand				//	previous command
	var tmp/mob/LastCommander		//	previous commander
	var tmp/atom/LastCommandTarget	//	previous command's target

	var tmp/attack_stage

	proc/RuffAI()
		set waitfor = FALSE
		walk(src, 0)
		if(boat) return
		switch(Command)
			if("sit")
				icon_state = "sit"
				if(Commander)
					dir = get_dir(src, Commander)

			if("follow")
				if(CommandTarget)
					var dist = bounds_dist(src, CommandTarget)
					if(dist > 8) step_to(src, CommandTarget)
					else if(dist > 32) step_to(src, CommandTarget, 0, step_size * 2)
					else if(dist < 4) step_away(src, CommandTarget, 0, 1)
				else SetCommand()

			if("come")
				if(!step_to(src, CommandTarget))
					SetCommand()

			if("attack")
				if(!CommandTarget)
					SetCommand()

				else
					sleep
					var mob/target = CommandTarget

					switch(attack_stage)
						if(1)
							attack_stage = -1
							if(ai_warn(target))
								attack_stage = 2
							else attack_stage = 0

						if(2)
							attack_stage = -1
							if(ai_charge(target))
								attack_stage = 3
							else attack_stage = 0

						if(3)
							attack_stage = -1
							if(ai_attack(target) && (!target || target.Dead || target.Health <= 0))
								//	If the target is dead, stop
								attack_stage = 0

							//	Otherwise, keep attacking
							else attack_stage = 1

						if(0)
							if(LastCommand == "follow")
								SetCommand(LastCommand, LastCommandTarget)

			else SetCommand()

	proc/SetCommand(command, target, commander)
		if(Command == command && CommandTarget == target && Commander == commander) return

		LastCommand = Command
		LastCommandTarget = CommandTarget
		LastCommander = Commander

		Command = command
		CommandTarget = target
		Commander = commander

		if(Command)
			RuffAILoop.add(src)
		else RuffAILoop.remove(src)

		switch(Command)
			if("follow") for(var/mob/m in ohearers(src)) m << "*[textIcon()] <b>[src]</b> scurries after [m.nameShown(CommandTarget)]*"
			if("attack") attack_stage = 1


var WordAI/WordAI = new
WordAI
	proc/getMobByName(mob/source, mob/speaker, name)
		if(cmptext(name, "me"))
			return speaker

		for(var/mob/m in ohearers(source))
			if(cmptext(speaker.nameShown(m), name))
				return m