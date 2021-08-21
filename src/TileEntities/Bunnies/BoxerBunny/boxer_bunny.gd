extends BunnyBase
class_name BoxerBunny

var barrier_to_destroy: GridEdge = null

func _ready():
	ignore_edge_obstacles = true
	obstacles = ["Water"]

func check_collision(amount: int, from: Cell, to: Cell):
	for i in amount:
		var collision = get_slide_collision(i)
		print_debug(collision.collider)
		if collision.collider is GridEdge:
			if is_blocking_path(collision.collider, from, to):
				barrier_to_destroy = collision.collider
				state_machine.change_state("DestroyBarrier")

func destroy_barrier():
	if barrier_to_destroy != null:
		barrier_to_destroy.remove_edge()
		barrier_to_destroy = null

	
func is_blocking_path(edge: GridEdge, from, to):
	if edge.cell_0 == from and edge.cell_1 == to:
		return true
	elif edge.cell_1 == from and edge.cell_0 == to:
		return true
	else:
		return false
