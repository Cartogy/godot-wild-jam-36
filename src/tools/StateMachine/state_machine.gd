extends Node

export (String) var INITIAL_STATE

var states: Dictionary = {}
var current_state: State


func _ready():
	# All its childrens are states
	# Stores the node state in a dictionary
	for s in get_children():
		s.connect("change_state", self, "change_state")
		states[s.name] = s
	# Avoid starting with no state
	if INITIAL_STATE != "":
		current_state = states[INITIAL_STATE]

func handle_input(event):
	current_state.handle_input(event)

# Called by main object to run the current state
func run_p_process(delta: float):
	current_state.p_process(delta)

func change_state(next_state):
	current_state.exit()
	current_state = states[next_state]
	current_state.enter()

func setup_state_machine():
	for s in states.values():
		s.setup()
