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
	var next_cell = from.breadth_search_neighbours()

	
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
