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

var consumed: bool = false
var current_cell_consumption

signal consumption_complete(from, neighbour)

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
		
###############
# BNET Interface
###############

func tick():
	if current_cell_consumption != null:
		emit_signal("consumption_complete", self, current_cell_consumption)
	
func find_neighbour_to_consume():
	for n in neighbours:
		if n.consumed == false:
			return n
	return null

func breadth_search_neighbours():
	# Store neighbours of current cell
	var ns_queue = []
	# Start of algorithm
	var visited: Dictionary
	
	
	ns_queue.append(self)
	while ns_queue.empty() == false:
		var c = ns_queue.pop_front()
		visited[c] = true
		
		var cell_neighbours: Array = c.neighbours
		
		var neighbour_size = cell_neighbours.size()
		var choosing_array = []
		# playground
		for n in cell_neighbours:
			choosing_array.append(n)
		
		randomize()
		var amount_left = neighbour_size
		# Go over the neighbours in a random manner
		while amount_left > 0:
			var random_index = randi() % amount_left
			var cell_rand = choosing_array[random_index]
			
			if cell_rand.consumed == false:
				return cell_rand
			else:
				if visited.has(cell_rand) == false:
					ns_queue.append(cell_rand)
			
			choosing_array.erase(cell_rand)
			
			amount_left -= 1
			
		# Search cell neighbours
		#for n in cell_neighbours:
		#	var cell_n: Cell = n
		#	if cell_n.consumed:		# store to search its neighbours later
		#		ns_queue.append(cell_n)
		#	else:	# Found next cell to consume
		#		return cell_n
		# Remove current cell from queue
		
	#
	return null

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
	consumed = true
	
func deselect():
	$Sprite.texture = default
