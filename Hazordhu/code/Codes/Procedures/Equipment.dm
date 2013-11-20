
/*
	If a piece of equipment overlays when it shouldn't, check its icon file to see if its icon_state is "item".
*/

obj/Item
	var
		two_handed

		//	this only affects items in the Head or Helmet slot
		covers_hair = true

		tmp
			Overlay
				overlay
//				rotated_overlay

	proc
		equipped_by(mob/m)
		unequipped_by(mob/m)

	Weapons
		archery
			Bow/two_handed = TRUE
			Crossbow/two_handed = TRUE
			unequipped_by(mob/humanoid/m)
				m.archery_stop()

	Tools
		Torch
			equipped_by(mob/m)		m.set_light(3)
			unequipped_by(mob/m)	m.set_light(0)

	Clothing
		var can_conceal
		Hood
			Hood/can_conceal = true
			Leather_Hood/can_conceal = true
			Flargl_Leather_Hood/can_conceal = true
			Grawl_Hood/can_conceal = true
			North_Grawl_Hood/can_conceal = true
			Turban/can_conceal = true

		Helmet
			Bandana/can_conceal = true
			Grawl_Mask/can_conceal = true
			Leather_Mask/can_conceal = true
			Mask/can_conceal = true
			North_Grawl_Mask/can_conceal = true

		equipped_by(mob/m)
			if(istype(m))
				if(is_player(m))
					var mob/player/p = m
					spawn p.Hood_Concealed = (can_conceal && p.isSubscriber && "Yes" == p.s_alert("Do you want to be concealed by your hood?", "Hood Concealment", "Yes", "No"))
				else m.Hood_Concealed = true
			..()

		unequipped_by(mob/m)
			if(can_conceal) m.Hood_Concealed = false
			..()

mob/player
	PostLogin()
		..()
		for(var/obj/Item/item in Equipment())
			item.equipped_by(src)

mob
/*
	var tmp/obj/Hair/rotated_hair

	//	Hair must be updated with every rotation
	Gethair()
		..()
		hair_turn()

	Remhair()
		..()
*/
	verb/rotate_test(angle as num)
		icon_turn(angle)

	//	Some layers are complicated when looking north
	move_tick()
		var pre_dir = dir
		. = ..()
		if(dir != pre_dir)
			changed_dir()


	proc/changed_dir()
		update_equipment_layers()

	var
		equipment[] = list(
			"main", "off",
			"helmet", "body", "legs", "hands", "feet",
			"head", "belt", "misc", "bag", "back")

		tmp
			rotated_angle = 0

	proc
		equip(obj/Item/i) if(i)
			if(ispath(i))
				i = locate(i) in src
				if(!i) return 0
			if(!can_equip(i)) return 0
			var equip_type = get_equip_type(i)
			if(!(equip_type in equipment)) return
			if(!unequip(equip_type)) return 0
			equipment[equip_type] = i
			apply_equipment_overlay(i)
			InventoryGrid()
			i.equipped_by(src)
			if(!hair_showing()) Remhair()
			if(rotated_angle) icon_turn()
			reset_flat_icon()
			return 1

		//	also takes an equip_type
		unequip(obj/Item/i) if(i)
			if(istext(i))
				if(i in equipment)
					i = equipment[i]
					if(!i) return 1
				else return 1
			var equip_type = is_equipped(i)
			if(!equip_type) return 1
			equipment[equip_type] = null
			if(i.overlay) del i.overlay
//			if(i.rotated_overlay) del i.rotated_overlay
			InventoryGrid()
			i.unequipped_by(src)
			if(hair_showing()) Gethair()
			reset_flat_icon()
			return 1

		unequip_all()
			for(var/slot in equipment)
				unequip(slot)

		can_equip(obj/Item/i)
			// Two-handed weapons will try to unequip anything in the off-hand
			if(i.two_handed && (!equipment["off"] || unequip(equipment["off"])))
				return true

			if(get_equip_type(i) == "off")
				var obj/Item/main = equipment["main"]
				if(main && main.two_handed)
					if(unequip(main))
						return true
					else return false
			return true

		//	where the item is currently equipped to, if equipped
		is_equipped(obj/Item/i) if(i)
			if(ispath(i))
				i = locate(i) in Equipment()
				if(!i) return false
			for(var/slot in equipment) if(i == equipment[slot]) return slot
			return false

		//	return the item if it's equipped
		get_equipped(obj/Item/i) if(i)
			if(!ispath(i))
				i = i.type
			return locate(i) in Equipment()

		//	sets the angle of the player and his overlays to 'angle'
		icon_turn(angle)
			transform = matrix(angle, MATRIX_ROTATE)
			rotated_angle = angle
			reset_flat_icon()
