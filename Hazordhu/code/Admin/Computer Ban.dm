
//	Nadrew's crazy-ass catch-all banning system and information tracking system.

var client_ids[0]
var client_keys[0]
var banned_ids[0]
var banned_keys[0]
var banned_ips[0]


proc
	SaveIds()
		var savefile
			client_save = new ("Data/clients.sav")
			ban_save = new ("Data/bans.sav")
		client_save["ids"] << client_ids
		client_save["keys"] << client_keys
		ban_save["bans"] << banned_ids
		ban_save["bankeys"] << banned_keys
		ban_save["banips"] << banned_ips

	LoadIds()
		var savefile
			client_save = new ("Data/clients.sav")
			ban_save = new ("Data/bans.sav")
		if(client_save["ids"])	client_save["ids"] >> client_ids
		if(client_save["keys"])	client_save["keys"] >> client_keys
		if(ban_save["bans"])	ban_save["bans"] >> banned_ids
		if(ban_save["bankeys"]) ban_save["bankeys"] >> banned_keys
		if(ban_save["banips"])	ban_save["banips"] >> banned_ips

mob
	player
		Topic(href, href_list[])
			. = ..()
			if("action" in href_list)
				if(href_list["action"] == "checkid")
					if(!Admins.Find(key))
						return
					var id = href_list["id"]
					src << "Checking [id]"
					call(src, "CheckID")(id)

				if(href_list["action"] == "unban")
					var id = href_list["id"]
					if(!Admins.Find(key))
						return
					banned_ids.Remove(id)
					src << "Unbanned [id]"

	proc
		CheckBanned()
			if(Admins.Find(key)) return FALSE
			if(banned_ids.Find("[client.computer_id]")) return TRUE

		AssociateKey()
			var cid = client.computer_id
			if(client_ids.Find("[cid]"))
				var/list/current_keys = client_ids["[cid]"]
				if(!current_keys.Find(ckey))
					current_keys.Add(ckey)
				client_ids["[cid]"] = current_keys

			else
				client_ids.Add("[cid]")
				client_ids["[cid]"] = list(ckey)

			if(!client_keys.Find(ckey))
				client_keys.Add(ckey)
				client_keys[ckey] = list("[cid]")
			var/list/current_ids = client_keys[ckey]
			if(!current_ids.Find("[cid]"))
				current_ids.Add("[cid]")
			client_keys[ckey] = current_ids
			SaveIds()


world
	New()
		..()
		LoadIds()

	Del()
		SaveIds()
		..()



mob
	Admin
		verb
			CheckKey(k as text)
				var keycheck = ckey(k)
				if(client_keys.Find(keycheck))
					src << "Key found: [keycheck]"
					src << "Associated IDs:"
					var assoc_ids[] = client_keys[keycheck]
					for(var/I in assoc_ids)
						src << "<a href=?src=\ref[src]&action=checkid&id=[I]>[I]</a>"
				else src << "[keycheck] not found in the key database."

			CheckID(i as text)
				if(client_ids.Find(i))
					src << "ID found: [i]"
					var assoc_keys[] = client_ids[i]
					src << "Associated Keys:"
					for(var/K in assoc_keys)
						src << K
				else
					src << "[i] not found in ID database."

			ViewKeys()
				for(var/K in client_keys)
					src << K

			ViewIDS()
				for(var/I in client_ids)
					src << I

			CheckBans()
				for(var/C in banned_ids)
					src << "ID: [C] ([banned_ids[C]]) <a href=?src=\ref[src]&action=unban&id=[C]>UNBAN</a>"

			Ban_Key(key as anything in client_keys)

			Ban()
				var/list/player_list = list()
				for(var/mob/C)
					if(!C.client) continue
					if(Admins.Find(C.key)) continue
					player_list.Add("[C.key] ([C.name])")
					player_list["[C.key] ([C.name])"] = C
				var/selected = input("Who do you want to ban from the server?")as null|anything in player_list
				if(!selected) return
				var/mob/banmob = player_list[selected]
				if(banmob)
					var/reason = input("Why are you banning [banmob.key]?") as text
					if(reason)
						banned_keys.Add(banmob.client.key)
						banned_ips.Add(banmob.client.address)
						banned_ids.Add(banmob.client.computer_id)
						banned_ids[banmob.client.computer_id] = "Banned by [src.key] -- Banned key: [banmob.key] -- [reason]"
						banmob << "You have been banned from the game"
						src << "You have banned ID [banmob.client.computer_id] -- Key: [banmob.key] -- [reason]"
						banmob.Logout()
					else
						alert("You need to input a reason")

			liftban()
				var/lifted_IP = input("Remove which IP?") as null | anything in banned_ips
				if(lifted_IP)
					banned_ips.Remove(lifted_IP)
					usr << "You have removed the ban on [lifted_IP]"
				var/lifted_key = input("Remove which Key?") as null | anything in banned_keys
				if(lifted_key)
					banned_keys.Remove(lifted_key)
					usr << "You have removed the ban on [lifted_key]"