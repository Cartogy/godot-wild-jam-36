extends State
class_name CellState

"""
Abstract class for cell state
"""

var cell: Cell

func _ready():
	pass

func handle_input(event):
	pass

# What occurs when entering a state
func enter():
	pass

# What occurs when exiting state
func exit():
	pass

# Physics process for state
func p_process(delta: float):
	pass

# In charge of setting up variables that the state will deal with
## (e.g. setting custom variables)
func setup():
	pass

#######################
# Cell State functions
#######################

func interact():
	pass


