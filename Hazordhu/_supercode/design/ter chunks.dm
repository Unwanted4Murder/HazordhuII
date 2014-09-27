/*

/*
Initialize entire chunks at once, you'll wind up with less searching and more successful updates.
Set up a viewport datum that contains a rectangle slightly larger than the actual viewport to initialize chunks just out of range of the actual viewport of the client.
Then call out to all chunks entering the viewport to update.
	newview - oldview
^That's how you'd determine what's entering the viewport.
It'll wind up being a lot faster.

remember granularity:
	var/chunk_x1 = floor(viewport.x1 / CHUNK_WIDTH)
	var/chunk_y1 = floor(viewport.y1 / CHUNK_HEIGHT)
	var/chunk_x2 = ceil(viewport.x2 / CHUNK_WIDTH)
	var/chunk_y2 = ceil(viewport.y2 / CHUNK_HEIGHT)
*/

var
    initialized = 0
    map/map = new()

map
    var
        width
        height
        list/layers = list()
    proc
        Moved(atom/movable/ref,atom/oloc,osx,osy)
            var/x1 = oloc.x + osx / TILE_WIDTH
            var/x2 = oloc.x + (osx + ref.bound_width) / TILE_WIDTH - 0.001
            var/y1 = oloc.y + osy / TILE_HEIGHT
            var/y2 = oloc.y + (osy + ref.bound_height) / TILE_HEIGHT - 0.001
            var/list/ol = ChunkBounds(x1,y1,x2,y2,oloc.z)
            x1 = ref.x + ref.step_x / TILE_WIDTH
            x2 = ref.x + (ref.step_x + ref.bound_width) / TILE_WIDTH - 0.001
            y1 = ref.y + ref.step_y / TILE_WIDTH
            y2 = ref.y + (ref.step_y + ref.bound_height) / TILE_HEIGHT - 0.001
            var/list/nl = ChunkBounds(x1,y1,x2,y2,ref.z)
            var/list/enter = nl - ol
            var/list/exit = ol - nl
            for(var/map_chunk/c in exit)
                c.Exited(ref)
            for(var/map_chunk/c in enter)
                c.Entered(ref)

        GetChunk(x,y,z)
            var/map_layer/l = layers[z]
            x = floor((x-1)/CHUNK_WIDTH)
            y = floor((y-1)/CHUNK_HEIGHT)
            return l.chunks[map.width * y + x + 1]

        ChunkBounds(x1,y1,x2,y2,z)
            x1 = floor((x1-1)/CHUNK_WIDTH)
            y1 = floor((y1-1)/CHUNK_HEIGHT)
            x2 = floor((x2-1)/CHUNK_WIDTH)
            y2 = floor((y2-1)/CHUNK_HEIGHT)
            var/list/ret = list()
            var/map_layer/l = layers[z]
            for(var/y = y1;y<=y2;y++)
                for(var/x=x1;x<=x2;x++)
                    ret += l.chunks[map.width * y + x + 1]
            return ret

    New()
        width = ceil(world.maxx / CHUNK_WIDTH)
        height = ceil(world.maxy / CHUNK_WIDTH)
        for(var/z in 1 to world.maxz)
            layers += new/map_layer(z)

map_layer
    var
        list/chunks = list()
        z = 1
    proc
        GetChunk(x,y)
            x = floor((x-1)/CHUNK_WIDTH)
            y = floor((y-1)/CHUNK_HEIGHT)
            return chunks[map.width * y + x + 1]

        ChunkBounds(x1,y1,x2,y2)
            x1 = floor((x1-1)/CHUNK_WIDTH)
            y1 = floor((y1-1)/CHUNK_HEIGHT)
            x2 = floor((x2-1)/CHUNK_WIDTH)
            y2 = floor((y2-1)/CHUNK_HEIGHT)
            var/list/ret = list()
            for(var/y = y1;y<=y2;y++)
                for(var/x=x1;x<=x2;x++)
                    ret += chunks[map.width * y + x + 1]
            return ret
    New(z)
        src.z = z
        for(var/y=1;y<=world.maxy;y += CHUNK_HEIGHT)
            for(var/x=1;x<=world.maxx;x += CHUNK_WIDTH)
                chunks += new/map_chunk(x,y,CHUNK_WIDTH,CHUNK_HEIGHT,src)

map_chunk
    var
        x
        y
        map_layer/layer
        list/contents

        list/viewers

    New(x,y,width,height,map_layer/layer)
        src.layer = layer
        contents = block(locate(x,y,layer.z),locate(x+width-1,y+height-1,layer.z))

    proc
        Entered(var/atom/o)
            contents += o

        Exited(var/atom/o)
            contents -= o

atom
    New()
        ..()
        if(src.loc && initialized)
            var/map_chunk/mc = map.GetChunk(src.x,src.y,src.z)
            mc.Entered(src)
    movable
        proc
            Moved(atom/oldloc,odir,osx,osy)
                map.Moved(src,oldloc,osx,osy)

turf
    New(turf/loc)
        if(loc && initialized)
            var/map_chunk/c = map.GetChunk(loc.x,loc.y,loc.z)
            c.Exited(loc)
*/