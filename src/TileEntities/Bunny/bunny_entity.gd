extends TileEntity
class_name Bunny

var on_cell: Cell
var bnet = null

func _ready():
	selectable = true
	if bnet != null:
		bnet.actor_data.add_population(1)

func die():
	bnet.actor_data.remove_population(1)
