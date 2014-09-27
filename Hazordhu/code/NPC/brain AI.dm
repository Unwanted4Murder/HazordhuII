
mob/NPC
	var brain/brain

var/const
	STANCE_PASSIVE = 0		//	retaliate
	STANCE_DEFENSIVE = 1	//	block
	STANCE_AGGRESSIVE = 2	//	attack

	ATTACK_NONE = 0
	ATTACK_RACES = 1		//	members of other races are valid targets
	ATTACK_GROUPS = 2		//	members other groups are valid targets

#define	target_flag_list	list("other races", "other groups")
#define	stances_list		list("aggressive", "passive", "defensive")
#define text2dir_list		list("north"=1, "south"=2, "east"=4, "west"=8, "northeast"=5, "northwest"=9, "southeast"=6, "southwest"=10)

proc/text2dir(t) return text2dir_list[ckey(t)]

brain
	var
		const
			PASSIVE		=	0	//	retaliate
			DEFENSIVE	=	1	//	block
			AGGRESSIVE	=	2	//	attack

			NONE		=	0
			RACES		=	1	//	members of other races are valid targets
			GROUPS		=	2	//	members other groups are valid targets

		stance			=	STANCE_PASSIVE
		target_flag		=	ATTACK_NONE

		mob/body

		commands[0]

	New(mob/_body)
		body = _body
		wander()

	//	wandering around
	var
		tmp
			turf/wander_to
	proc
		can_wander()
			if(!body.loc) return
			return 1

		wander()
			set waitfor = FALSE
			for()
				if(can_wander())
					wander_to = null

					var turfs[0]

					for(var/turf/t in oview(body.loc))
						turfs += t

					if(turfs.len)
						wander_to = pick(turfs)

						if(wander_to)
							walk(body, 0)
							walk_to(body, wander_to)

				sleep rand(30, 60)


	//	speech parsing
	proc
		do_command(command, target, commander)

		is_commander(commander)
			commander = ckey(commander)
			return commander == "kaiochao"

		hear(mob/speaker, msg)
			if(!body) return

			if(speaker == body) return

			msg = ckey(msg)

			if(findtext(msg, ckey(body.name)) == 1)	//	message starts with the NPC's name
				if(!is_commander(speaker.name))
					body.Say("I don't take orders from you.")
					return

				msg = copytext(msg, length(ckey(body.name)) + 1)

				for(var/command in commands)
					if(findtext(msg, ckey(command)) == 1)	//	the message after the NPC's name is the command
						msg = copytext(msg, length(ckey(command)) + 1)

						if(istype(commands[command], /list))
							for(var/target in commands[command])
								if(findtext(msg, ckey(target)) == 1)	//	the message after the command is the target

									do_command(command, target, speaker.name)
									return

						else
							do_command(command,,speaker.name)
							return

				body.Say(pick("What do you want?", "Hmm?"))

	guard
		commands = list(
			"step"			=	text2dir_list,
			"face"			=	text2dir_list,
			"attack"		=	target_flag_list,
			"don't attack"	=	target_flag_list,
			"be"			=	stances_list,
			"report"
			)

		do_command(command, target, commander) spawn(1)
			if(!body) return

			if(!is_commander(commander))
				body.Say("I don't take orders from you.")

			switch(command)
				if("step")
					var d = text2dir(target)
					if(!d) body.Say("What direction?")

					if(!step(body, d)) body.Say(pick("I can't.", "Something went wrong."))

				if("face")
					var d = text2dir(target)
					if(!d) body.Say("What direction?")
					body.dir = d

				if("attack")
					body.Say("Yes, sir.")
					switch(target)
						if("other races")	target_flag |= ATTACK_RACES
						if("other groups")	target_flag |= ATTACK_GROUPS

				if("don't attack")
					body.Say("Yes, sir.")
					switch(target)
						if("other races")	target_flag &= ~ATTACK_RACES
						if("other groups")	target_flag &= ~ATTACK_GROUPS

				if("be")
					body.Say("Yes, sir.")
					switch(target)
						if("aggressive")	stance = STANCE_AGGRESSIVE
						if("passive")		stance = STANCE_PASSIVE
						if("defensive")		stance = STANCE_DEFENSIVE

				if("report")
					var reply = "My name is [body.name]. "
					switch(stance)
						if(STANCE_AGGRESSIVE)		reply += "I am ready to attack. "
						if(STANCE_PASSIVE)			reply += "I will only retaliate. "
						if(STANCE_DEFENSIVE)		reply += "I am on guard. "
					if(target_flag & ATTACK_RACES)	reply += "I am attacking members of a different race. "
					if(target_flag & ATTACK_GROUPS)	reply += "I am attacking members of a different group. "
					body.Say(reply)
				else body.Say(pick("Huh?", "What?", "I don't understand.", "What did you say?"))