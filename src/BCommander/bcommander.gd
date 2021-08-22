extends Node2D
class_name BCommander

"""
Responsible for selecting and moving units
"""

export (NodePath) var hex_grid_path

var hex_grid
var selected_units: Array = []
var units_with_selection: Array = []

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
	"barracks": preload("res://src/Structures/BNetStructure/Barracks/Barracks.tscn"),
	"den": preload("res://src/Structures/BNetStructure/Den/Den.tscn"),
}


func _ready():
	Flow.b_commander = self
	update()
	if hex_grid_path != "":
		hex_grid = get_node(hex_grid_path)


func notify_death(bunny):
	if bunny in selected_units:
		selected_units.erase(bunny)
	if bunny in units_with_selection:
		units_with_selection.erase(bunny)

func update_selection():
	var units_to_remove = []
	for unit in units_with_selection:
		if unit == null:
				units_to_remove.append(unit)
				continue
		if unit in selected_units:
			unit.set_selected()
		else:
			unit.set_deselected()
			units_to_remove.append(unit)

	for unit in selected_units:
		if unit in units_with_selection:
			pass
		else:
			units_with_selection.append(unit)
			unit.set_selected()

	for unit_to_remove in units_to_remove:
		units_with_selection.erase(unit_to_remove)


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
					selected_units = [selected_units[0]]

					var first_unit = selected_units[0]
					if first_unit.has_method("show_upgrades"):
						bunny = first_unit
						first_unit.show_upgrades()
						selecting_upgrades = true

				update_selection()


	elif event is InputEventMouseButton:

		if event.button_index == BUTTON_LEFT :
			#individual_unit_selection(event)
			drag_select(event)

			#dragging = true
			#drag_start = get_global_mouse_position()
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			if selected_units.size() == 1:
				hide_upgrades()
			move_units(selected_units, get_global_mouse_position())

	# Display square while moving mouse
	elif dragging:
		if event is InputEventMouseMotion:
			cursor = get_global_mouse_position()
			update()

func get_units_clicked(p_cursor: Vector2) -> Array:
	select_rect.extents = mouse_click_area
	var space = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(select_rect)
	query.transform = Transform2D(0, cursor)
	var unit_collision = space.intersect_shape(query)

	return unit_collision

func drag_select(event: InputEventMouseButton):
	if event.pressed:
		if structure_selected():
			return
		selected_units = []
		update_selection()
		dragging = true
		drag_start = get_global_mouse_position()
	elif dragging:
		# equals a click
		dragging = false
		drag_end = get_global_mouse_position()
		select_rect.extents = (drag_end - drag_start) / 2
		var space = get_world_2d().direct_space_state
		var query = Physics2DShapeQueryParameters.new()
		query.set_shape(select_rect)
		query.transform = Transform2D(0, (drag_end + drag_start) / 2)
		var units = space.intersect_shape(query)
		selected_units = filter_units(units)
		if drag_end.distance_to(drag_start) < 2 and selected_units.size() > 0:
			print("Emulate click for this")
			selected_units = [selected_units[0]]
		update_selection()
		cursor = drag_end

		update()
		reset_box()

func hide_upgrades():
	for s in selected_units:
		s.hide_upgrades()

func reset_box():
	cursor = Vector2.ZERO
	drag_start = Vector2.ZERO
	drag_end = Vector2.ZERO
	update()

func structure_selected() -> bool:
	if Flow.selected_structure:
		var cell_coordinate = hex_grid.pixel_to_hex(get_global_mouse_position())
		if cell_coordinate == null:
			return true
		var cell = hex_grid.hexagon_coords[cell_coordinate.to_vector()]
		if cell.bnet:
			var structure = structures[Flow.selected_structure].instance()
			Flow.b_net.add_structure(structure, cell_coordinate.to_vector(), cell)
			Flow.selected_structure = null
		return true
	return false

func individual_unit_selection(event: InputEvent):
	if event.pressed:
		if structure_selected():
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

		update_selection()
		drag_start = cursor - (mouse_click_area/2)
		drag_end = cursor + (mouse_click_area / 2)
		update()

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
		print_debug(c.get_state())
		#c.debug_cell()

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
