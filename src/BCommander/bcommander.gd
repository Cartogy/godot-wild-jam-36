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
			clear_units()
			
			cursor = get_global_mouse_position()
			
			var unit_collision = get_units_clicked(cursor)
			selected_units = filter_units(unit_collision)
			if selected_units.size() > 0 && selecting_upgrades:
				selecting_upgrades = false
				if is_instance_valid(bunny) == false:
					bunny = null
			
			
			print_debug(selected_units)
			print_debug(units_in_tiles)
			
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
	
	for cell in units_in_tiles.keys():
		var us: Array = units_in_tiles[cell]
		var individual_paths = {
			"bunny": [],
			"scubabunny": [],
		}
		for u in us:
			# Bunny movement
			if u is Bunny:
				if individual_paths["bunny"].size() == 0:
					var paths = HexPath.path_finding(cell, goal_cell, false, u.obstacles)
					individual_paths["bunny"] = paths
					print_debug(paths)
					show_path(paths)
				u.move_to(individual_paths["bunny"])
			elif u is BoxerBunny:
				if individual_paths["bunny"].size() == 0:
					var paths = HexPath.path_finding(cell, goal_cell, false, u.obstacles)
					individual_paths["bunny"] = paths
				u.move_to(individual_paths["bunny"])
			else:
				printerr("Invalid bunny")


func filter_units(units: Array) -> Array:
	var us = []
	units_in_tiles.clear()
	for u in units:
		var unit = u.collider
		if unit is TileEntity:
			if unit.selectable:
				var cell = unit.cell
				if units_in_tiles.has(cell):
					var u_in_cell: Array = units_in_tiles[cell]
					u_in_cell.append(unit)
				else:
					units_in_tiles[cell] = [unit]

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
