extends Resource
class_name LevelData

export (Dictionary) var level_data: Dictionary = {}
export (Vector2) var grid_origin: Vector2

func clear():
	level_data.clear()

func add_cell(hex_coord: DoubleCoordinate, cell: TileDisplay):
	
	if level_data.has(hex_coord.to_vector()):
		var old_cell = level_data[hex_coord.to_vector()]
		level_data.erase(hex_coord.to_vector())
		
	var dict_values = create_dictionary(hex_coord.to_vector(), cell)
	level_data[hex_coord.to_vector()] = dict_values

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
