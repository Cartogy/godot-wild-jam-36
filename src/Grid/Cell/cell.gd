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

# BNet variables to use
var consumed: bool = false
# If containing a cell to consume, this cell is a production cell.
# TODO: Refactor into its own component
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
	# Currently acquiring a cell
	if current_cell_consumption != null:
		emit_signal("consumption_complete", self, current_cell_consumption)
	
func find_neighbour_to_consume():
	for n in neighbours:
		if n.consumed == false:
			return n
	return null

# Breadth-Search
# TODO: Refactor out onto a seperate component or something. Ideally only buildings (Dens) will allow this kind of behaviour.
func breadth_search_neighbours():
	# Store neighbours to search
	var ns_queue = []
	var visited: Dictionary
	
	# Start of algorithm
	ns_queue.append(self)

	# Invariant
	while ns_queue.empty() == false:
		# Look at first cell
		var c = ns_queue.pop_front()
		# No need to look at it again
		visited[c] = true
		
		# Get cell's neighbours
		var cell_neighbours: Array = c.neighbours
		
		var neighbour_size = cell_neighbours.size()
		# Array to remove neighbours when searching for a random neighbour
		var choosing_array = []
		# Fill array
		for n in cell_neighbours:
			choosing_array.append(n)
		
		# Allow random neighbour selection
		randomize()
		var amount_left = neighbour_size
		# Go over the neighbours in a random manner
		while amount_left > 0:
			var random_index = randi() % amount_left
			var cell_rand = choosing_array[random_index]
			
			# Found neighbour to acquire next
			if cell_rand.consumed == false:
				return cell_rand
			else:	
				# Investigate later, if not already visited
				if visited.has(cell_rand) == false:
					ns_queue.append(cell_rand)
			# remove random cell. No need to look at it again.
			# Avoids getting the same cell twice.
			choosing_array.erase(cell_rand)
			
			amount_left -= 1
			
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
