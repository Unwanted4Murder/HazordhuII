obj/Item
	Coal
		name="Charcoal"
		icon='code/Icons/Coal.dmi'
		Flammable=0
		value = 2

	Pipe
		icon='code/Icons/Pipe.dmi'
		Flammable=1
		value = 5
		var/Huffed
		var/smoking

		use(mob/m) if(loc == m)
			if(!smoking)
				Smoke(m)
				Huffed = FALSE

		proc
			Smoke(mob/M)
				Huffed = FALSE
				smoking = TRUE
				M << "You begin to smoke your pipe."
				if(M.MaxStamina >= 20)
					M.MaxStamina --

				for(var/n in 1 to 3)
					sleep 50
					new /obj/Smoke (M.loc)
				smoking = FALSE

			Insert_Huff(mob/M)
				if(!Huffed)
					var obj/Item/Farming/crop/Huff/H = locate() in M
					if(H)
						M.lose_item(H)
						Huffed = TRUE
						M.aux_output("You put some huff in your pipe.")
					else M.aux_output("You need some huff to put in there.")
				else M.aux_output("There is already huff in this pipe.")

obj/gath_olay