var const
	DRUNK_STATUS	=	10
	DRUNK_HICCUP	=	50
	DRUNK_SLUR		=	25
	DRUNK_PASSOUT	=	65
	DRUNK_THROWUP	=	75
	DRUNK_BLOOD		=	95
	DRUNK_DEATH		=	100

mob/proc/drunk_slur(t)
mob/player/drunk_slur(t)
	if(drunk >= DRUNK_SLUR && !GodMode)
		var char
		. = ""
		for(var/n in 1 to length(t))
			char = copytext(t, n, n+1)
			var cap = (uppertext(char) == char)
			var slur = (prob(75) && (lowertext(char) in slurred_speech)) ? slurred_speech[lowertext(char)] : char
			. += cap ? capitalize(slur) : lowertext(slur)
	else return t

mob/player
	var
		drunk = 0	/* percentage:
						10% get a bubble status overlay
						50% random hiccup emotes
						25% word slurring, falling off mounts
						65% random passing out
						75% throwing up
						95% throwing up blood
						100% dead						*/

		drunk_loop

	proc/drunk_loop()
		set waitfor = FALSE
		if(drunk_loop) return
		drunk_loop = TRUE
		var been_drunk
		while(drunk_loop)
			if(drunk >= DRUNK_DEATH && !GodMode)
				die("alcohol poisoning")
				break
			if(drunk >= DRUNK_BLOOD && !rand(0,400) && !KO && !GodMode)
				emote("throws up blood")
				new /obj/Blood (get_step(src, turn(dir, pick(0,-45,45))))
				Blood = max(0, Blood-rand(1,2))
				BloodCheck()
			if(drunk >= DRUNK_THROWUP && !rand(0,400) && !KO && !GodMode)
				emote("throws up")
				var obj/o = new /obj/Blood/Zombie (get_step(src, turn(dir, pick(0, -45, 45))))
				o.name = "Barf"
				lose_stamina(rand(1, 5))
				gain_hunger(rand(1, 3))
				gain_thirst(rand(3, 5))
			if(drunk >= DRUNK_PASSOUT) if(!rand(0,500) && !KO && !GodMode)
				emote("passes out")
				KO(rand(300,600))
			if(drunk >= 50) if(!rand(0,300) && !KO && !GodMode && mount)
				emote("falls off [gender==MALE ? "his":"her"] [mount]")
				mount.dismount(src)
			if(drunk >= DRUNK_HICCUP) if(!rand(0,300) && !KO && !GodMode)
				emote("hiccups")

			been_drunk += 10
			if(been_drunk >= MINUTE)
				been_drunk = 0
				drunk = max(0, drunk-1)
				if(!drunk) break
			sleep(10)
		drunk_loop = FALSE

	proc/strength_buff(n, time)
		StrengthBuff += n
		if(time) spawn(time) StrengthBuff -= n

obj/Item/Alchemy/Bottle
	Wine/drank(mob/player/m) if(istype(m))
		m.drunk = min(100, m.drunk + 2.5)
		m.Health = min(m.MaxHealth, m.Health + 5)
		if(m.drunk >= DRUNK_STATUS)
			m.status_overlay("drunk")
		if(!m.drunk_loop) m.drunk_loop()

	Beer/drank(mob/player/m) if(istype(m))
		m.drunk = min(100, m.drunk + 5)
		if(m.drunk >= DRUNK_STATUS)
			m.status_overlay("drunk")
		if(!m.drunk_loop) spawn m.drunk_loop()
		m.strength_buff(5, MINUTE)

var slurred_speech = list(
	"s"	=	"sh",
	"o"	=	"ur",
	"g"	=	"gh",
	"k"	=	"g",
	"y"	=	"eh",
	"a"	=	"ar",
	"e"	=	"er",
	"t"	=	"d",
	"f"	=	"sh",
	"h"	=	"")