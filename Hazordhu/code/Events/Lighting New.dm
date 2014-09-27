
#define LIGHTING 1

var event/lighting/event_lighting = new


event
	lighting
		New() if(LIGHTING) start_ticking()

		var time = 0

		tick()
			time ++

			if(!(time % SECOND))
				update_daylight()


		var global_light = 0
		proc
			update_daylight()
				var pre_light = global_light
				global_light = time2light()

				if(pre_light != global_light)
					for(var/client/c)
						c.client_light()

			time2light()
				var hour = world.timeofday/36000+TIME_ZONE
				var p = 15
				. = (1-cos(hour*p))/2


turf
	var tmp/light_obj/light_obj
	proc/light_obj() if(LIGHTING)
		if(!light_obj)
			light_obj = new (src)
		return light_obj

	proc/update() if(LIGHTING)
		if(!light_obj)
			light_obj()

		light_obj.update()


light_obj
	parent_type = /obj
	icon = 'Events/lighting.dmi'

	layer = 102
	mouse_opacity = 0

	#if LIGHTING
	New()
		..()
		pos = pos()
	#endif

	var light_sources[0]

	proc
		result() if(LIGHTING)
			. = 0

			if(z != 2)
				. += event_lighting.global_light

			if(light_sources)
				for(var/atom/o in light_sources)
					. += light_sources[o]

		update() if(LIGHTING)
			icon_state = "[round(kMath_clamp(230 * result(), 0, 230))]"


atom
	New()
		..()
		#if LIGHTING
		if(LIGHTING && incandescence) spawn(5) light()
		#endif
	var
		incandescence
		tmp/effected[]

	proc
		clear_light_effect() if(LIGHTING && effected)
			for(var/light_obj/o in effected)
				remove_light_effect(o)

		remove_light_effect(light_obj/o) if(LIGHTING)
			o.light_sources	-=	src
			if(effected.len	==	1)
				effected	=	null
			else effected	-=	o
			o.update()

		add_light_effect(light_obj/o) if(LIGHTING)
			if(!effected) effected	=	new

			var new_effect = !(o in effected)

			effected[o]				=	calc_light(o)
			o.light_sources[src]	=	effected[o]

			if(new_effect) o.update()

		light() if(LIGHTING && incandescence)
			var view[] = view(incandescence, src)
			for(var/turf/t in view)
				add_light_effect(t.light_obj())

		set_incan(incan) if(LIGHTING)
			if(incandescence && !incan)
				clear_light_effect()

			incandescence = incan

			light()

		illuminate() if(LIGHTING)
			var range[] = range(src)
			for(var/atom/o in range(src))
				if(o.incandescence)
					o.light()

			for(var/mob/m in range)
				if(m.client) m.client.client_light()

		calc_light(light_obj/o)
			#if LIGHTING
			if(incandescence)
				if(!pos)	pos		=	pos()
				if(!o.pos)	o.pos	=	o.pos()

				var d = pos2_dist(pos, o.pos) / 32

				if(d > incandescence) return

				. = cos(90 * d / incandescence)
			#endif

client/proc
	client_light()
		#if LIGHTING
		for(var/turf/t in view(view+1, mob.loc))
			t.update()
		#endif


#if LIGHTING
atom/movable/move()
	. = ..()
	if(.)
		light()
		if(ismob(src))
			var mob/m = src
			if(m.client)
				m.client.client_light()
#endif