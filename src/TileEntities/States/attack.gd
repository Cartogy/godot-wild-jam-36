extends State

export (int) var attack_movement_speed = 10

var attack_cell
var current_cell
var entity: TileEntity
var mid_point: Vector2

var moving_to_edge = false

func _ready():
	pass

func handle_input(event):
	pass

# What occurs when entering a state
func enter():
	attack_cell = entity.attacking_cell
	current_cell = entity.cell
	var direction = attack_cell.global_position - current_cell.global_position
	var half_dir = direction / 2
	
	mid_point = current_cell.global_position + half_dir
	
	moving_to_edge = true

# What occurs when exiting state
func exit():
	pass

# Physics process for state
func p_process(delta: float):
	if moving_to_edge:
		var direction = mid_point - entity.global_position
		if direction.length() > 0.3:
			direction = direction.normalized()
		
			entity.move_and_slide(direction * attack_movement_speed)
		else:
			moving_to_edge = false
	else:
		attack_structure()
		

func attack_structure():
	if entity.structure_alive_at(attack_cell):
		entity.damage_structure_at(attack_cell, entity.damage)
	else:
		attack_finished()
		
func attack_finished():
	#entity.add_to_tile(a)
	#var goal = entity.get_position_in_tile(current_cell.global_position, current_cell)
	entity.cell_path = [attack_cell]
	emit_signal("change_state", "Migrating")
# In charge of setting up variables that the state will deal with
## (e.g. setting custom variables)
func setup():
	entity = get_owner()
