extends Node2D

var cell_scene = preload("res://src/Grid/Cell/Cell.tscn")
const water_cell_scene = preload("res://src/Grid/Cell/CellScenes/Water.tscn")

export (bool) var DEBUG = false
export (Vector2) var dimensions = Vector2(10,10)

# Where the grid starts
export (Vector2) var origin: Vector2 = Vector2(0,0)
# Move cell to align to real hex position
#var cell_offset: Vector2 = Vector2(0,-8)
var cell_offset: Vector2 = Vector2(0,0)


# How wide/tall a cell will be
# Allows for stretching in both directions as desired
# Increase X -> Streatch horizontally
# Increate Y -> Stretch Vertically

# Default value is according to the sprite
export (Vector2) var size: Vector2 = Vector2(23,16)


# Easy way to store hex coordinates
# Vector2 -> Cell
var hexagon_coords: Dictionary = {}

# Used for debugging hexagons
var hex_corners = []
# Hex converter
var converter: HexConversion = HexConversion.new()

# Double-Width Pointy top
var neighbour_directions = [
	Vector2(2, 0), Vector2(1, -1), Vector2(-1, -1),
	Vector2(-2,0), Vector2(-1, 1), Vector2(1, 1)
]

func _ready():
	pass
	#generate_hex_grid(dimensions, origin, size)

	#fill_neighbours(hexagon_coords, neighbour_directions)

func load_level_grid(level: LevelData, bnet: BNet, mnet: MNet, dimension: Vector2):
	var p_size = size

	for y in dimension.y:
		var row_mod = y % 2
		var row = y

		for x in dimension.x:
			var col = (x * 2) + row_mod
			var d_coord = DoubleCoordinate.new(row, col)

			if level.level_data.has(d_coord.to_vector()):
				create_level_cell(level.level_data[d_coord.to_vector()], bnet, mnet)
			else:
				var water_cell = water_cell_scene.instance()
				var center = converter.doublewidth_to_pixel(d_coord, origin, p_size)

				water_cell.global_position = center
				add_child(water_cell)
				hexagon_coords[d_coord.to_vector()] = water_cell

	fill_neighbours(hexagon_coords, neighbour_directions)
			

func create_level_cell(cell_data: Dictionary, bnet: BNet, mnet: MNet):
	var hex_coord: Vector2 = cell_data.hex_coord
	var cell_scene_path = cell_data.scene_path
	var structure_path = cell_data.structure_path
	var special_res_path = cell_data.spec_resource_path
	var cell_position = cell_data.cell_position
	
	var center = converter.doublewidth_to_pixel(DoubleCoordinate.new(hex_coord.y, hex_coord.x), origin, size)

	var cell_pack = load(cell_scene_path)
	var cell = cell_pack.instance()
	cell.global_position = center
	cell.hex_coords = hex_coord
	cell.real_hex_center = center
	cell.hex_size = size

	# Check if structure
	if structure_path != "":
		var structure_packed: PackedScene = load(structure_path)
		var structure: CellStructure = structure_packed.instance()
		cell.bnet = bnet

		match structure.structure_id:
			"den":
				bnet.add_structure(structure, hex_coord, cell)
			"gunner":
				mnet.add_structure(structure, hex_coord, cell)


	# Check if special res
	if special_res_path != "":
		var special_res = load(special_res_path)
		cell.special_res = special_res
	hexagon_coords[hex_coord] = cell
	add_child(cell)


func pixel_to_hex(cursor: Vector2):
	var frac_doubled = converter.pixel_to_doublewidth(cursor, origin, size)

	# Round Hex Coords
	#var axial = AxialCoordinate.new(q, r)
	var cube = converter.doublewidth_to_cube(frac_doubled)
	var round_cube = converter.cube_round(cube)



	# Convert back to original coordinate system
	var double_width = converter.cube_to_double_width(round_cube)
	print_debug(double_width.to_vector())

	return double_width

