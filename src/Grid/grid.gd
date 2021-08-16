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


# Stores all cells in an array. Double width (Pointy)
var pointy_hexagon_storage: Array = []

# Used for debugging hexagons
var hex_corners = []
# Hex converter
var converter: HexConversion = HexConversion.new()


func _ready():
	generate_hex_grid(dimensions, origin, size)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print_debug(event.position)
			
			# Move point to originate from (0,0)
			# Compensates for the shift and stretching done.
			var pt = Vector2(
				(event.position.x - origin.x) / size.x,
				(event.position.y + origin.y) / size.y
			)
			
			# Pixel to Axial Coordinates
			#var q = sqrt(3)/3.0 * pt.x - 1.0/3.0
			#var r = 2.0/3.0 * pt.y
			
			var frac_doubled = converter.pixel_to_doublewidth(event.position, origin, size)
			
			# Round Hex Coords
			#var axial = AxialCoordinate.new(q, r)
			var cube = converter.doublewidth_to_cube(frac_doubled)
			var round_cube = converter.cube_round(cube)

			
			
			# Convert back to original coordinate system
			var double_width = converter.cube_to_double_width(round_cube)
			print_debug(double_width.to_vector())
			

func generate_hex_grid(dimension: Vector2, origin: Vector2, p_size: Vector2):
	for x in dimension.x:
		# Shifted or Unshifted Row
		var row_mod = x % 2
		
		var row = x
		for y in dimension.y:
			# Column coordinate based on Doubled-coordinate
			var col = (y * 2) + row_mod
			var d_coord = DoubleCoordinate.new(row,col)
			assert((col + row) % 2 == 0)
			
			print_debug([col,row])
			var center = converter.doublewidth_to_pixel(d_coord, origin, p_size)
			
			add_cell(center, cell_offset)
			
			# Display 'Real' Hex positions
			if DEBUG:
				var corners = make_hex_corners(center, p_size)
				hex_corners.append(corners)
	if DEBUG:
		update()
		

func add_cell(center: Vector2, offset: Vector2):
	var cell = cell_scene.instance()
	cell.position = center+cell_offset
	
	add_child(cell)
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


