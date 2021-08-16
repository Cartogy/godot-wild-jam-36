extends Node2D
class_name Cell

## This cell is a D

var neighbour_directions = [
	Vector2(2, 0), Vector2(1, -1), Vector2(-1, -1),
	Vector2(-2,0), Vector2(-1, 1), Vector2(1, 1)
]

var hex_coords: HexCoordinates = null
var real_hex_center: Vector2
var neighbours: Array = []

export (Texture) var default
export (Texture) var display

func _ready():
	pass

func add_neighbour(cell):
	neighbours.append(cell)

func show_neighbours():
	for n in neighbours:
		n.triggered()

func hide_neighbours():
	for n in neighbours:
		n.deselect()

################
## DEBUG ZONE
################
func begin_neighbour_drawing():
	update()

func _draw_neighbours():
	for n in neighbours:
		# Get center of neighbour
		var center_n = n.position
		# draw line from cell to center of neighbour
		draw_line(real_hex_center - self.global_position, center_n - self.global_position, Color(0.5,0.5,0.5))

		
func _draw():
	draw_circle(real_hex_center-self.global_position, 2, Color(1,0,0))
	_draw_neighbours()

func triggered():
	$Sprite.texture = display
	
func deselect():
	$Sprite.texture = default
