extends Node2D

var cell_scene = preload("res://src/Grid/Cell/Cell.tscn")

export (bool) var DEBUG = false
export (Vector2) var dimensions = Vector2(10,10)

# Where the grid starts
export (Vector2) var origin: Vector2 = Vector2(0,0)
# Move cell to align to real hex position
var cell_offset: Vector2 = Vector2(0,-8)


# How wide/tall a cell will be
# Allows for stretching in both directions as desired
# Increase X -> Streatch horizontally
# Increate Y -> Stretch Vertically

# Default value is according to the sprite
export (Vector2) var size: Vector2 = Vector2(23,16)


# Easy way to store hex coordinates
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
	generate_hex_grid(dimensions, origin, size)
		
	fill_neighbours(hexagon_coords, neighbour_directions)

func pixel_to_hex(cursor: Vector2):
	#var pt = Vector2(
	#			(cursor.x - origin.x) / size.x,
	#			(cursor.y + origin.y) / size.y
	#		)
	var frac_doubled = converter.pixel_to_doublewidth(cursor, origin, size)
	
	# Round Hex Coords
	#var axial = AxialCoordinate.new(q, r)
	var cube = converter.doublewidth_to_cube(frac_doubled)
	var round_cube = converter.cube_round(cube)

	
	
	# Convert back to original coordinate system
	var double_width = converter.cube_to_double_width(round_cube)
	print_debug(double_width.to_vector())
	
	return double_width
			

func generate_hex_grid(dimension: Vector2, origin: Vector2, p_size: Vector2):
	
	for y in dimension.y:
		# Shifted or Unshifted Row
		var row_mod = y % 2
		var row = y
		for x in dimension.x:
			# Column coordinate based on Doubled-coordinate
			var col = (x * 2) + row_mod
			var d_coord = DoubleCoordinate.new(row,col)
			assert((col + row) % 2 == 0)
			
			var center = converter.doublewidth_to_pixel(d_coord, origin, p_size)
			
			
			# Store Cells
			var cell = create_cell(center, cell_offset)
			add_cell(cell)
			# Map hexagon coord to cell
			hexagon_coords[Vector2(col, row)] = cell
			
			# Display 'Real' Hex positions
			if DEBUG:
				var corners = make_hex_corners(center, p_size)
				hex_corners.append(corners)
	if DEBUG:
		update()

func create_cell(center: Vector2, offset: Vector2):
	var cell = cell_scene.instance()
	cell.real_hex_center = center
	cell.position = center+cell_offset
	
	return cell

func add_neighbours(cell: Cell, storage: Array, current_row: Array, x: int, y: int):
	var storage_size = storage.size()
	# Horizontal Neight on its left
	if x != 0:
		var horizontal_neighbour = current_row[x-1]
		cell.add_neighbour(horizontal_neighbour)
	# Neighbours ontop
	if storage_size != 0:
		var prev_row = storage[storage_size-2]
		var top_left_neighbour = prev_row[x]
		cell.add_neighbour(top_left_neighbour)
		
		# May not be a top right neighbour
		if x+1 < prev_row.size():
			var top_right_neighbour = prev_row[x+1]
			cell.add_neighbour(top_right_neighbour)
	
	
func add_cell(cell):
	add_child(cell)
	
func get_cell(hex_coord: Vector2) -> Cell:
	return hexagon_coords.get(hex_coord)
	
func fill_neighbours(hex_map: Dictionary, directions: Array):
	for coord in hex_map.keys():
		var cell = hex_map.get(coord)
		# Check all directions in a cell
		for dir in directions:
			if hex_map.has(coord + dir):
				var neighbour = hex_map[coord+dir]
				cell.add_neighbour(neighbour)
			
	
	
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


