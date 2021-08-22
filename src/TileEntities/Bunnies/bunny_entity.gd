extends TileEntity
class_name BunnyBase

var on_cell
var bnet = null

func _ready():
	if animation_player.has_animation("idle"):
		animation_player.play("idle")
	selectable = true
	if bnet != null:
		bnet.actor_data.add_population(1)

func move_to(p_cell_path: Array):
	if p_cell_path.size() > 0:
		if cell != null:
			cell.bunnies.remove_bunny(self)
		#cell = null
		var first_cell = p_cell_path[0]
		if first_cell.global_position.x < global_position.x:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1
		cell_path = p_cell_path.duplicate()

		state_machine.change_state("Migrating")

func arrived_at(p_cell):

	p_cell.bunnies.place_bunny_on_cell(self)

func die():
	if cell != null:
		cell.bunnies.remove_bunny(self)
	bnet.actor_data.remove_population(1)
	AudioEngine.play_effect("death")
	self.queue_free()

func add_to_tile(new_cell):
	var vector_to_position = new_cell.bunnies.calc_direction_placement()
	new_cell.bunnies.place_bunny_on_cell(self)

	goal = goal + vector_to_position

func get_position_in_tile(center: Vector2, cell: Cell):
	var vector_to_position = cell.bunnies.calc_direction_placement()
	return center + vector_to_position

func debug_path(path: Array):
	for c in path:
		c.debug_cell()

func to_normal(c):
	c.available_cell()

func arrival_from(from, to, next):
	pass

func _on_state_changed(next_state):

	if next_state == "Migrating" or next_state == "MovingInCell":
		if animation_player.has_animation("move"):
			animation_player.play("move")
	elif next_state == "Idle":
		if animation_player.has_animation("idle"):
			animation_player.play("idle")
	elif next_state == "Attack":
		if animation_player.has_animation("attack"):
			animation_player.play("attack")


func attack_effect():
	pass
	
func hop_effect():
	pass
