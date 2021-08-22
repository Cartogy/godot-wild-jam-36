extends KinematicBody2D
class_name TileEntity

onready var sprite = $Sprite
onready var state_machine = $StateMachine
onready var animation_player = $AnimationPlayer

export (int) var damage = 1
export (float) var speed: float = 15

var hex_center: Vector2
var hex_coord
var cell: Cell
var attacking_cell: Cell

# If the player cen select it or not.
var selectable: bool = false


var migrating: bool = false
var moving_to_



# How far it can go from the center when idle
var max_radius_idle: float

var cell_path: Array = []
var next_cell: Cell

# What an entity can't go through
var obstacles: Array = []
var ignore_edge_obstacles: bool = false

var goal: Vector2


func _ready():
	state_machine.connect("changed_state", self, "_on_state_changed")
	state_machine.setup_state_machine()

func move_to(_p_cell_path: Array):
	pass

func _physics_process(delta):
	state_machine.run_p_process(delta)


func shift_in_cell(new_goal: Vector2):
	goal = new_goal
	state_machine.change_state("MovingInCell")
	
func add_to_tile(_new_cell):
	pass

func arrived_at(_p_cell):
	pass

#############
## Attack
#############

func structure_alive_at(cell: Cell):
	return cell.structure_is_alive()

func damage_structure_at(cell: Cell, damage: int):
	cell.damage_structure(damage)

############
## Collision behaviour
############

# called in physics process
func check_collision(amount: int, from: Cell, to: Cell):
	pass


func _on_state_changed(next_state):
	pass

