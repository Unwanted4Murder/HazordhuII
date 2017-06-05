//	This is how much the global temperature affects the heat of the players.
var world_temperature = 10

//	How much heat is added to a player wearing this.
obj/Item/var/tmp/heat_added = 0

mob/player
	var tmp/body_heat = 50

	proc/in_tutorial() return x > 665 && y > 770
