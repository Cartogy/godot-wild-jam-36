extends State

var entity: TileEntity
var goal: Vector2

func _ready():
	pass

func handle_input(event):
	pass

# What occurs when entering a state
func enter():
	goal = entity.goal

# What occurs when exiting state
func exit():
	pass

# Physics process for state
func p_process(delta: float):
	var direction = goal - entity.global_position

	if direction.length() < entity.next_cell.hex_size.length() * 0.4:
		if entity.cell_path.size() > 0:
			entity.cell = entity.next_cell
			entity.next_cell = entity.cell_path.pop_front()
			goal = entity.next_cell.global_position
			entity.goal = goal
		else:
			entity.add_to_tile(entity.next_cell)
			entity.cell = entity.next_cell
			entity.next_cell = null 
			emit_signal("change_state", "MovingInCell")
	else:
		direction = direction.normalized()
		entity.move_and_slide(direction * entity.speed)



# In charge of setting up variables that the state will deal with
## (e.g. setting custom variables)
func setup():
	entity = get_owner()
