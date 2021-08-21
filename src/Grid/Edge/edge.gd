extends Node2D
class_name GridEdge

var cell_0
var cell_1

func build_edge(from, to):
	cell_0 = from
	cell_1 = to

	var c0_to_c1 = get_direction(from, to)
	var c1_to_c0 = get_direction(to, from)

	cell_0.add_edge(c0_to_c1)
	cell_1.add_edge(c1_to_c0)


func remove_edge():
	var c0_to_c1 = get_direction(cell_0, cell_1)
	var c1_to_c0 = get_direction(cell_1, cell_0)
	cell_0.remove_edge(c0_to_c1)
	cell_1.remove_edge(c1_to_c0)
	
	self.queue_free()

func get_direction(from, to) -> Vector2:
	var hex_direction = to.hex_coords - from.hex_coords
	
	return hex_direction
