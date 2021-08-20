extends Node2D
class_name GridEdge

var cell_0
var cell_1


func remove_edge():
	var c0_to_c1 = get_direction(cell_0, cell_1)
	var c1_to_c0 = get_direction(cell_1, cell_0)
	cell_0.remove_edge(c0_to_c1)
	cell_1.remove_edge(c1_to_c0)
	
	self.queue_free()

func get_direction(_from, to) -> Vector2:
	var hex_direction = to.hex_coord - to.hex_coord
	
	return hex_direction
