extends BNetStructure
class_name Barracks

var bnet

var unit_queue = []
var progress = 0.0

func add_to_bnet(p_bnet):
	bnet = p_bnet
	# Make sure it produces in its current cell

func starting_structure():
	cell.bnet_acquire(bnet)

func tick():
	if not unit_queue:
		progress = 0.0
		return

	progress += 0.1
	if progress >= 1.0:
		progress -= 1.0
		spawn_unit_in_queue()

func spawn_unit_in_queue():
	pass

