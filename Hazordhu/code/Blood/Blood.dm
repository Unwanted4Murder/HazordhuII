obj
	Blood
		icon = 'code/Blood/Blood.dmi'
		icon_state = "1"
		New()
			set waitfor = FALSE
			..()
			icon_state = "[rand(1, 4)]"
			pixel_x = rand(-4, 4)
			pixel_y = rand(-4, 4)
			sleep 600
			set_loc()

		Zombie
			New()
				..()
				icon = pick(zombie_blood_icons())

var zombie_blood_icons[]
proc/zombie_blood_icons()
	if(!zombie_blood_icons)
		zombie_blood_icons = new
		var color = rgb(0, 160, 0)
		for(var/n in 1 to 4)
			var icon/i = icon('code/Blood/Blood.dmi', "[n]")
			i.Blend(color)
			zombie_blood_icons += i
	return zombie_blood_icons