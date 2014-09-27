// Found it!
// 1/15/2012
// Kaio


#define SONG_CHANNEL 1024

song_choice
	parent_type = /obj
	icon = null

	var file
	var length

	Adventure
		file = 'Adventure.mid'
		length = 930
	Apology
		file = 'Apology.mid'
		length = 640
	Dance_of_the_Rar
		file = 'Dance of the Rar.mid'
		length = 960
	Exile
		file = 'Exile.mid'
		length = 840
	Lies
		file = 'Lies.mid'
		length = 1010
	Midnight_March
		file = 'Midnight March.mid'
		length = 1200
	Plight
		file = 'Plight.mid'
		length = 1160
	Slowtown
		file = 'Slowtown.mid'
		length = 960
	Solemn_March
		file = 'Solemn March.mid'
		length = 1350
	The_Flargl
		file = 'The Flargl.mid'
		length = 840
	Town_Square
		file = 'Town Square.mid'
		length = 1000
	Trouble
		file = 'Trouble.mid'
		length = 1240
	Victory
		file = 'Victory.mid'
		length = 240

	DblClick()
		var mob/player/m = usr
		winset(m, "media_player.play", "is-checked=true")
		m.current_song = get_sound(m)
		m.song_play()

	proc/get_sound(mob/player/m)
		if(!m) return
		var sound/s = sound(file, m.media_repeat, 0, SONG_CHANNEL, m.media_volume)
		s.status = SOUND_STREAM
		return s

var songs[0]

world
	New()
		for(var/song in typesof(/song_choice))
			if(length(typesof(song))>1) continue
			songs += new song
		..()

mob/player
	#if !THIN_SKIN
	set_game_screen()
		..()
		song_list()
	#endif

	var
		tmp/sound/current_song

		media_volume	=	100
		media_repeat	=	0
		media_shuffle	=	0

	proc
		song_next()
			var song_choice/song

			if(media_shuffle)
				var song_choice/exclude
				if(current_song)
					for(exclude in songs)
						if(exclude.file == current_song.file)
							break

				song = pick(songs-exclude)
				current_song = song.get_sound(src)

			else if(media_repeat)
				song = current_song

			else
				if(!current_song) return

				if(current_song)
					for(song in songs)
						if(song.file == current_song.file)
							break

				if(!song || songs.Find(song) == songs.len)
					song = songs[1]
				else
					song = songs[songs.Find(song) + 1]

				current_song = song.get_sound(src)

			song_play()

		song_back()
			if(!current_song) return

			var song_choice/song

			if(current_song)
				for(song in songs)
					if(song.file == current_song.file)
						break

			if(!song || songs.Find(song) == 1)
				song = songs[songs.len]
			else
				song = songs[songs.Find(song) - 1]

			current_song = song.get_sound(src)
			song_play()

		song_play()
			if(!current_song) return

			var playing = current_song
			src << current_song

			song_list()

			spawn
				var length

				for(var/song_choice/song in songs)
					if(song.file == current_song.file)
						length = song.length

				while(src && length && current_song == playing)
					sleep(1)
					length --

				if(src && !length)
					song_next()

		song_list()
			var x = 0
			for(var/song_choice/song in songs)
				if(!src) return //	bug fix to avoid runtime when user logs out.

				src << output(song, "media_player.songs:1,[++x]")
				src << output(current_song && song.file == current_song.file ? "Playing" : "",
								"media_player.songs:2,[x]")

			winset(src, "media_player.songs", "cells=2,[x]")

	verb
		media_repeat()	//	when the 'repeat' button is clicked
			set hidden = 1
			media_repeat = (winget(src,
				"media_player.repeat",
				"is-checked") == "true")

		media_next()	//	when the 'next' button is clicked
			set hidden = 1

			winset(src, "media_player.repeat", "is-checked=false")
			media_repeat()

			song_next()

		media_back()	//	when the 'back' button is clicked
			set hidden = 1

			winset(src, "media_player.repeat", "is-checked=false")
			media_repeat()

			song_back()

		media_shuffle()	//	when the 'shuffle' button is clicked
			set hidden = 1

			winset(src, "media_player.repeat", "is-checked=false")
			media_repeat()

			media_shuffle = (winget(src,
				"media_player.shuffle",
				"is-checked") == "true")

		media_play()	//	when the 'play' button is clicked
			set hidden = 1

			if(winget(src, "media_player.play","is-checked") == "true")
				if(!current_song)
					var song_choice/song = songs[1]
					current_song = song.get_sound(src)

				song_play()

			else	//	Stop
				current_song = null
				src << sound(null, channel=SONG_CHANNEL)

		media_volume()
			set hidden = 1

			if(!current_song) return

			var/volume = text2num(winget(src,
				"media_player.volume","value"))

			current_song.volume = volume
			current_song.status |= SOUND_UPDATE
			src << current_song
			current_song.status &= ~SOUND_UPDATE