/*
			if(isnull(angle))
				angle = rotated_angle
			rotated_angle = angle

			if(rotated_angle)
				for(var/obj/Item/item in Equipment()) if(item.overlay)
					item.overlay.Hide()
					var icon/i = icon(item.overlay.Icon())
					i.Turn(angle)
					item.rotated_overlay = overlay(i)
					item.rotated_overlay.Layer(item.overlay.Layer())
				HeritageIcon()
				var icon/i = icon(icon)
				i.Turn(angle)
				icon = i
				reset_flat_icon()

			else icon_reset()

		hair_turn(angle)
			if(isnull(angle)) angle = rotated_angle
			rotated_angle = angle

			if(hair_showing() && HairObj)
				overlays -= HairObj
				overlays -= rotated_hair
				if(angle)
					var icon/i = icon(HairObj.icon)
					i.Turn(angle)

					rotated_hair = new
					rotated_hair.icon = i

					overlays += rotated_hair

				else overlays += HairObj
*/
		hair_showing()
			if(!Hair) return false

			var obj/Item/head = equipment["head"]
			if(head && head.covers_hair) return false

			var obj/Item/helmet = equipment["helmet"]
			if(helmet && helmet.covers_hair) return false

			return true

		icon_reset()
			overlays.Cut()

			for(var/obj/Item/i in Equipment())
				remove_equipment_overlay(i)
				if(!rotated_angle)
					apply_equipment_overlay(i)

			HeritageIcon()

			reset_flat_icon()

		clear_equipment_overlays()
			for(var/obj/Item/item in Equipment())
				if(item.overlay)
					item.overlay.Hide()

		update_equipment_layers()
			for(var/obj/Item/item in Equipment())
				if(item.overlay)
					item.overlay.Layer(get_equip_layer(item, dir))

		apply_equipment_overlay(obj/Item/i)
			var equip_state = get_equip_state(i)
			if(equip_state in icon_states(initial(i.icon)))
				i.overlay = overlay(i.icon, equip_state)
				i.overlay.Layer(get_equip_layer(i, dir))

		remove_equipment_overlay(obj/Item/i)
			del i.overlay
//			del i.rotated_overlay

var equipment_slots[] = list(
	"helmet", "head", "back",
	"main", "body", "off",
	"belt", "legs", "hands",
	"misc", "feet", "bag"
)

mob
	proc/EquipmentGrid()
	player/EquipmentGrid()
		for(var/slot in equipment)
			var item = equipment[slot]
			var index = equipment_slots.Find(slot)
			var x = (index - 1) % 3 + 1
			var y = -round(-index / 3)
			src << output(item || slot, "equipment_grid:[x],[y]")

	proc/Equipment()
		. = list()
		for(var/slot in equipment)
			if(equipment[slot])
				. += equipment[slot]

mob/player
	verb/check_defense() src << "Your net defense: [Defense()]"
	verb/check_attack() src << "Your attack power: [Attack()]"

proc
	get_equip_layer(obj/Item/i, dir) if(istype(i))
		//	negative layers are actually FLOAT_LAYERS
		//	greater number is still higher
		var equip_type = get_equip_type(i)
		switch(equip_type)
			if("main", "off")
				if(dir == NORTH) return -6.0
				if(dir == SOUTH) return -1.0
				if(equip_type == "main")
					if(dir == EAST) return -1.0
					else if(dir == WEST) return -5.0
				else if(equip_type == "off")
					if(dir == EAST) return -5.0
					else if(dir == WEST) return -1.0
				return -1.0

			if("misc") return -1.5
			if("back") return -3.0
			if("belt", "head", "feet", "hands") return -3.5
			if("legs", "body") return -4.0
			if("helmet") return -5.0

	get_equip_type(obj/Item/i) if(istype(i))
		if(i.equip_slot)
			return i.equip_slot

		if(istype(i, /obj/Item/Weapons))
			var obj/Item/Weapons/w = i
			if(is_shield(w)) return "off"
			if(is_weapon(w)) return "main"

		if(istype(i, /obj/Item/Clothing))
			var obj/Item/Clothing/c = i
			return "[c.clothtype]"

		if(istype(i, /obj/Item/Armour))
			var obj/Item/Armour/a = i
			return "[a.armortype]"

	get_equip_state(obj/Item/i) if(istype(i))
		return ""

		if(istype(i, /obj/Item/Tools))
			return ""

		if(istype(i, /obj/Item/Weapons))
			var obj/Item/Weapons/w = i
			if(is_shield(w)) return ""
			if(is_weapon(w)) return ""

		return i.icon_state

var const
	EQUIP_HELMET = "helmet"
	EQUIP_HEAD = "head"
	EQUIP_BACK = "back"
	EQUIP_MAIN = "main"
	EQUIP_BODY = "body"
	EQUIP_OFF = "off"
	EQUIP_BELT = "belt"
	EQUIP_LEGS = "legs"
	EQUIP_HANDS = "hands"
	EQUIP_MISC = "misc"
	EQUIP_FEET = "feet"
	EQUIP_BAG = "bag"

obj/Item
	var equip_slot
	Tools/equip_slot = EQUIP_MAIN
	Weapons
		equip_slot = EQUIP_MAIN
		Buckler/equip_slot = EQUIP_OFF
		Kite_Shield/equip_slot = EQUIP_OFF
		Shield/equip_slot = EQUIP_OFF
		Tower_Shield/equip_slot = EQUIP_OFF
		Wooden_Kite/equip_slot = EQUIP_OFF
		Wooden_Shield/equip_slot = EQUIP_OFF

	Armour
		Accessory/equip_slot = EQUIP_MISC
		Back/equip_slot = EQUIP_BACK
		Feet/equip_slot = EQUIP_FEET
		Hands/equip_slot = EQUIP_HANDS
		Helmet/equip_slot = EQUIP_HELMET
		Pants/equip_slot = EQUIP_LEGS
		Shirt/equip_slot = EQUIP_BODY

	Clothing
		Accessory/equip_slot = EQUIP_MISC
		Back/equip_slot = EQUIP_BACK
		Bag/equip_slot = EQUIP_BAG
		Belt/equip_slot = EQUIP_BELT
		Feet/equip_slot = EQUIP_FEET
		Hands/equip_slot = EQUIP_HANDS
		Helmet/equip_slot = EQUIP_HELMET
		Hood/equip_slot = EQUIP_HEAD
		Pants/equip_slot = EQUIP_LEGS
		Shirt/equip_slot = EQUIP_BODY