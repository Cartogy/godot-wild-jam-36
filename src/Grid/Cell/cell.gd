extends Node2D
class_name Cell


export (Texture) var default
export (Texture) var display

onready var state_machine = $StateMachine
onready var bunnies = $BunnyFill
onready var resources = $CellResources

## This cell is a D

var neighbour_directions = [
	Vector2(2, 0), Vector2(1, -1), Vector2(-1, -1),
	Vector2(-2,0), Vector2(-1, 1), Vector2(1, 1)
]


var hex_size: Vector2
# Hex coordinate system
var hex_coords: Vector2
# Center in coordinat system
# The cell's position might be offseted by the grid to compensate
# for the sprite.
var real_hex_center: Vector2
var neighbours: Array = []



# BNet variables to use
var consumed: bool = false
# If containing a cell to consume, this cell is a production cell.
# TODO: Refactor into its own component
var current_cell_consumption



signal consumption_complete(from, neighbour)
signal new_bunny(to_cell)
signal get_resources(resources)

func _ready():
	state_machine.setup_state_machine()

func add_neighbour(cell):
	neighbours.append(cell)

func show_neighbours():
	for n in neighbours:
		n.triggered()

func hide_neighbours():
	for n in neighbours:
		n.deselect()

func pointy_hex_corner(center: Vector2, c_size: Vector2, corner_id: int):
	var angle_deg = 60 * corner_id - 30
	var angle_rad = PI / 180 * angle_deg

	return Vector2(center.x + c_size.x * cos(angle_rad), center.y + c_size.y * sin(angle_rad))

func get_hex_center() -> Vector2:
	return real_hex_center - self.global_position

###############
# BNET Interface
###############

func tick():
	if state_machine.current_state.name == "BNetProduction":
		state_machine.current_state.tick()

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
			if cell_rand.state_machine.current_state.name == "Available":
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
###############
## BNet
###############



################
## State
################

func bnet_produce():
	state_machine.change_state("BNetProduction")

func bnet_acquire():
	state_machine.change_state("BNet")

func available_cell():
	state_machine.change_state("Available")

func opposing_cell():
	state_machine.change_state("Opposing")

func water_cell():
	state_machine.change_state("Water")


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
