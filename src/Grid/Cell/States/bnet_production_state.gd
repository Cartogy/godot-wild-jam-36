extends CellState

var cell_consumption

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

func setup():
	cell = get_owner()

#######################
# Cell State functions
#######################

func interact():
	pass

func add_consuming_cell(to_consume):
	cell_consumption = to_consume

func tick():
	if cell_consumption.bunnies.reached_max_capacity():
		cell_consumption.triggered()
		cell.emit_signal("consumption_complete", cell, cell_consumption)
	else:
		cell_consumption.add_bunny()
		if cell_consumption.bunnies.reached_max_capacity():
			cell_consumption.triggered()
			cell.emit_signal("consumption_complete", cell, cell_consumption)
