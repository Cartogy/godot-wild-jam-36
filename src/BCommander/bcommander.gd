extends Node2D
class_name BCommander

"""
Responsible for selecting and moving units
"""

export (NodePath) var hex_grid_path


var hex_grid
var selected_units: Array = []

func _ready():
	if hex_grid_path != "":
		hex_grid = get_node(hex_grid_path)

func add_unit(unit):
	selected_units.append(unit)

func remove_unit(unit):
	selected_units.erase(unit)

func decrement_units():
	var _last_unit = selected_units.pop_back()

func clear_units():
	selected_units.clear()

func _move_to(hex_coord: Vector2):
	if selected_units.size() > 0:
		# Move units
		pass
