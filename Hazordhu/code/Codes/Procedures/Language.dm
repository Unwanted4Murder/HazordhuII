var language_fonts[] = list(
	"Plainsman" = "'Hazordhu II Elf'",
	"Northern" = "'Hazordhu II Northerner'",
	"Chiprock" = "'Hazordhu II Aldean'",
	"Southshores" = "'Hazordhu II Hazion'",
	"Orc" = "'Hazordhu II Orc'")

mob
	var languages_heard[]
	var languages_known[]

	proc/language_known(language)
		if(!language) return TRUE
		if(language == "Common") return TRUE
		if(language == native_language()) return TRUE

	proc/letter_known(letter, language)
		letter = lowertext(letter)
		if(!language) return TRUE
		if(!isletter(letter)) return TRUE
		if(language_known(language)) return TRUE
		if(!languages_known) return FALSE
		if(letter in languages_known[language]) return TRUE

	proc/speak(msg)
		if(Speaking == "Common")
			return drunk_slur(msg)

		. = ""
		for(var/n in 1 to length(msg))
			var char = copytext(msg, n, n + 1)
			if(letter_known(char, Speaking))
				. += drunk_slur(char)
			else . += "-"

	proc/native_language()
		if(Race == "Human")
			return Heritage
		else return Race

	//	When you hear someone talk in a certain language
	//	this returns their message translated into
	//	what you know of that language.
	proc/racial_language(t, language)
		t = html_encode(t)

		. = ""

		if(language_known(language))
			return t

		for(var/n in 1 to length(t))
			var char = copytext(t, n, n + 1)
			if(letter_known(char, language))
				. += char

			else
				hear_letter(char, language)

				var letter
				if(char == uppertext(char))
					letter = capitalize(languages[language][lowertext(char)])
				else letter = languages[language][char]
				. += letter

mob
	proc/hear_letter(letter, language)
		letter = lowertext(letter)
		if(isletter(letter) && !language_known(language))
			if(!languages_heard) languages_heard = new
			if(!languages_heard[language]) languages_heard[language] = list()
			languages_heard[language] |= letter

	proc/learn_letter(letter, language)
		letter = lowertext(letter)
		if(isletter(letter) && language)
			if(!languages_known) languages_known = new
			if(!languages_known[language]) languages_known[language] = list()
			languages_known[language] |= letter
			languages_heard[language] -= letter

	player
		verb/language()
			Speaking = input(src, "Choose your language:", "Language", native_language()) as anything in list("Common", native_language()) + languages_known

		verb/learn_language()
			if(!languages_heard || !languages_heard.len)
				aux_output("You haven't heard any more of a language!")
				return

			var language = input(src, "Learn a language you've heard.", "Learn Language") as null|anything in languages_heard
			if(!language) return

			if(!istype(languages_heard))
				return

			if(!(language in languages_heard)) return
			if(!languages_heard[language]) return
			if(languages_known && languages_known[language])
				languages_heard[language] -= languages_known[language]

			if(!length(languages_heard[language]))
				aux_output("You know all you've heard of this language!")
				return

			var letter = lowertext(input("What letter do you want to try to learn?", "Learn [language]") as null|anything in languages_heard[language])
			if(!letter) return

			var guess = lowertext(input("Try to guess the letter \"[letter]\" in [language].", "Learn [language]") as null|text)
			if(!guess) return

			if(guess == languages[language][letter])
				aux_output("You learned the [language] letter [letter]!")
				learn_letter(letter, language)

