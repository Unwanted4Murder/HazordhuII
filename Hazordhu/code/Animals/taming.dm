/*
	F0lak: For aLL animals, incl peeks, action on them with a staff to tame them
	F0lak: Well, to have them follow you.
	F0lak: We should add a lasso for aggressive animals.  if it's a success then they don't attack any more.
	F0lak: Then you can have them follow you.
	F0lak: with staff
	F0lak: Take them to a forge, brand them, and then they will save
	F0lak: Then you can harness them to ride them.
	F0lak: Or, even remove harnesses.
	F0lak: Use the harness graphic for a lasso.
	F0lak: Or, just use harneses as i said for lasso
	F0lak: So, you can only ride BRANDED animals now.
	F0lak: Harness is used on agressive animals to calm them down so they won't attack.
*/

#define FINISHED 0

mob/Animal
	var tamed = FALSE

	/savedatum/var/animal_tamed

	save_to(savedatum/s)
		..()
		s.animal_tamed = tamed

	load_from(savedatum/s)
		..()
		tamed = s.animal_tamed

#if !FINISHED
	Peek/can_tame(mob/player/m)
		return !tamed
#endif

	proc/can_tame(mob/player/m)
		if(tamed) return m && m.aux_output("\The [src] is already tamed.")
#if !FINISHED
		if(!istype(src, /mob/Animal/Peek)) return FALSE
#endif
		return TRUE

	proc/tamed(mob/player/m)
		tamed = m.charID
		m && m.aux_output("You tamed the [src]!")
		follow(m)

	proc/tame(mob/player/m)
		if(can_tame(m))
			tamed(m)

	interact(mob/player/m)
		if(m.has_staff())
			tame(m)
		..()

	proc/follow(mob/player/m)
		following = m