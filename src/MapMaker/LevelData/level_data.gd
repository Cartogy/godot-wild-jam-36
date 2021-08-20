extends Resource
class_name LevelData

export (Dictionary) var level_data: Dictionary = {}
#
export (Dictionary) var edge_data: Dictionary = {}
export (Vector2) var grid_origin: Vector2

var temp_edge_data: Dictionary = {}

func clear():
	level_data.clear()

func add_cell(hex_coord: DoubleCoordinate, cell: TileDisplay):
	
	if level_data.has(hex_coord.to_vector()):
		var _old_cell = level_data[hex_coord.to_vector()]
		level_data.erase(hex_coord.to_vector())
		
	var dict_values = create_dictionary(hex_coord.to_vector(), cell)
	level_data[hex_coord.to_vector()] = dict_values
	
func add_edge(hex_coord_from: DoubleCoordinate, edge: EdgeDisplay):
	var from = hex_coord_from.to_vector()
	
	if edge_data.has(from):
		var direction = edge.direction
		if edge_data.get(from).has(direction):
			edge_data.get(from).erase(direction)
		else:
			edge_data.get(from.append(direction))
	else:
		var data = create_edge_data(edge)
		var dir_data = {
			edge.direction: data
		}
		edge_data[from] = [edge.direction]

func has_edge(hex_coord: Vector2, direction):
	if edge_data.has(hex_coord):
		for dir in edge_data[hex_coord]:
			if direction == dir:
				return true
	return false

func create_dictionary(hex_coord: Vector2, cell: TileDisplay) -> Dictionary:
	var template = {
		"hex_coord": hex_coord,
		"scene_path": cell.cell_scene_path,
		"structure_path": cell.structure_scene_path,
		"spec_resource_path": cell.resource_path,
		"cell_position": cell.global_position,
		"tile_display": cell.self_scene,
	}
	
	return template

func create_edge_data(edge: EdgeDisplay) -> Dictionary:
	var template = {
		"edge_scene": edge.edge_scene,
		"display_scene": edge.self_scene,
		"direction": edge.direction
		
	}
	
	return template
