extends State

var entity: TileEntity
var goal: Vector2
var paths = []
var current_goal_cell: Cell


func _ready():
	pass

func handle_input(event):
	pass

# What occurs when entering a state
func enter():
	# Gain reference to nodes
	paths = entity.cell_path
	# get first cell to go to
	current_goal_cell = paths.pop_front()
	current_goal_cell.debug_cell()
	
	goal = current_goal_cell.global_position


# What occurs when exiting state
func exit():
	paths = []

# Physics process for state
func p_process(delta: float):
	var direction = goal - entity.global_position

	# Arrived at cell
	if direction.length() < current_goal_cell.hex_size.length() * 0.4:
		if paths.size() > 0:
			var old_cell = entity.cell
			entity.cell = current_goal_cell

			current_goal_cell = paths.pop_front()
			current_goal_cell.debug_cell()
			entity.arrival_from(old_cell, entity.cell, current_goal_cell)
			goal = current_goal_cell.global_position
		else:
			print_debug("Arrived")
			entity.goal = current_goal_cell.global_position
			entity.add_to_tile(current_goal_cell)
			entity.cell = current_goal_cell
			current_goal_cell = null

			emit_signal("change_state", "MovingInCell")
	else:
		direction = direction.normalized()
		entity.move_and_slide(direction * entity.speed)
		print_debug(current_goal_cell.hex_size)



# In charge of setting up variables that the state will deal with
## (e.g. setting custom variables)
func setup():
	entity = get_owner()
