extends Node2D
class_name BCommander

"""
Responsible for selecting and moving units
"""

export (NodePath) var hex_grid_path

var hex_grid
var selected_units: Array = []
var units_in_tiles: Dictionary = {}
var select_rect = RectangleShape2D.new()

var mouse_click_area = Vector2(1,1)

var dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO
var drag_end: Vector2 = Vector2.ZERO
var cursor: Vector2 = Vector2.ZERO

var shift: bool = false

var selecting_upgrades: bool = false
var bunny: Bunny


onready var structures = {
	"barracks": preload("res://src/Structures/BNetStructure/Barracks/Barracks.tscn")
}


func _ready():
	update()
	if hex_grid_path != "":
		hex_grid = get_node(hex_grid_path)




func _unhandled_input(event):

	if event.is_action_pressed("shift"):
		shift = true
	elif event.is_action_released("shift"):
		shift = false

	if shift:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				clear_units()
				cursor = get_global_mouse_position()

				var unit_collision = get_units_clicked(cursor)
				selected_units = filter_units(unit_collision)

				if selected_units.size() != 0:
					var first_unit = selected_units[0]
					if first_unit.has_method("show_upgrades"):
						bunny = first_unit
						first_unit.show_upgrades()
						selecting_upgrades = true


	elif event is InputEventMouseButton:


		if event.button_index == BUTTON_LEFT and event.pressed:
			if Flow.selected_structure:
				var cell_coordinate = hex_grid.pixel_to_hex(get_global_mouse_position())
				if cell_coordinate == null:
					return
				var cell = hex_grid.hexagon_coords[cell_coordinate.to_vector()]
				if cell.bnet:
					var structure = structures[Flow.selected_structure].instance()
					Flow.b_net.add_structure(structure, cell_coordinate.to_vector(), cell)
					Flow.selected_structure = null
				return

			clear_units()

			cursor = get_global_mouse_position()

			var unit_collision = get_units_clicked(cursor)
			selected_units = filter_units(unit_collision)
			# Ensure only one unit is moved
			if selected_units.size() > 1:
				selected_units = [selected_units.pop_front()]
			if selected_units.size() > 0 && selecting_upgrades:
				selecting_upgrades = false
				if is_instance_valid(bunny) == false:
					bunny = null


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

			#var units = area.get_overlapping_bodies()


func get_units_clicked(p_cursor: Vector2) -> Array:
	select_rect.extents = mouse_click_area
	var space = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(select_rect)
	query.transform = Transform2D(0, cursor)
	var unit_collision = space.intersect_shape(query)

	return unit_collision



func add_unit(unit):
	selected_units.append(unit)

func remove_unit(unit):
	selected_units.erase(unit)

func decrement_units():
	var _last_unit = selected_units.pop_back()

func clear_units():
	selected_units.clear()

func move_units(units: Array, pixel: Vector2):
	# Get goal
	var hex_coord = hex_grid.pixel_to_hex(pixel)
	var goal_cell = hex_grid.get_cell(hex_coord.to_vector())

	for u in units:
		var paths = []

		if is_instance_valid(u):
			paths = HexPath.path_finding(u.cell, goal_cell, u.ignore_edge_obstacles, u.obstacles)
			u.move_to(paths)


func debug_path(path: Array):
	for c in path:
		c.debug_cell()

func add_bunny_path(path_dict: Dictionary, bunny_name: String, entity: BunnyBase, cell: Cell, goal_cell: Cell):
	var paths = []
	paths = HexPath.path_finding(cell, goal_cell, entity.ignore_edge_obstacles, entity.obstacles)
	path_dict[bunny_name] = paths

func filter_units(units: Array) -> Array:
	var us = []
	units_in_tiles.clear()
	for u in units:
		var unit = u.collider
		if unit is TileEntity:
			if unit.selectable:
				us.append(unit)

	return us

func _draw():
	draw_rect(Rect2(drag_start, cursor - drag_start), Color(.5,.5,.5), false)

func _on_Area2D_body_entered(body):
	if body is TileEntity:
		if body.selectable:
			selected_units.append(body)

func show_path(paths: Array):
	for cell in paths:
		var c: Cell = cell
		print_debug(c.hex_coords)
