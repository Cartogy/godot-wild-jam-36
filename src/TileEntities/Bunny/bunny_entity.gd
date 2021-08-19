extends TileEntity
class_name Bunny

var on_cell: Cell
var bnet = null

func _ready():
	selectable = true
	if bnet != null:
		bnet.actor_data.add_population(1)

func move_to(p_cell_path: Array):
	if p_cell_path.size() > 0:
		cell.bunnies.remove_bunny(self)
		cell = null
		cell_path = p_cell_path.duplicate()
		next_cell = cell_path.pop_front()

		goal = next_cell.global_position

		state_machine.change_state("Migrating")

func arrived_at(p_cell: Cell):
	p_cell.bunnies.place_bunny_on_cell(self)
	print_debug("Arrived at Cell")

func die():
	bnet.actor_data.remove_population(1)

func add_to_tile(new_cell: Cell):
	new_cell.bunnies.place_bunny_on_cell(self)
	var vector_to_position = new_cell.bunnies.calc_direction_placement()

	goal = goal + vector_to_position

