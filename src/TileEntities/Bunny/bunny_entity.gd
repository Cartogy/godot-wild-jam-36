extends TileEntity
class_name Bunny

var on_cell: Cell
var bnet = null

func _ready():
	selectable = true
	if bnet != null:
		bnet.actor_data.add_population(1)

func move_to(p_cell_path: Array):
	cell_path = p_cell_path.duplicate()
	next_cell = cell_path.pop_front()

	migrating = true

func arrived_at(p_cell: Cell):
	print_debug("Arrived at Cell")

func die():
	bnet.actor_data.remove_population(1)
