extends CellState


func _ready():
	pass

func handle_input(event):
	pass

# What occurs when entering a state
func enter():
	cell.water_tex()

# What occurs when exiting state
func exit():
	pass

# Physics process for state
func p_process(delta: float):
	pass

func setup():
	cell = get_owner()

#######################
# Cell State functions
#######################

func interact():
	pass
