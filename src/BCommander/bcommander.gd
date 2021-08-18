extends Node2D
class_name BCommander

"""
Responsible for selecting and moving units
"""

export (NodePath) var hex_grid_path

# Used for unit selection
onready var area = $Area2D
onready var collision = $Area2D/CollisionShape2D

var hex_grid
var selected_units: Array = []
var select_rect = RectangleShape2D.new()

var mouse_click_area = Vector2(1,1)

var dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO
var drag_end: Vector2 = Vector2.ZERO
var cursor: Vector2 = Vector2.ZERO

func _ready():
	update()
	if hex_grid_path != "":
		hex_grid = get_node(hex_grid_path)




func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			clear_units()
			
			cursor = get_global_mouse_position()
			
			select_rect.extents = mouse_click_area
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, cursor)
			var unit_collision = space.intersect_shape(query)
			filter_units(unit_collision)
			
			print_debug(selected_units)
			
			drag_start = cursor - (mouse_click_area/2)
			drag_end = cursor + (mouse_click_area / 2)
			update()
			
			#dragging = true
			#drag_start = get_global_mouse_position()
		elif event.button_index == BUTTON_RIGHT and event.pressed:

			move_units(selected_units, get_global_mouse_position())
		elif dragging:
			dragging = false
			drag_end = get_global_mouse_position()
			
			select_rect.extents = (drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start)/2)

			
			update()
			print_debug(selected_units)
			#var hex_coord:DoubleCoordinate = hex_grid.pixel_to_hex(event.position)
			#var cell = hex_grid.get_cell(hex_coord.to_vector())

			area.global_position = get_global_mouse_position()
			#var units = area.get_overlapping_bodies()
			
			
			

			
			
func add_unit(unit):
	selected_units.append(unit)

func remove_unit(unit):
	selected_units.erase(unit)

func decrement_units():
	var _last_unit = selected_units.pop_back()

func clear_units():
	selected_units.clear()

func move_units(units: Array, pixel: Vector2):
	var hex_coord = hex_grid.pixel_to_hex(pixel)
	var cell = hex_grid.get_cell(hex_coord)
	if units.size() > 0:
		for u in units:
			u.move_to([cell])


func filter_units(units: Array):
	for u in units:
		var unit = u.collider
		if unit is TileEntity:
			if unit.selectable:
				selected_units.append(unit)

func _draw():
	draw_rect(Rect2(drag_start, cursor - drag_start), Color(.5,.5,.5), false)

func _on_Area2D_body_entered(body):
	if body is TileEntity:
		if body.selectable:
			selected_units.append(body)
