var
	map/map = new
	CHUNK_WIDTH = 20
	CHUNK_HEIGHT = 20
	TILE_WIDTH = 32
	TILE_HEIGHT = 32

proc/floor(x) return round(x)
//proc/ceil(x) return -round(-x)

map
	var
		width
		height
		layers[0]

	proc
		Moved(atom/movable/ref, atom/nloc, atom/oloc)
			if(nloc != oloc)
				var map_chunk/new_chunk = nloc && GetChunk(nloc.x, nloc.y, nloc.z)
				var map_chunk/old_chunk = oloc && GetChunk(oloc.x, oloc.y, oloc.z)
				if(new_chunk != old_chunk)
					if(old_chunk) old_chunk.Exited(ref)
					if(new_chunk) new_chunk.Entered(ref)

		GetChunk(x, y, z)
			if(!(z in 1 to world.maxz)) return
			var map_layer/l = layers[z]
			x = floor((x-1)/CHUNK_WIDTH)
			y = floor((y-1)/CHUNK_HEIGHT)
			return l.chunks[map.width * y + x + 1]

		ChunkBounds(x1, y1, x2, y2, z)
			x1 = floor((max(1, x1)-1)/CHUNK_WIDTH)
			y1 = floor((max(1, y1)-1)/CHUNK_HEIGHT)
			x2 = floor((min(world.maxx, x2)-1)/CHUNK_WIDTH)
			y2 = floor((min(world.maxy, y2)-1)/CHUNK_HEIGHT)
			. = list()
			var map_layer/l = layers[z]
			for(var/y in y1 to y2)
				for(var/x in x1 to x2)
					. += l.chunks[map.width * y + x + 1]

	New()
		width = ceil(world.maxx / CHUNK_WIDTH)
		height = ceil(world.maxy / CHUNK_WIDTH)
		for(var/z in 1 to world.maxz)
			layers += new /map_layer (z)

map_layer
	var
		chunks[0]
		z = 1

	proc
		GetChunk(x, y)
			x = floor((x-1)/CHUNK_WIDTH)
			y = floor((y-1)/CHUNK_HEIGHT)
			return chunks[map.width * y + x + 1]

		ChunkBounds(x1, y1, x2, y2)
			x1 = floor((x1-1)/CHUNK_WIDTH)
			y1 = floor((y1-1)/CHUNK_HEIGHT)
			x2 = floor((x2-1)/CHUNK_WIDTH)
			y2 = floor((y2-1)/CHUNK_HEIGHT)
			. = list()
			for(var/y in y1 to y2)
				for(var/x in x1 to x2)
					. += chunks[map.width * y + x + 1]
	New(z)
		src.z = z
		for(var/y in 1 to world.maxy step CHUNK_HEIGHT)
			for(var/x in 1 to world.maxx step CHUNK_WIDTH)
				chunks += new /map_chunk(x, y, CHUNK_WIDTH, CHUNK_HEIGHT, src)

map_chunk
	var
		x
		y
		map_layer/layer
		contents[]

		viewers[]

		apparent_season

	New(x, y, width, height, map_layer/layer)
		src.layer = layer
		src.x = x
		src.y = y
		contents = block(locate(x, y, layer.z), locate(x+width-1, y+height-1, layer.z))

	proc
		Entered(atom/o)
			contents |= o

			if(ismob(o))
				var mob/m = o
				if(m.client)
					for(var/map_chunk/chunk in map.ChunkBounds(x - 1, y - 1, x + CHUNK_WIDTH + 1, y + CHUNK_HEIGHT + 1, layer.z))
						chunk.Initialize()
						sleep(-1)

		Exited(atom/o)
			contents -= o

		Initialize()
			apparent_season = get_season()

			for(var/atom/a in contents)

				if(!a.initialized)
					a.initialize()
					a.initialized = TRUE

				if(a.season_updates && a.apparent_season != apparent_season)
					a.season_update(apparent_season)

				for(var/atom/a2 in a)
					if(a2.season_updates && a2.apparent_season != apparent_season)
						a2.season_update(apparent_season)
						sleep(-1)

				sleep(-1)

atom
	New()
		..()
		if(loc && map)
			var map_chunk/mc = map.GetChunk(x, y, z)
			if(mc) mc.Entered(src)

	movable
	/*
		Move(Loc, Dir, Sx, Sy)
			var _loc = loc, _dir = dir, _sx = step_x, _sy = step_y
			. = ..()
			if(.) Moved(_loc, _dir, _sx, _sy)
		proc
			Moved(atom/oldloc, odir, osx, osy)
				map.Moved(src, oldloc, osx, osy)


mob/player
	PostLogin()
		..()
		Moved()

turf
	New(turf/loc)
		..()
		if(loc && map)
			var map_chunk/c = map.GetChunk(loc.x, loc.y, loc.z)
			if(c) c.Exited(loc)
*/