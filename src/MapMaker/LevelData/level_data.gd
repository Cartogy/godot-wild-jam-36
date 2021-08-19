extends Resource
class_name LevelData

export (Dictionary) var level_data: Dictionary = {}
export (Vector2) var grid_origin: Vector2

func add_cell(hex_coord: DoubleCoordinate, cell: Cell, structure_path: String, scene_path: String):
	
	if level_data.has(hex_coord.to_vector()):
		var old_cell = level_data[hex_coord.to_vector()]
		level_data.erase(hex_coord.to_vector())
		
	var dict_values = create_dictionary(hex_coord.to_vector(), cell, scene_path)
	level_data[hex_coord.to_vector()] = dict_values

func create_dictionary(hex_coord: Vector2, cell: Cell, scene_path: String) -> Dictionary:
	var template = {
		"hex_coord": hex_coord,
		"scene_path": scene_path,
		"cell_position": cell.global_position
	}
	
	return template
