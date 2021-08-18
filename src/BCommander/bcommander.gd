extends Node2D
class_name BCommander

"""
Responsible for selecting and moving units
"""

export (NodePath) var hex_grid_path
export (NodePath) var camera_path

# Used for unit selection
onready var area = $Area2D
onready var collision = $Area2D/CollisionShape2D

var hex_grid
var camera: Camera2D = null
var selected_units: Array = []

func _ready():
	if hex_grid_path != "":
		hex_grid = get_node(hex_grid_path)
	if camera_path != "":
		camera = get_node(camera_path)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			#var hex_coord:DoubleCoordinate = hex_grid.pixel_to_hex(event.position)
			#var cell = hex_grid.get_cell(hex_coord.to_vector())
			var cursor: Vector2
			if camera != null:
				cursor = camera.get_global_mouse_position()
			else:
				cursor = event.position
			area.global_position = cursor
			var units = area.get_overlapping_bodies()
			print_debug(units)
			
			

			
			
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


func _on_Area2D_body_entered(body):
	pass # Replace with function body.
