extends Node2D
export (bool) var DEBUG = false
export (NodePath) var grid_hex_path
var grid_hex

var current_hex_cell

func _ready():
	grid_hex = get_node(grid_hex_path)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if DEBUG:
				highlight_neighbours(event)


###############
## DEBUG ZONE
###############
func highlight_neighbours(event):
	var doubled_width_coord = grid_hex.pixel_to_hex(event.position)
	var hex_cell = grid_hex.get_cell(doubled_width_coord.to_vector())
	print(hex_cell)

	if current_hex_cell != null:
		if hex_cell != current_hex_cell:
			current_hex_cell.hide_neighbours()
			current_hex_cell = hex_cell
			current_hex_cell.show_neighbours()
	else:
		current_hex_cell = hex_cell
		current_hex_cell.show_neighbours()
