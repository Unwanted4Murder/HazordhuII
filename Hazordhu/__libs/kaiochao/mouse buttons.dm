/*

	November 27, 2013
	Kaiochao

	yep

*/

mouse
	var
		left = FALSE
		right = FALSE
		middle = FALSE
		down = FALSE
		atom/over

	proc
		Up()
			Update()

		Down()
			Update()

		Update()
			down = left || right || middle

client
	var mouse:mouse = new

	MouseDown(o, l, c, pa)
		var p[] = params2list(pa)
		if(p["left"])   mouse.left = TRUE
		if(p["right"])  mouse.right = TRUE
		if(p["middle"]) mouse.middle = TRUE
		mouse.Down()
		..()

	MouseUp(o, l, c, pa)
		var p[] = params2list(pa)
		if(p["left"])   mouse.left = FALSE
		if(p["right"])  mouse.right = FALSE
		if(p["middle"]) mouse.middle = FALSE
		mouse.Up()
		..()

	MouseEntered(o, l, c, pa)
		mouse.over = o
		..()

	MouseExited()
		mouse.over = null
		..()

	MouseDrag(so, oo, sl, ol, sc, oc, pa)
		mouse.over = oo
		..()