extends Node

"""
Stores bunnies on tile
"""
export (int) var max_bunnies = 7
var bunny_scene = preload("res://src/TileEntities/Bunnies/Bunny/Bunny.tscn")


# Store all bunnies
var bunnies_in_tile: Array = []

# Percentage for positions
var default_percentage = 0.30
var percentage_increase = 0.20

func _ready():
	pass

func reached_max_capacity():
	return max_bunnies == bunnies_in_tile.size()

func calc_direction_placement() -> Vector2:
	var cell: Cell = get_owner()
	var hex_center = cell.global_position
	var hex_size = cell.hex_size
	var bunny_id = bunnies_in_tile.size() + 1

	var vector_to_position = get_cell_position(hex_center, hex_size, bunny_id, default_percentage, percentage_increase)

	return vector_to_position

func add_bunny(center: Vector2, hex_coord: Vector2, bnet):
	var cell: Cell = get_owner()
	var bunny: Bunny = bunny_scene.instance()
	var hex_center = cell.global_position
	var hex_size = cell.hex_size
	var bunny_id = bunnies_in_tile.size() + 1	# +1, the new bunny

	var vector_to_position = get_cell_position(hex_center, hex_size, bunny_id, default_percentage, percentage_increase)
	bunny.global_position = vector_to_position + hex_center
	bunny.hex_center = hex_center
	bunny.hex_coord = hex_coord
	# connect to system
	bunny.bnet = bnet
	bunny.cell = cell
	bunny.z_index = 1

	# Conquer cell and consume resources
	if bunnies_in_tile.size() == 0:
		cell.bnet_acquire(bnet)


	bunnies_in_tile.append(bunny)


	bnet.add_child(bunny)
	AudioEngine.play_effect("spawn")

func append_bunny(bunny):
	bunnies_in_tile.append(bunny)

func has_bunnies():
	return bunnies_in_tile.size() > 0

func place_bunny_on_cell(bunny):
	var cell: Cell = get_owner()
	var hex_center = cell.global_position
	var hex_size = cell.hex_size

	# Check if bunny already in cell
	if self.bunnies_in_tile.has(bunny):
		return
	# Find somewhere else to place bunny

	if reached_max_capacity():
		var next_available_cell = cell.breadth_search_neighbours()

		if next_available_cell != null:
			bunny.move_to([next_available_cell])
	else:	# Place bunny in this tile
		if bunnies_in_tile.size() == 0:
			if cell.state_machine.current_state.name != "Water":
				cell.connect("get_resources", bunny.bnet.actor_data, "add_resources")
				cell.bnet_acquire(bunny.bnet)
		bunny.cell = cell
		#var bunny_id = bunnies_in_tile.size() + 1
		#var vector_to_position = get_cell_position(hex_center, hex_size, bunny_id, default_percentage, percentage_increase)
		#bunny.goal = hex_center + vector_to_position
		bunnies_in_tile.append(bunny)

func remove_bunny(bunny):
	if bunnies_in_tile.has(bunny):
		bunnies_in_tile.erase(bunny)
		move_bunnies_along()
		if bunnies_in_tile.size() == 0:
			var cell: Cell = get_owner()
			if cell.has_structure() == false:
				if cell.get_state() != "Water":
					cell.available_cell()

func move_bunnies_along():
	var id = 1
	var cell: Cell = get_owner()

	var hex_center = cell.global_position
	var hex_size = cell.hex_size

	for b in bunnies_in_tile:
		var vector_to_position = get_cell_position(hex_center, hex_size, id, default_percentage, percentage_increase)
		var new_goal = hex_center + vector_to_position
		b.shift_in_cell(new_goal)
		id += 1

func remove_all_bunnies():
	var i = 0
	print_debug(bunnies_in_tile.size())

	while bunnies_in_tile.size() > 0:
		var b: BunnyBase = bunnies_in_tile.pop_front()
		remove_bunny(b)
		b.die()

	var cell: Cell = get_owner()
	if cell.has_structure() == false:
		if cell.get_state() != "Water":
			cell.available_cell()



func delete_bunnies(amount: int):
	var index = 0
	while bunnies_in_tile.size() > 0:
		# No more bunnies to destroy
		if index >= amount:

			break
		var b: BunnyBase = bunnies_in_tile.pop_front()
		remove_bunny(b)
		b.die()

	var cell = get_owner()
	if cell.has_structure() == false:
		if cell.get_state() != "Water":
			cell.available_cell()

# Gets a position inside the cell
func get_cell_position(center: Vector2, cell_size: Vector2, bunny_id: int, percentage: float, percentage_increase: float) -> Vector2:
	# range 1-6
	# bunny_id has to be 1 or more
	if bunny_id == 0:
		printerr("Invalid bunny id. Needs to be greater than 0")
	var corner_id = bunny_id % 7
	var corner_position = get_owner().pointy_hex_corner(center, cell_size, corner_id)
	var center_to_corner: Vector2 = corner_position - center

	var percentage_adjustment = 0
	# How many times have we gone over all hex corners
	var complete_cycles = bunny_id / 7
	percentage_adjustment = complete_cycles

	var adjust_vector_by = percentage + (percentage_adjustment * percentage_increase)

	# reduce vector
	var adjusted_vector: Vector2 = adjust_vector_by * center_to_corner

	return adjusted_vector
