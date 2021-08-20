extends CellState

var bunnies

func _ready():
	pass

func handle_input(event):
	pass

# What occurs when entering a state
func enter():
	cell.bnet_tex()
	cell.connect("get_resources", cell.bnet.actor_data, "add_resources")
	cell.emit_signal("get_resources", cell.resources)

# What occurs when exiting state
func exit():
	var population_to_decrease = cell.resources.population_amount
	cell.bnet.actor_data.remove_max_population(population_to_decrease)
	cell.disconnect("get_resources", cell.bnet.actor_data, "add_resources")

# Physics process for state
func p_process(delta: float):
	pass

func setup():
	cell = get_owner()
	bunnies = cell.bunnies

#######################
# Cell State functions
#######################

func interact():
	pass
