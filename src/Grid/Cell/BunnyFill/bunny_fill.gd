extends Node

"""
Stores bunnies on tile
"""

export (int) var max_bunnies
# Store all bunnies
var bunnies_in_tile: Array = []

func _ready():
	pass
	
func reached_max_capacity():
	return max_bunnies == bunnies_in_tile.size()
	
func add_bunny(bunny):
	bunnies_in_tile.append(bunny)
	
func delete_bunnies(amount: int):
	for i in amount:
		var bunny = bunnies_in_tile[i]
		bunny.queue_free()
