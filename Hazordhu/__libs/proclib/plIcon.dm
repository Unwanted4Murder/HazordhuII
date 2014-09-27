/*

	Kaiochao's ProcLib - Icons

	List o' Variables
		tile_size[]		list(tile_width(), tile_height())
		tile_width()		Tile width grabbed from world.icon_size
		tile_height()		Tile height grabbed from world.icon_size

	List o' Functions
		blank_icon		=>	A blank icon with a given width and height
		bearing2state	=>	An icon state to be used with a rotated icon, given a bearing and angle delta (default 1)
		angle2state		=>	An icon state to be used with a rotated icon, given an angle and angle delta (default 1)
		rotate_icon		=>	Takes an icon (file, state) and returns an icon with icon_states from 0 to 360 (bearings).
							You can also provide the angle delta, which changes the number of icon_states in the result.
							You can also choose to use a kind of smoothing to rotated icons; set 'aa' to TRUE in the arguments.

*/

//#include <Forum_account/Text>

proc
	angle2state(angle, step = 1)
		return "[clamp_angle(round(angle, step))]"

	//	creates an icon of given size ('blank.dmi' is an icon with one empty 1x1 state)
	blank_icon(width, height)
		var icon/i = new ('blank.dmi')
		if(width || height) i.Scale(width || height, height || width)
		return i

	//	creates an /icon object with 360 states of rotation
	rotate_icon(file, state, step = 1, aa = FALSE)
		var icon/base = icon(file, state)

		var w, h, w2, h2
		if(aa)
			aa ++
			w = base.Width()
			w2 = w * aa
			h = base.Height()
			h2 = h * aa

		var icon/result = icon(base), icon/temp

		for(var/angle in 0 to 360 step step)
			if(angle == 0  ) continue
			if(angle == 360) continue

			temp = icon(base)

			if(aa) temp.Scale(w2, h2)
			temp.Turn(angle)
			if(aa) temp.Scale(w,   h)

			result.Insert(temp, "[angle]")

		return result