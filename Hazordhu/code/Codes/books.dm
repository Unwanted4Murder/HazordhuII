obj/Item
	Parchment
		use(mob/humanoid/m) if(loc == m)
			if((locate(/obj/Item/Alchemy/Bottle/Potion/Ink) in m) && m.is_equipped(/obj/Item/Tools/Quill))
				m.used_tool()
				new /obj/Item/Parchment/Written (m, src)

		Written
			name		=	"Parchment"
			icon_state	=	"Written"

			Stackable	=	0

			var writing	=	""
			var title	=	""
			New(loc, creator)
				if(creator) del creator
				if(ismob(loc)) use(loc)
				..()

			proc/set_title(title)
				src.title = title
				if(title)	name = "Parchment \[[html_encode(title)]]"
				else		name = "Parchment"

			use_alt(mob/m)
				if(loc == m)
					winshow(m, "read_prev", 0)
					winshow(m, "read_next", 0)
					winshow(m, "rem_page",  0)
					winset(m, "reading", "title=\"[name]\"")
					m << output(null, "reading_output")
					m << output(html_encode(writing), "reading_output")
					winshow(m, "reading")

			use(mob/humanoid/m) if(loc == m)
				if((locate(/obj/Item/Alchemy/Bottle/Potion/Ink) in m) && m.is_equipped(/obj/Item/Tools/Quill))
					m.used_tool()
					var writing = input(m, "Write on the parchment: \nCtrl-Right-Click to read.", "Parchment", src.writing) as null|message
					if(writing == null) return
					if(writing == "" || writing == " ")
						new /obj/Item/Parchment (m)
						del src
					if("Yes" == alert(m, "Will you title the parchment now?", "Title", "Yes", "No"))
						set_title(input(m, "Title the parchment.", "Parchment", title))
					src.writing = writing

			MouseDrop(obj/Item/Book/book, src_location,over_location,src_control,over_control,params)
				var mob/player/m = usr
				if(istype(book) && book.loc == m)
					book.add_page(src)
					if(book == m.reading)
						m.read_page(book.current_page)


	Book
		Stackable = FALSE

		var pages[0]
		var tmp/current_page = 0
		var title  = ""
		var author = ""

		proc/set_title(title)
			src.title = title
			if(title)	name = "Book \[[html_encode(title)]]"
			else		name = "Book"

		use_alt(mob/m)
			if(loc == m)
				set_title(input(m, "Title the book.", "Book", title))
				author = input(m, "Provide your signature as the author of this book.", "Author", author)
				if(!author)	author = "Anonymous"

		use(mob/player/m) if(loc == m)
			var readed = m.reading
			if(m.reading)		m.close_book()
			if(readed != src)	m.open_book(src)

		proc/add_page(obj/Item/Parchment/Written/page, position=current_page)
			page.Move(src)
			pages.Insert(position, page)

mob/player
	var tmp/obj/Item/Book/reading

	verb
		read_prev()
			set hidden = TRUE
			if(reading) read_page(reading.current_page - 1)

		read_next()
			set hidden = TRUE
			if(reading) read_page(reading.current_page + 1)

		remove_page()
			set hidden = TRUE
			if(reading && reading.current_page > 0)
				var obj/Item/Parchment/p = reading.pages[reading.current_page]
				p.Move(src)
				reading.pages.Remove(p)
				read_page(reading.current_page)

		_close_book()
			set name = "close book", hidden = TRUE
			close_book()

	proc
		read_page(page)
			if(!reading) return

			reading.current_page = clamp(page, 0, reading.pages.len)

			src << output(null, "reading_output")
			if(reading.current_page)
				winset(src, "reading_output", "background-color=[rgb(238, 235, 183)]")
				var obj/Item/Parchment/Written/p = reading.pages[reading.current_page]
				src << output(p.writing, "reading_output")
				winset(src, "reading", "title=\"[reading.title] - [p.title] ([reading.current_page])\"")
				winset(src, "rem_page", "is-disabled=false")

			else
				src << output("", "reading_output")
				winset(src, "reading_output", "background-color=[rgb(96, 82, 38)]")

				if(reading.title || reading.author)
					src << output(
{"<center>
\n
\n
<h1>[reading.title]</h1>\n
\n
by <b>[reading.author]</b>
</center>"}, "reading_output")

				winset(src, "reading",  "title=\"[reading.title]\"")
				winset(src, "rem_page", "is-disabled=true")

		open_book(obj/Item/Book/book)
			reading = book
			read_page(0)
			winshow(src, "reading")
			winshow(src, "read_prev")
			winshow(src, "read_next")
			winshow(src, "rem_page")

		close_book() if(reading)
			reading.current_page = 0
			reading = null
			winshow(src, "reading", 0)