var languages[] = list(
	"Southshores" = list(
		"a" = "o",
		"b" = "bl",
		"c" = "ch",
		"d" = "k",
		"e" = "o",
		"f" = "ph",
		"g" = "k",
		"h" = "obo",
		"i" = "a",
		"j" = "ch",
		"k" = "chk",
		"l" = "l",
		"m" = "m",
		"n" = "m",
		"o" = "a",
		"p" = "n",
		"q" = "br",
		"r" = "u",
		"s" = "sh",
		"t" = "l",
		"u" = "e",
		"v" = "ch",
		"w" = "sh'k",
		"x" = "chk",
		"y" = "e",
		"z" = "ch"),

	"Plainsman" = list(
		"a" = "al",
		"b" = "bl",
		"c" = "p",
		"d" = "bl",
		"e" = "al",
		"f" = "el",
		"g" = "bb",
		"h" = "lb",
		"i" = "e",
		"j" = "hk",
		"k" = "bl",
		"l" = "e",
		"m" = "oo",
		"n" = "l",
		"o" = "e",
		"p" = "b",
		"q" = "p",
		"r" = "lb",
		"s" = "s",
		"t" = "bb",
		"u" = "oo",
		"v" = "u",
		"w" = "u",
		"x" = "lb",
		"y" = "el",
		"z" = "oo"),

	"Chiprock" = list(
		"a" = "ak",
		"b" = "sh",
		"c" = "k",
		"d" = "d",
		"e" = "ee",
		"f" = "kl",
		"g" = "d",
		"h" = "r",
		"i" = "e",
		"j" = "hk",
		"k" = "t",
		"l" = "r",
		"m" = "l",
		"n" = "l",
		"o" = "eke",
		"p" = "a",
		"q" = "ke",
		"r" = "t",
		"s" = "s",
		"t" = "sh",
		"u" = "u",
		"v" = "u",
		"w" = "k",
		"x" = "kr",
		"y" = "ek",
		"z" = "a"),

	"Northern" = list(
		"a" = "a",
		"b" = "gh",
		"c" = "s",
		"d" = "wh",
		"e" = "ei",
		"f" = "wh",
		"g" = "wh",
		"h" = "in",
		"i" = "ie",
		"j" = "sh",
		"k" = "dw",
		"l" = "yl",
		"m" = "y",
		"n" = "s",
		"o" = "e",
		"p" = "gh",
		"q" = "dw",
		"r" = "n",
		"s" = "sh",
		"t" = "sw",
		"u" = "ai",
		"v" = "gh",
		"w" = "wh",
		"x" = "dwh",
		"y" = "i",
		"z" = "h"),

	"Orc" = list(
		"a" = "ji'",
		"b" = "t",
		"c" = "s",
		"d" = "'",
		"e" = "'i",
		"f" = "sh",
		"g" = "t'",
		"h" = "ji",
		"i" = "ii",
		"j" = "j",
		"k" = "'t",
		"l" = "y",
		"m" = "p",
		"n" = "n",
		"o" = "e",
		"p" = "a",
		"q" = "ki'",
		"r" = "th",
		"s" = "st",
		"t" = "t'",
		"u" = "'i",
		"v" = "t",
		"w" = "jwi",
		"x" = "it'",
		"y" = "e",
		"z" = "s'")
)

/*
	//	Another Orc language
	list(
		"a"="je'",
		"b"="k",
		"c"="z",
		"d"="'",
		"e"="'e",
		"f"="zk",
		"g"="k'",
		"h"="je",
		"i"="ee",
		"j"="j",
		"k"="'k",
		"l"="y",
		"m"="p",
		"n"="n",
		"o"="i",
		"p"="'",
		"q"="ke'",
		"r"="kk",
		"s"="zk",
		"t"="t'",
		"u"="'e",
		"v"="k",
		"w"="jwe",
		"x"="ek'",
		"y"="i",
		"z"="z'")

	//	Dwarf language
	list(
		"a"="u",
		"b"="k",
		"c"="z",
		"d"="b",
		"e"="o",
		"f"="zk",
		"g"="k",
		"h"="bl",
		"i"="ou",
		"j"="kl",
		"k"="a",
		"l"="d",
		"m"="n",
		"n"="n",
		"o"="a",
		"p"="z",
		"q"="kz",
		"r"="bk",
		"s"="o",
		"t"="d",
		"u"="a",
		"v"="k",
		"w"="d",
		"x"="z",
		"y"="u",
		"z"="b")
*/