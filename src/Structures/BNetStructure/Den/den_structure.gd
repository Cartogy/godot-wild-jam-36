extends BNetStructure
class_name DenStructure

var consuming_cell
var bnet

func _ready():
	structure_id = "den"

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
		if consuming_cell.bunnies.reached_max_capacity():
			#consuming_cell.triggered()

			cell_consumed(cell, consuming_cell)
			

func add_consuming_cell(p_cell: Cell):
	consuming_cell = p_cell
	consuming_cell.bnet_acquire(bnet)

func cell_consumed(from: Cell, cell_consumed: Cell):
	bnet.consumed_cells[cell_consumed.hex_coords] = cell_consumed
	
	var next_cell = from.breadth_search_neighbours()
	if next_cell != null:
		next_cell.connect("get_resources", bnet.actor_data, "add_resources")
	if next_cell != null:
		add_consuming_cell(next_cell)
	else:
		printerr("No neighbours to consume")

func add_bunny(to: Cell):
	var real_hex_center = to.real_hex_center
	var hex_coords = to.hex_coords
	
	if to.state_machine.current_state.name == "BNet":
		to.bunnies.add_bunny(real_hex_center, hex_coords, bnet)
