extends BNetStructure
class_name DenStructure

# Notify level
signal became_inept
signal no_longer_inept

enum States { INEPT, PRODUCING}
var state

var consuming_cell
var bnet




func _ready():
	structure_id = "den"
	state = States.PRODUCING

func add_to_bnet(p_bnet):
	bnet = p_bnet
	# Make sure it produces in its current cell
	consuming_cell = cell

func starting_structure():
	cell.bnet_acquire(bnet)

func tick():
	if consuming_cell.bunnies.reached_max_capacity():
		#consuming_cell.triggered()
		cell_consumed(cell, consuming_cell)
	else:
		#consuming_cell.add_bunny()
		add_bunny(consuming_cell)


func add_consuming_cell(p_cell: Cell):
	consuming_cell = p_cell
	consuming_cell.bnet_acquire(bnet)
	add_bunny(consuming_cell)

func cell_consumed(from: Cell, cell_consumed: Cell):
	bnet.consumed_cells[cell_consumed.hex_coords] = cell_consumed
	var next_cell = self.breadth_search_neighbours(from)


	if next_cell != null:
		# Found a cell to produce
		if state != States.PRODUCING:
			state_to_producing()
		add_consuming_cell(next_cell)
	else:
		# Did not find cell to produce
		if state != States.INEPT:
			state_to_inept()


func add_bunny(to: Cell):
	var real_hex_center = to.real_hex_center
	var hex_coords = to.hex_coords

	if to.state_machine.current_state.name == "BNet":
		to.bunnies.add_bunny(real_hex_center, hex_coords, bnet)
	elif to.state_machine.current_state.name == "Available":
		to.bnet_acquire(bnet)
		to.bunnies.add_bunny(real_hex_center, hex_coords, bnet)
	else:
		var next_cell = cell.breadth_search_neighbours()
		if next_cell != null:
			add_consuming_cell(next_cell)

func state_to_inept():
	emit_signal("became_inept")

func state_to_producing():
	emit_signal("no_longer_inept")


#############
## Path finding for next cell
#############

func has_edge(from: Cell, to: Cell):
	var direction = to.hex_coords - from.hex_coords
	return from.has_edge(direction)

func breadth_search_neighbours(from: Cell):
	# Store neighbours to search
	var ns_queue = []
	var visited: Dictionary

	# Start of algorithm
	ns_queue.append(from)

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

			if has_edge(c, cell_rand) == false:
			# Found neighbour to acquire next
				#if cell_rand.state_machine.current_state.name == "Available":
				#	return cell_rand
				if cell_rand.state_machine.current_state.name == "BNet" and cell_rand.bunnies.reached_max_capacity() == false:
					return cell_rand
				else:
					# Investigate later, if not already visited
					if visited.has(cell_rand) == false and (cell_rand.get_state() != "Water" and cell_rand.get_state() != "Military"):
						ns_queue.append(cell_rand)
				# remove random cell. No need to look at it again.
				# Avoids getting the same cell twice.
				choosing_array.erase(cell_rand)

			amount_left -= 1

	return null
