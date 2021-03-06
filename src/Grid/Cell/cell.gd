extends Node2D
class_name Cell


export (Texture) var available_texture
export (Texture) var bnet_texture
export (Texture) var water_texture
export (Texture) var debug_texture

export (String) var starting_state = ""

onready var state_machine = $StateMachine
onready var bunnies = $BunnyFill
onready var resources = $CellResources
onready var sprite = $Sprite

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
# Direction -> Edge
var structure: CellStructure


# BNet variables to use
var consumed: bool = false
var bnet
# If containing a cell to consume, this cell is a production cell.
# TODO: Refactor into its own component
var current_cell_consumption


## DATA
var edge_data = CellEdgeData.new()

signal consumption_complete(from, neighbour)
signal new_bunny(to_cell)
signal get_resources(resources)

# Level notification for BNet
signal consumed_cell()
signal lost_cell()

func _ready():
	state_machine.setup_state_machine()
	if starting_state != "":
		state_machine.change_state(starting_state)

func add_neighbour(cell):
	neighbours.append(cell)

func show_neighbours():
	for n in neighbours:
		n.debug_cell()

func hide_neighbours():
	for n in neighbours:
		n.available_cell()

func pointy_hex_corner(center: Vector2, c_size: Vector2, corner_id: int):
	var angle_deg = 60 * corner_id - 30
	var angle_rad = PI / 180 * angle_deg

	return Vector2(center.x + c_size.x * cos(angle_rad), center.y + c_size.y * sin(angle_rad))

func get_hex_center() -> Vector2:
	return real_hex_center - self.global_position

func being_attacked(bunny):
	if structure != null:
		structure.being_attacked_by(bunny)

func not_being_attacked_by(bunny):
	if structure != null:
		structure.not_being_attacked_by(bunny)

func bunny_nearby(bunny):
	print_debug("bunny_nearby")
	# To implement if needed
	if structure != null:
		pass


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
			elif cell_rand.state_machine.current_state.name == "BNet" and cell_rand.bunnies.reached_max_capacity() == false:
				return cell_rand
			else:
				# Investigate later, if not already visited
				if visited.has(cell_rand) == false and cell_rand.state_machine.current_state.name != "Water":
					ns_queue.append(cell_rand)
			# remove random cell. No need to look at it again.
			# Avoids getting the same cell twice.
			choosing_array.erase(cell_rand)

			amount_left -= 1

	return null

func set_texture(tex: Texture):
	sprite.texture = tex

###############
## Bunny Fill
###############

func remove_all_bunnies():
	bunnies.remove_all_bunnies()

func remove_bunny_amount(amount: int):
	bunnies.delete_bunnies(amount)

func has_bunnies():
	return bunnies.has_bunnies()

func add_bunny(bunny):
	pass

###############
## Structures
###############

func structure_destroyed():
	if structure != null:
		set_texture(structure.conquered_sprite)
		conquered_cell()

func has_structure():
	return structure != null

func structure_is_alive():
	return structure.health >0

func damage_structure(amount: int):
	if structure_is_alive():
		structure.damage(amount)
	else:
		structure_destroyed()

##############
## Resources
##############

func add_special_resource(special_res: CellSpecialResource):
	resources.add_special_res(special_res)
	set_texture(special_res.res_texture)

##############
## Edges
###############

func add_edge(direction: Vector2):
	edge_data.add_edge(direction, self)

func remove_edge(direction: Vector2):
	edge_data.remove_edge(direction, self)

func has_edge(direction: Vector2):
	return edge_data.has_edge(direction)

################
## State
################

func get_state() -> String:
	return state_machine.current_state.name

func bnet_produce():
	state_machine.change_state("BNetProduction")

func bnet_acquire(p_bnet):
	bnet = p_bnet
	if get_state() != "BNet":
		state_machine.change_state("BNet")

func available_cell():
	state_machine.change_state("Available")

func opposing_cell():
	state_machine.change_state("Opposing")

func water_cell():
	state_machine.change_state("Water")

func debug_cell():
	state_machine.change_state("Debug")

func conquered_cell():
	state_machine.change_state("Conquered")

################
## DEBUG ZONE
################
func begin_neighbour_drawing():
	pass
	#update()

func _draw_neighbours():
	for n in neighbours:
		# Get center of neighbour
		var center_n = n.position
		# draw line from cell to center of neighbour
		draw_line(real_hex_center, center_n - self.global_position, Color(0.5,0.5,0.5))


func _draw():
	pass
	#draw_circle(real_hex_center, 2, Color(1,0,0))
	#_draw_neighbours()

func bnet_tex():
	if resources.has_special_res():
		var tex = resources.special_res.get_bnet_consumed_texture()
		if resources.special_res.consumed():
			set_texture(resources.special_res.get_consumed_stationary_texture())
		else:
			set_texture(tex)
	else:
		set_texture(bnet_texture)

func available_tex():
	var tex
	if resources.has_special_res():
		if resources.consumed_special_res():
			tex = resources.special_res.get_consumed_texture()
		else:
			tex = resources.special_res.get_res_texture()
		set_texture(tex)
	else:
		set_texture(available_texture)

func water_tex():
	sprite.texture = water_texture

func conquered_tex(tex):
	set_texture(tex)

func debug_tex():
	sprite.texture = debug_texture
