extends BunnyBase
class_name BoxerBunny

var barrier_to_destroy: GridEdge = null

func _ready():
	ignore_edge_obstacles = true

func check_collision(amount: int):
	for i in amount:
		var collision = get_slide_collision(i)
		print_debug(collision.collider)
		if collision.collider is GridEdge:
			barrier_to_destroy = collision.collider
			state_machine.change_state("DestroyBarrier")

func destroy_barrier():
	if barrier_to_destroy != null:
		barrier_to_destroy.remove_edge()
