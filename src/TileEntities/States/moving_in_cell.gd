extends State

var entity: TileEntity
var goal

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

	if direction.length() < 0.3:
		emit_signal("change_state", "Idle")
	else:
		entity.move_and_slide(direction.normalized() * entity.speed)


# In charge of setting up variables that the state will deal with
## (e.g. setting custom variables)
func setup():
	entity = get_owner()
