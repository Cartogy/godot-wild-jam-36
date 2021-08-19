extends Node2D
class_name CellStructure

"""
A structure such as a Den, Town or any building.
"""

export (String) var structure_id

# Current cell it is on
var cell: Cell


func _ready():
	pass

func place_on_cell(p_cell: Cell):
	var center = p_cell.get_hex_center()
	print_debug(center)

	cell = p_cell
	self.global_position = p_cell.real_hex_center
