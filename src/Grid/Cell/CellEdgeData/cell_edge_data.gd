extends Resource
class_name CellEdgeData

#
# { direction0: cell_0,
#   direction1: cell_1,
#   directoin2: cell_2,
# }
#
#

# Only store the directions
var edges: Dictionary = {}

func add_edge(direction: Vector2, cell):
	if has_edge(direction) == false:
		edges[direction] = true

func remove_edge(direction: Vector2, cell):
	if has_edge(direction):
		edges.erase(direction)


func has_edge(direction: Vector2):
	return edges.has(direction)
