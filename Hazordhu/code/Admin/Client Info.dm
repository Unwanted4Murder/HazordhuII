//	Kaiochao's client-tracking system.

var client_info[0]

var banned_keys[0]
var banned_ips[0]
var banned_ids[0]

var all_keys[0]

world
	New() { load_client_info(); ..() }
	Del() { save_client_info(); ..() }

	proc
		load_client_info()
			var loaded_info[]
			new /savefile ("Data/client info.sav") >> loaded_info

			if(loaded_info && loaded_info.len)
				if(!client_info.len) client_info = loaded_info
				else
					for(var/client_info/a in loaded_info) for(var/client_info/b in client_info) if(b.compare(a)) b.absorb(a)
					for(var/client_info/c in loaded_info) all_keys |= c.keys

			world.log << "Loaded [loaded_info ? loaded_info.len : "no"] client info entries."

		save_client_info()
			fdel("Data/client info.sav")
			if(client_info.len)
				new /savefile ("Data/client info.sav") << client_info
				world.log << "Saved [client_info.len] client info entries."

proc/get_client_info(tag)
	if(istype(tag, /client_info)) . = tag
	else if(istype(tag, /client)) . = new /client_info (tag)
	else if(istext(tag)) for(var/client_info/c in client_info)
		if(!c.TAG) c.get_tag()
		if(tag == c.TAG || (tag in (c.computer_ids|c.addresses|c.keys))) . = c

client_info
	var
		computer_ids[0]
		addresses[0]
		keys[0]

		is_banned = FALSE

		TAG

	New(client/c)
		if(ismob(c))
			var mob/m = c
			c = m.client

		if(c)
			add_key		(c.key)
			add_address	(c.address)
			add_id		(c.computer_id)

			for(var/client_info/b) if(compare(b)) absorb(b)

			if(!TAG) get_tag()

			client_info += src

	Del()
		client_info -= src
		..()

	proc/get_tag() TAG = string()

	proc/add_id()		if(args && args.len) for(var/arg in args) if(arg) computer_ids |= "[arg]"
	proc/add_address()	if(args && args.len) for(var/arg in args) if(arg) addresses |= "[arg]"

	proc/add_key()
		if(args && args.len) for(var/arg in args) if(arg) keys |= "[ckey(arg)]"
		all_keys |= keys

	proc/compare(client_info/b) return b == src || length(computer_ids & b.computer_ids) || length(addresses & b.addresses) || length(keys & b.keys)

	proc/absorb(client_info/b)
		if(b == src)	return
		computer_ids	|=	b.computer_ids
		addresses		|=	b.addresses
		keys			|=	b.keys
		is_banned		|=	b.is_banned
		TAG				=	b.TAG
		del b

	proc/ban(client/banner)
		is_banned = TRUE

		var client/client
		for(client)
			if(client.computer_id in (computer_ids|addresses|keys))
				del client
				continue

	proc/unban()
		is_banned = FALSE

mob/Admin
	verb/check_client(tag as text)
		var client_info/c = get_client_info(tag)
		if(!c) return aux_output("No client with that information exists.")
		var body = ""
		body += "<b>Tag:</b> [c.TAG]<br>"
		body += "<b>Keys:</b><br><ul>"
		for(var/key in c.keys) body += "<li>[key]</li>"
		body += "</ul><b>Computer IDs:</b><ul>"
		for(var/id in c.computer_ids) body += "<li>[id]</li>"
		body += "</ul><b>Addresses:</b><ul>"
		for(var/address in c.addresses) body += "<li>[address]</li>"
		body += "</ul><b>Banned:</b> [c.is_banned ? "Yes [unban_link(c)]" : "No [ban_link(c)]"]"
		src << browse(body)
		winshow(src, "browser_window")

	verb/list_clients()
		var body = "<ul>"
		for(var/client_info/c in client_info)
			if(!c.TAG) c.get_tag()
			body += "<li>Tag: [client_tag_link(c.TAG)]: <ul>"
			for(var/n in c.keys) body += "<li>[n]</li>"
			body += "</ul></li>"
		body += "</ul>"

		src << browse(body)
		winshow(src, "browser_window")

	verb/list_bans()
		var body = "<ul>"
		for(var/client_info/c in client_info)
			if(c.is_banned)
				if(!c.TAG) c.get_tag()
				body += "<li>Tag: [client_tag_link(c.TAG)]: <ul>"
				for(var/n in c.keys) body += "<li>[n]</li>"
				body += "</ul>[unban_link(c)]</li>"
		body += "</ul>"

		src << browse(body)
		winshow(src, "browser_window")

	verb/key_bans()
		var body = "<ul>"
		for(var/key in banned_keys) body += "<li>[key]: [banned_keys[key]]</li>"
		body += "</ul>"
		src << browse(body)
		winshow(src, "browser_window")

	verb/ip_bans()
		var body = "<ul>"
		for(var/key in banned_ips) body += "<li>[key]</li>"
		body += "</ul>"
		src << browse(body)
		winshow(src, "browser_window")

	verb/id_bans()
		var body = "<ul>"
		for(var/key in banned_ids) body += "<li>[key]</li>"
		body += "</ul>"
		src << browse(body)
		winshow(src, "browser_window")

	verb/ban_key(key in all_keys, reason as text)
		key = ckey(key)
		banned_keys[key] = reason
		AdminsOnline << "[src] banned [key]: [reason]"
		for(var/mob/player/p) if(p.ckey == key)
			p << "You've been banned! Reason: [reason]"
			p.Logout()

	verb/unban_key(key in banned_keys)
		AdminsOnline << "[src] unbanned [key]"
		banned_keys -= key

proc/ban_link(client_info/c)	return "<a href=?action=ban_client;src=\ref[c]>BAN</a>"
proc/unban_link(client_info/c)	return "<a href=?action=unban_client;src=\ref[c]>UNBAN</a>"
proc/client_tag_link(tag)		return "<a href=?action=check_client;client_tag=[tag]>[tag]</a>"

client/Topic(href, href_list[], client_info/c)
	. = ..()
	if(istype(c) && (key in Admins) && ("action" in href_list))
		switch(href_list["action"])
			if("ban_client")
				c.ban(src)
				var mob/Admin/m = usr
				m.check_client(c)

			if("unban_client")
				c.unban(src)
				var mob/Admin/m = usr
				m.check_client(c)

			if("check_client")
				var mob/Admin/m = usr
				m.check_client(href_list["client_tag"])

	if(href_list["action"] == "checkid")
		var mob/Admin/m = mob
		m.check_client(href_list["id"])

world/IsBanned(key, ip, id)
	var client_info/c = get_client_info(id) || get_client_info(key) || get_client_info(ip)
	. = (c && c.is_banned) || (ip in banned_ips) || (id in banned_ids) || (ckey(key) in banned_keys)
	if(.) AdminsOnline << "<i>[key] attempted to log in while banned.</i>"
	else return ..()