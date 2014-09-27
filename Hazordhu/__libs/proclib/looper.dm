/*
See: Chapter 13 - DM Guide

Loopers
	This library provides a framework for you to easily take advantage of ticks.
	At the most basic level, your game starts out with a looper called "game_loop" that will always run in the background.
	You can add/remove any object to any loop (game_loop by default) using the global procs, add_ticker() and remove_ticker().
	By default, the game_loop calls the tick() proc of every ticker object inside of it.
	You can also make your own loopers with a different callback and tick lag.
	That is, it can call a different proc each tick, and will delay for (tick_lag / 10) seconds instead of once per tick.

	Summary
	looper/New(callback = "tick", tick_lag = world.tick_lag)
		You can create loopers and add tickers to them.
		The looper will infinitely loop with a delay of tick_lag per tick.
		Every loop tick, the callback of every ticker inside the looper will be called.

	var looper/game_loop
		The main loop of the game ticking once per game tick.

	To have an object's tick() proc called every tick, call:
		game_loop.add(object)

	To stop it, call game_loop.remove(object).
*/

var looper/game_loop = new

looper
	var callback, tick_lag
	New(callback = "tick", tick_lag = 0)
		set waitfor = FALSE
		src.callback = callback
		src.tick_lag = tick_lag
		for()
			tick()
			sleep tick_lag || world.tick_lag

	var tickers[0]
	proc/add(o)
		if(o in tickers) return
		tickers |= o
		var start_proc = "[callback] start"
		if(hascall(o, start_proc))
			call(o, start_proc)()

	proc/remove(o)
		if(!(o in tickers)) return
		tickers -= o
		var end_proc = "[callback] stop"
		if(hascall(o, end_proc))
			call(o, end_proc)()

	var next_tick
	proc/pre_tick()
	proc/post_tick()
	proc/tick()
		pre_tick()

		var pre = "pre [callback]"
		for(var/ticker in tickers)
			if(ticker && hascall(ticker, pre))
				call(ticker, pre)()

		for(var/ticker in tickers)
			if(ticker && hascall(ticker, callback))
				call(ticker, callback)()
			else remove(ticker)

		var post = "post [callback]"
		for(var/ticker in tickers)
			if(ticker && hascall(ticker, post))
				call(ticker, post)()

		post_tick()
