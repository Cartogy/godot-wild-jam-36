extends State

var entity

func _ready():
	pass

func handle_input(event):
	pass

# What occurs when entering a state
func enter():
	# Play animation
	animation_to_implement()

# What occurs when exiting state
func exit():
	entity.barrier_to_destroy = null

# Physics process for state
func p_process(delta: float):
	pass


# In charge of setting up variables that the state will deal with
## (e.g. setting custom variables)
func setup():
	entity = get_owner()
	
func animation_to_implement():
	# Have animation do the following in some way
	entity.destroy_barrier()
	emit_signal("change_state", "Migrating")
