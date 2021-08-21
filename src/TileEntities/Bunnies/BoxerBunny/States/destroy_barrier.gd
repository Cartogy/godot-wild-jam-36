extends State

var entity
var animation_time = 1.5
onready var timer = $Timer

func _ready():
	pass

func handle_input(event):
	pass

# What occurs when entering a state
func enter():
	timer.start()
	# Play animation
	animation_to_implement()

# What occurs when exiting state
func exit():
	entity.barrier_to_destroy = null

# Physics process for state
func p_process(delta: float):
	if timer.is_stopped():
		entity.destroy_barrier()
		emit_signal("change_state", "Migrating")


# In charge of setting up variables that the state will deal with
## (e.g. setting custom variables)
func setup():
	entity = get_owner()
	
func animation_to_implement():
	entity.animation_player.play("attack")
	# Have animation do the following in some way
	#entity.destroy_barrier()
	#emit_signal("change_state", "Migrating")
