extends Node

"""
Stores bunnies on tile
"""
export (int) var max_bunnies
var bunny_scene = preload("res://src/TileEntities/Bunny/Bunny.tscn")


# Store all bunnies
var bunnies_in_tile: Array = []

func _ready():
	pass
	
func reached_max_capacity():
	return max_bunnies == bunnies_in_tile.size()
	
func add_bunny(center: Vector2, hex_coord: Vector2):
	var cell = get_owner()
	var bunny: Bunny = bunny_scene.instance()

	bunny.global_position = center - cell.global_position

	bunny.hex_center = center
	bunny.hex_coord = hex_coord
	bunnies_in_tile.append(bunny)
	
	cell.add_child(bunny)
	
func delete_bunnies(amount: int):
	for i in amount:
		var bunny = bunnies_in_tile[i]
		bunny.queue_free()