func display_hex_grid(origin: Vector2):
	var dimension = dimensions
	var p_size = size
	
	for y in dimension.y:
		var row_mod = y % 2
		var row = y
		
		for x in dimension.x:
			var col = (x * 2) + row_mod
			var d_coord = DoubleCoordinate.new(row,col)
			# Ensure property holds for double width coordinate
			assert((col + row) % 2 == 0)
			
			var center = converter.doublewidth_to_pixel(d_coord, origin, p_size)
			var corners = make_hex_corners(center, p_size)
			hex_corners.append(corners)
	update()

func generate_hex_grid(dimension: Vector2, origin: Vector2, p_size: Vector2):

	for y in dimension.y:
		# Shifted or Unshifted Row
		var row_mod = y % 2
		var row = y
		for x in dimension.x:
			# Column coordinate based on Doubled-coordinate
			var col = (x * 2) + row_mod
			var d_coord = DoubleCoordinate.new(row,col)
			# Ensure property holds for double width coordinate
			assert((col + row) % 2 == 0)

			var center = converter.doublewidth_to_pixel(d_coord, origin, p_size)


			# Store Cells
			var cell = create_cell(center, cell_offset, size,d_coord)
			add_cell(cell)
			# Map hexagon coord to cell
			hexagon_coords[Vector2(col, row)] = cell

			# Display 'Real' Hex positions
			if DEBUG:
				var corners = make_hex_corners(center, p_size)
				hex_corners.append(corners)
	if DEBUG:
		update()

func create_cell(center: Vector2, offset: Vector2, p_size: Vector2, d_coord: DoubleCoordinate):
	var cell = cell_scene.instance()
	cell.real_hex_center = center
	cell.position = center+cell_offset
	cell.hex_size = p_size
	cell.hex_coords = d_coord.to_vector()

	return cell

func add_cell(cell):
	add_child(cell)

func get_cell(hex_coord: Vector2) -> Cell:
	if hexagon_coords.has(hex_coord):
		return hexagon_coords.get(hex_coord)
	else:
		return null

# Connects each cell to their respective neighbours
func fill_neighbours(hex_map: Dictionary, directions: Array):
	for coord in hex_map.keys():
		var cell = hex_map.get(coord)
		# Check all directions in a cell
		for dir in directions:
			if hex_map.has(coord + dir):
				var neighbour = hex_map[coord+dir]
				cell.add_neighbour(neighbour)


##############
## UTIL
##############

# used for limiting the camera's navigation
func get_grid_bounds() -> Rect2:
	var minimum_x = 9999999
	var maximum_x = -99999999
	var minimum_y = 99999999
	var maximum_y = -9999999
	for cell in hexagon_coords.values():
		if cell.position.x < minimum_x:
			minimum_x = cell.position.x
		if cell.position.y < minimum_y:
			minimum_y = cell.position.y
		if cell.position.x > maximum_x:
			maximum_x = cell.position.x
		if cell.position.y > maximum_y:
			maximum_y = cell.position.x
	return Rect2(minimum_x, minimum_y, maximum_x - minimum_x, maximum_y - minimum_y)

###############
## DEBUG ZONE
###############
# Debug Hex
func _draw():
	#print_debug(hex_corners)
	for c in hex_corners:
		_draw_hex(c)

func make_hex_corners(center: Vector2, c_size: Vector2):
	var corners = []
	for x in range(1,7):
		corners.append(pointy_hex_corner(center, c_size, x))
	return corners

func pointy_hex_corner(center: Vector2, c_size: Vector2, corner_id: int):
	var angle_deg = 60 * corner_id - 30
	var angle_rad = PI / 180 * angle_deg

	return Vector2(center.x + c_size.x * cos(angle_rad), center.y + c_size.y * sin(angle_rad))


func _draw_hex(corners: Array):
	var index = 0
	for c in range(1, corners.size()):
		var c0 = corners[c-1]
		var c1 = corners[c]
		draw_line(c0, c1, Color(1,1,1,1))

	# Complete the Hexagon
	draw_line(corners[0], corners[corners.size()-1], Color(1,1,1,1))


