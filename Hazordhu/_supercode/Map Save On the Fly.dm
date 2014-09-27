/*

	notes on saving/loading objects
	- object.New() is called when an object is loaded, before object.Read().
	 This means any changes made to the object in object.New() may be overwritten by object.Read().

	- with this snippet, only movable atoms may be saved...
*/

var new_world = TRUE
var map_data/map_data = new

map_data
	var data_path = "map data.sav"
	var savefile/data

	New()
		if(!fexists(data_path))
			global.new_world = FALSE
		data = new (data_path)

	proc/SaveObject(atom/movable/M)
		var loc_id = GetLocID(M)
		if(!loc_id) return
		var save_id = M.__save_id()
		data["/[loc_id]/[save_id]"] << M

	proc/UnloadObject(atom/movable/M)
		var loc_id = GetLocID(M)
		var save_id = M.__save_id()
		data.cd = "/[loc_id]"
		data.dir.Remove(save_id)

	proc/LoadLoc(turf/T)
		var loc_id = GetLocID(T)
		data.cd = "/[loc_id]"
		for(var/save_id in data.dir)
			var atom/movable/m
			data["/[loc_id]/[save_id]"] >> m

	proc/GetLocID(atom/movable/M)
		return M.z && "[M.x]_[M.y]_[M.z]"

atom/movable
	var __save_id
	var __save_x
	var __save_y
	var __save_z
	var __color

	proc/__save_id()
		if(!__save_id)
			__save_id = ""
			for(var/i in 1 to 100)
				__save_id += ascii2text(rand(32, 126))
			__save_id = md5(__save_id)
		return __save_id

	Write(savefile/F)
		__save_x = x
		__save_y = y
		__save_z = z
		__color = color
		..()

	Read(savefile/F)
		..()
		loc = locate(__save_x, __save_y, __save_z)
		color = __color

turf
	var tmp/loaded = FALSE

// implementation

obj/Built/New()
	..()
	map_data.SaveObject(src)