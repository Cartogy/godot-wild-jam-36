extends Node2D

var cell_scene = preload("res://src/Grid/Cell/Cell.tscn")

# Helps when convertin from Pixel to Hex coordinate
var orientation
# Where the grid starts
var origin: Vector2 = Vector2(0,0)
# How wide/tall a cell will be
# Allows for stretching in both directions as desired

# Increase X -> Streatch horizontally
# Increate Y -> Stretch Vertically
# Percentages!

# 1 * 10 => 1000% * 1
# 1 * 1 => 100% * 1
var size: Vector2 = Vector2(20,20)
export (float) var cell_size = 1

# Stores all cells by their hex coordinate
var cell_storage: Dictionary

# How many cells
export (Vector2) var dimensions = Vector2(40,10)

func _ready():
	_generate_grid(dimensions, null, origin, size)

# Generates a rectangular grid
func _generate_grid(p_dimension: Vector2, _p_orientation: HexOrientation, _p_origin: Vector2, p_size: Vector2):
	# Generate Pointy grid
	var horizontal_spacing = sqrt(3) * cell_size
	var vertical_spacing = (2 * cell_size) * 3/4

	var horizontal_offset = sqrt(3) * (cell_size * p_size.x)

	for row in range(0, p_dimension.y):
		var row_coord = (row * vertical_spacing) * p_size.y
		for col in range(0, p_dimension.x):
			var col_coord = (col * horizontal_spacing) * p_size.x + (horizontal_offset * (row % 2))
			var cell_position = Vector2(col_coord, row_coord)
			var instance_cell = cell_scene.instance()

			instance_cell.position = cell_position
			add_child(instance_cell)

			 

