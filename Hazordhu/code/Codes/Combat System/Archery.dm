#define ARROW_FIRE		1
#define ARROW_POISON	2
#define ARROW_STUN		4
#define ARROW_EXPLODE	8
#define ARROW_INFERNO	16

// Pretty much everything in here needs to be rewritten soon.



mob
	title
		attackable = FALSE
		Cross() return TRUE

	Cross(obj/Item/Projectile/p)
		if(istype(p))
			if(Dead) return TRUE
			if(!density) return TRUE
			if(!p.density) return TRUE
			if(src == p.Owner) return TRUE
			return FALSE
		return ..()

	Animal
		Cross(obj/Item/Projectile/p)
			if(istype(p) && p.Owner)
				if(src == p.Owner.mount)
					return TRUE
			return ..()


	var tmp/shooting
	proc
		shoot(angle)
			if(!shooting) return

			var obj/Item/Weapons/archery/shooter = equipment["main"]
			if(!istype(shooter)) return

			var obj/Item/Projectile/P = new shooter.projectile_type (loc, -1)
			P.set_loc(loc, step_x, step_y)

			shooter.inuse = TRUE
			spawn(10)
				if(shooter)
					shooter.inuse = FALSE

			P.Owner = src

			P.Damage = initial(P.Damage) + shooter.ArrowDamage(src) + Strength + StrengthBuff

			if(!angle && client)
				angle = client.mouse.over ? client.mouse.angle || 0 : dir2angle(dir)

			P.dir = dir
			P.angle = angle
			P.Mod = shooter.Mod
			P.Fly()

			if(istype(src, /mob/NPC))
				P.Race = Race

			if(!client)
				P.can_get = FALSE
				spawn(MINUTE)
					del P

			used_weapon()

		archery_pull() if(!shooting)
			var mob/player/p = src
			if(istype(p))
				if(!p.pvp)
					src << "Your combat has been disabled."
					return

			if(handcuffs())
				src << "Your handcuffs restrict your combat."
				return

			if(!is_equipped(/obj/Item/Weapons/archery))
				src << "You don't have a ranged weapon equipped."
				return

			block_stop()

			shooting	=	TRUE
			icon_state	=	"archery"
			return 1

		archery_fire() if(shooting)
			var obj/Item/Weapons/archery/shooter = equipment["main"]
			if(!istype(shooter))	return
			if(shooter.inuse)		return
			if(client)
				var obj/Item/Clothing/Back/Quiver/quiver = locate() in src
				var obj/Item/Projectile/ammo = locate(shooter.projectile_type) in src
				if(!ammo && quiver) ammo = locate(shooter.projectile_type) in quiver
				if(!ammo)
					var ammo_name = "ammo"
					switch(shooter.projectile_type)
						if(/obj/Item/Projectile/Arrow) ammo_name = "arrows"
						if(/obj/Item/Projectile/Bolt) ammo_name = "bolts"
					aux_output("You have no [ammo_name]!")
					return
				del ammo
			shoot()
			archery_stop()
			return 1

		archery_stop() if(shooting)
			shooting	=	FALSE
			icon_state	=	""
			return 1

		archery_toggle()
			if(combat_mode && is_equipped(/obj/Item/Weapons/archery))
				if(shooting)
					return archery_stop()
				else return archery_pull()


turf/Environment
	Water/Enter(obj/Item/Projectile/p)			return istype(p) || ..()
	Ocean/Enter(obj/Item/Projectile/p)			return istype(p) || ..()

obj/Built
	Cross(obj/Item/Projectile/p)				return istype(p) && is_window(src) && icon_state == "open" || ..()
	Barred_Wall/Cross(obj/Item/Projectile/p)	return istype(p) || ..()
	Fence/Cross(obj/Item/Projectile/p)			return istype(p) || ..()
	Boat/Cross(obj/Item/Projectile/p)			return istype(p) || ..()

obj/cliff_border/Cross(obj/Item/Projectile/p) 	return istype(p) || ..()
mob/Cross(obj/Item/Projectile/p)				return istype(p) && p.Race == Race || ..()

