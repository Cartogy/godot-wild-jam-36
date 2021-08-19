extends KinematicBody2D
class_name TileEntity

onready var state_machine = $StateMachine

var hex_center: Vector2
var hex_coord
var cell: Cell

# If the player cen select it or not.
var selectable: bool = false


var migrating: bool = false
var moving_to_

var speed: float = 15

# How far it can go from the center when idle
var max_radius_idle: float

var cell_path: Array = []
var next_cell: Cell

# What an entity can't go through
var obstacles: Array = []

var goal: Vector2


func _ready():
	state_machine.setup_state_machine()

func move_to(p_cell_path: Array):
	pass
		
func _physics_process(delta):
	state_machine.run_p_process(delta)
	
	

func add_to_tile(new_cell: Cell):
	pass

func arrived_at(p_cell: Cell):
	pass
