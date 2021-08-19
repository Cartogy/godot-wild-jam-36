extends Resource

var level_data: Dictionary = {}

func add_cell(hex_coord: Vector2, cell: Cell, structure_path: String):
	var cell_data = CellData.new(cell.state_machine.current_state.name, structure_path)
	
	if level_data.has(hex_coord):
		var old_cell = level_data[hex_coord]
		level_data.erase(hex_coord)
	level_data[hex_coord] = cell_data
