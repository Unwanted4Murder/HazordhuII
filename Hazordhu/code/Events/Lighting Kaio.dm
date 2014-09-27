atom
	var tmp/light_source/light
	proc/set_light()
	proc/changed_opacity()

light_source
#if LIGHTING

//	#define LIGHT_DEBUG
#ifdef LIGHT_DEBUG
	#warning - Lighting debug is on!
	#define light_debug(t) world << t
#else
	#define light_debug(t) . = .
#endif

var tmp/client_views[0]

proc/client_views()
	client_views = new
	for(var/client/c) if(c.virtual_turf) client_views |= c.virtual_turf.nearby_turfs("[c.view_size[1]+2]x[c.view_size[2]+2]")
	return client_views

var looper/lighting_loop/Lighting = new

looper/lighting_loop
	var ambient_light
	proc/time2light()
		//return (1 + cos(world.time * 6)) / 2

		var hour = text2num(time2text(world.timeofday, "hh"))
		return (1 - cos(hour * 15)) / 2

	tick()
		..()
		if(world.time > 1)
			var new_ambient = time2light()
			if(round(lerp(0, 230, ambient_light)) != round(lerp(0, 230, new_ambient)))
				ambient_light = new_ambient

			client_views()

			for(var/light_source/s) s.tick()
			for(var/turf/t in client_views)
				var shading/s = t.shading || new (t)
				s.tick()

//	to be attached to atoms
light_source
	parent_type = /mob
	invisibility = 100
	icon = 'debug light source.dmi'
	density = FALSE
	season_updates = FALSE

	var tmp
		atom/anchor
		atom/movable/mover
		stale = TRUE
		effect[0]
		radius = 3
		intensity = 1
		visible

	New(atom/o, radius = radius, intensity = intensity, visible = TRUE)
		if(!o) return
		o.light = src
		anchor = o

		if(istype(o, /atom/movable))
			mover = o
			set_loc(mover.loc, mover.step_x, mover.step_y)
		else set_loc(anchor)

		if(!isnull(radius))		set_radius(radius)
		if(!isnull(intensity))	set_intensity(intensity)
		if(!isnull(visible))	set_visibility(visible)

	Del()
		turn_off()
		update()
		..()

	proc/tick()
		if(!anchor) del src
		if(mover && !stale) stale = step_x != mover.step_x || step_y != mover.step_y || x != mover.x || y != mover.y || z != mover.z
		stale && update()

	proc/update()
		var new_effect[] = get_affected()
		var old_effect[] = (effect || list()) - (new_effect || list())
		if(old_effect && old_effect.len) for(var/shading/s in old_effect) s.sources -= src
		if(new_effect && new_effect.len) for(var/shading/s in new_effect) s.sources[src] = effect(s)
		effect = new_effect
		stale = FALSE
		mover && set_loc(mover.loc, mover.step_x, mover.step_y)

	proc/get_affected()
		if(visible && radius && intensity && anchor)
			. = list()
			for(var/turf/Environment/t in view(radius, turf_of(anchor))) . += t.shading || new /shading (t)

	//	determine how much to light s
	//	is a percent (0 to 1)
	proc/effect(shading/s) return (visible && radius > 0 && intensity > 0) && cos(90 * distance(anchor.cx(), anchor.cy(), s.cx, s.cy) / radius / 32) * intensity

	proc/set_intensity(n)
		if(intensity == n) return
		intensity = n
		stale = TRUE

	proc/set_radius(n)
		if(radius == n) return
		radius = n
		stale = TRUE

	proc/toggle() set_visibility(!visible)
	proc/turn_on() set_visibility(TRUE)
	proc/turn_off() set_visibility(FALSE)
	proc/set_visibility(n)
		if(visible == n) return
		visible = n
		stale = TRUE

turf/var/tmp/shading/shading

shading
	parent_type = /obj
	icon = 'code/events/new lighting.dmi'
	season_updates = FALSE
	layer = 50
	mouse_opacity = 0

	var tmp
		min_brightness = 30
		max_brightness = 255
		sources[0]
		active
		cx
		cy

	New(turf/t)
		if(!t || t.shading) del src
		cx = cx()
		cy = cy()
		t.shading = src
		for(var/shading/s in loc)
			if(s != src)
				del s

	var ambient
	var brightness
	proc/tick()
		var turf/t = loc
		if(src != t.shading) del src
		ambient = z != 2 && Lighting.ambient_light
		var total = ambient
		if(sources.len) for(var/light_source/s in sources)
			sources[s] = clamp(sources[s], 0, 1)
			if(sources[s]) total += sources[s]
			else sources -= s

		brightness = clamp(round(total * max_brightness), min_brightness, max_brightness)

		var new_alpha = 255 - brightness
		if(alpha != new_alpha)
			animate(src, alpha = new_alpha, time = 2)

atom
	changed_opacity() emit_light()

	proc/emit_light(range = world.view) for(var/light_source/light)
		var full_radius = range + light.radius
		if(abs(light.x - x) < full_radius && abs(light.y - y) < full_radius)
			light.stale = TRUE

	set_light(radius, intensity, visible)
		if(light)
			if(!isnull(radius))		light.set_radius(radius)
			if(!isnull(intensity))	light.set_intensity(intensity)
			if(!isnull(visible))	light.set_visibility(visible)
		else light = new (src, radius, intensity, visible)
		emit_light()

//	Cave exits give off ambient light into caves
turf/Environment/Cave/Caves
	season_update()
		..()
		light = light || new /light_source/ambient (src)

light_source/ambient
	radius = 5
	tick()
		set_intensity(Lighting.ambient_light)
		return ..()
#endif