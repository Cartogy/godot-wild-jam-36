extends Node2D

var cell_scene = preload("res://src/Grid/Cell/Cell.tscn")

export (bool) var DEBUG = false
export (float) var cell_size = 1
export (Vector2) var dimensions = Vector2(10,10)

# Helps when convertin from Pixel to Hex coordinate
var orientation
# Where the grid starts
var origin: Vector2 = Vector2(50,-50)
var cell_offset: Vector2 = Vector2(0,-8)
# How wide/tall a cell will be
# Allows for stretching in both directions as desired

# Increase X -> Streatch horizontally
# Increate Y -> Stretch Vertically

var size: Vector2 = Vector2(50,50)


# Stores all cells in an array. Double width (Pointy)
var pointy_hexagon_storage: Array = []

var hex_corners = []

# How many cells


func _ready():
	generate_hex_grid(dimensions, origin, Vector2(23,16))
	
func _draw():
	print_debug(hex_corners)
	for c in hex_corners:
		_draw_hex(c)

func generate_hex_grid(dimension: Vector2, origin: Vector2, p_size: Vector2):
	for x in dimension.x:
		var row_mod = x % 2
		var row = x
		for y in dimension.y:
			var col = (y * 2) + row_mod
			var d_coord = DoubledHexCoordinate.new([x, col])
			
			var center = doublewidth_to_pixel(origin, d_coord, p_size)
			
			var cell = cell_scene.instance()
			cell.position = center + cell_offset
			add_child(cell)
			
			if DEBUG:
				var corners = make_hex_corners(center, p_size)
				hex_corners.append(corners)
	if DEBUG:
		update()


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

# Converts the Doubled-Width coordinaate (Pointy top) onto pixel screen
func doublewidth_to_pixel(grid_origin: Vector2, coord: HexCoordinates, p_size: Vector2) -> Vector2:
	var hex_coord: DoubledHexCoordinate = coord
	var row = hex_coord.coordinates[0]
	var col = hex_coord.coordinates[1]
	
	var x = p_size.x * sqrt(3)/2 * col
	var y = p_size.y * 3/2 * row
	
	return Vector2(x + grid_origin.x, y - grid_origin.y)
