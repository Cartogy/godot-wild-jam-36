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
	# Get hex coord in vector
	var hex_coord = hex_coord_from.to_vector()
	# Check if hex has directions
	print_debug(edge.build_data())
	if edge_data.has(hex_coord):
		# Get edges in hex
		# { dir0: data0,
		#   dir1: data1,
		# }
		var hex_edges: Dictionary = edge_data[hex_coord]
		# Check if direction is already placed
		var direction = edge.direction
		if hex_edges.has(direction) == false:
			hex_edges[direction] = edge.build_data()
		else:
			printerr("Already contains a barrier")
	else:
		edge_data[hex_coord] = {
			edge.direction: edge.build_data()
		}
			
func remove_edge(hex_coord_from: DoubleCoordinate, edge: EdgeDisplay):
	var hex_coord = hex_coord_from.to_vector()
	if edge_data.has(hex_coord):
		var hex_edges: Dictionary = edge_data[hex_coord]
		if hex_edges.has(edge.direction):
			hex_edges.erase(edge.direction)

func has_edge(hex_coord: Vector2, direction):
	if edge_data.has(hex_coord):
		var hex_edges = edge_data[hex_coord]
		if hex_edges.has(direction):
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
	var data = edge.build_data()
	
	return data
