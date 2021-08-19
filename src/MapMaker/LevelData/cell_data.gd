extends Resource
class_name CellData


export (String) var cell_state: String
export (String) var cell_path: String
export (String) var structure_path: String
export (Vector2) var cell_position: Vector2

func _init(p_cell_state, p_cell_path, p_struct_path, p_cell_position):
	cell_state = p_cell_state
	cell_path = p_cell_path
	structure_path = p_struct_path
	cell_position = p_cell_position

