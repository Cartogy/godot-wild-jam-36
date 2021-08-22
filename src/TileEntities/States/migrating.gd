extends State

var entity: TileEntity
var goal: Vector2
var paths = []
var current_goal_cell: Cell = null

var min_distance_perc = 0.2

func _ready():
	pass

func handle_input(event):
	pass

# What occurs when entering a state
func enter():
	# Gain reference to nodes
	paths = entity.cell_path
	current_goal_cell = null


# What occurs when exiting state
func exit():
	paths = []

# Physics process for state
func p_process(delta: float):

	if current_goal_cell == null:
		current_goal_cell = paths.pop_front()
		if current_goal_cell.get_state() == "Military":
			start_attacking(current_goal_cell)
		goal = current_goal_cell.global_position
		entity.arrival_from(entity.cell, current_goal_cell)
	var direction = goal - entity.global_position

	# Arrived at cell
	if direction.length() < current_goal_cell.hex_size.length() * min_distance_perc:
		if paths.size() > 0:
			# Coming From
			var old_cell = entity.cell
			# arriving to
			entity.cell = current_goal_cell
			entity.arrival_from(entity.cell, current_goal_cell)
			# Next goal
			current_goal_cell = paths.pop_front()
			
			if current_goal_cell.state_machine.current_state.name == "Military":
				start_attacking(current_goal_cell)

			
			goal = current_goal_cell.global_position
		else:
			entity.goal = current_goal_cell.global_position
			entity.add_to_tile(current_goal_cell)
			entity.cell = current_goal_cell
			current_goal_cell = null

			emit_signal("change_state", "MovingInCell")
	else:
		direction = direction.normalized()
		entity.move_and_slide(direction * entity.speed)
		# Do collision if implemented
		entity.check_collision(entity.get_slide_count(), entity.cell, current_goal_cell)

func start_attacking(to_attack: Cell):
	entity.attacking_cell = to_attack
	emit_signal("change_state", "Attack")


# In charge of setting up variables that the state will deal with
## (e.g. setting custom variables)
func setup():
	entity = get_owner()