obj
	Item
		Weapons
			Bow
				New()
					..()
					new /obj/Item/Weapons/archery/Bow (loc)
					set_loc()

			archery
				Bow
					icon = 'code/Weapons/Bow.dmi'
					projectile_type = /obj/Item/Projectile/Arrow
					cooldown = 10

				Crossbow
					icon = 'code/Weapons/Crossbow.dmi'
					projectile_type = /obj/Item/Projectile/Bolt
					cooldown = 20

				Type = "None"
				aType = "bash"
				Flammable = 1
				var
					Mod = 0
					cooldown
					tmp
						inuse = 0
					obj/Item/Projectile/projectile_type

				proc/ArrowDamage(mob/M) return rand(15, 30)

	Item/Projectile
		//	due to the depth of SIDE_MAP
		//	the collision box needs to be stretched vertically
		SET_TBOUNDS("14,4 to 19,19")

		var
			Damage = 10
			//Speed  //How fast the projectile moves. Distance is 5/this + rand(0,5)
			Mod = 0
			distance

			init_speed = 20
			decel = 1
			angle
			vel[2]

			down_icon
			break_icon

			//	for friendly-fire AI
			Race

		density = 0
		layer = MOB_LAYER

		New(loc, x)
			if(x == -1) Stackable = 0
			..()

		grabbed_by()
			if(icon == break_icon) del src

			icon = initial(icon)
			icon_state = ""
			Stackable = 1

			pixel_x = 0
			pixel_y = 0

		#if PIXEL_MOVEMENT
			step_x = 0
			step_y = 0
		#endif

			density = 0
			Mod = 0

			return ..()

		dropped_by(mob/m)
			density = 0
			return ..()

		Move()
			. = ..()
			if(isturf(loc) && (Mod & ARROW_INFERNO))
				new /obj/Fire (loc)

		proc/move_tick_start()
			Stackable = 0
			density = 1
			// icon_state = angle2state(angle, 10)
			transform = turn(initial(transform), angle)
			vel = vec2p(init_speed, angle)
			decel = vec2p(-decel, angle)

		proc/move_tick_stop()
			if(Mod & ARROW_EXPLODE) for(var/turf/t in view(src, 1)) new /obj/Fire (t)
			density = FALSE
			Mod = FALSE
			icon = down_icon

		proc/move_tick()
		#if PIXEL_MOVEMENT
			if(vec2_iszero(vel) || !move(vel))
				move_loop.remove(src)

			for(var/d in 1 to 2)
				if(vel[d])
					if(vel[d] > 0)
						vel[d] = max(0, vel[d] + decel[d])
					else vel[d] = min(0, vel[d] + decel[d])
		#else
			if(!step(src, dir))
				move_loop.remove(src)
		#endif

		proc/Fly() move_loop.add(src)

		Bump(atom/movable/O)
			if(src in move_loop.tickers)
				if(Mod & ARROW_FIRE) new /obj/Fire (loc)

				move_loop.remove(src)

				var mob/humanoid/h = O
				var blocked = FALSE
				if(istype(h))
					if(h.blocking)
						var chance
						if(h.is_shield_equipped()) chance = 65
						if(h.is_equipped(/obj/Item/Weapons/Tower_Shield)) chance = 85
						if(prob(chance))
							var arrow_angle = angle
							var mob_angle
							if(h.client && h.client.mouse)
								mob_angle = h.client.mouse.angle
							else mob_angle = dir2angle(h.dir)
							if(abs(angle_difference(mob_angle, arrow_angle + 180)) < 30)
								h.emote("blocks an arrow")
								h.used_shield()
								blocked = TRUE

				var mob/mortal/m = O
				if(istype(m) && !blocked)
					if(istype(src, /obj/Item/Projectile/Arrow))
						m.lose_stamina(Damage / 2)

					m.Bleed()

					if(Owner)
						if(Owner.client && m.client)
							var mob/player/a = Owner
							var mob/player/b = m
							a.log_action("shot [b.key] ([b.charID]) with [src]")
							b.log_action("shot by [a.key] ([a.charID]) with [src]")
						m.take_damage(Damage + randn(-5, 5) - m.Defense / 2, Owner)

		Arrow
			icon = 'code/Weapons/ArrowRot.dmi'
			down_icon = 'code/Weapons/ArrowDownRot.dmi'
			break_icon = 'code/Weapons/ArrowBreak.dmi'
			value = 1
			Flammable = 1
			distance = 8

		Bolt
			icon = 'code/Weapons/BoltRot.dmi'
			down_icon = 'code/Weapons/BoltDownRot.dmi'
			break_icon = 'code/Weapons/BoltBreak.dmi'
			value = 1
			distance = 5
			Damage = 25