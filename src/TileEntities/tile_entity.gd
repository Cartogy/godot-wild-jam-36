extends KinematicBody2D
class_name TileEntity

var hex_center: Vector2
var hex_coord
var cell: Cell

# If the player cen select it or not.
var selectable: bool = false

enum EState {IDLE, MIGRATING, MOVINGTOPOSITION}
var state = EState.IDLE

var migrating: bool = false
var moving_to_

var speed: float = 15

# How far it can go from the center when idle
var max_radius_idle: float

var cell_path: Array = []
var next_cell: Cell

var goal: Vector2

func move_to(p_cell_path: Array):
	pass
		
func _physics_process(_delta):
	match state:
		EState.MIGRATING:
			var direction = goal - self.global_position

			# Arrived at cell
			if direction.length() < (next_cell.hex_size.length() * 0.4):
				# Keep going to next cell
				if cell_path.size() > 0:
					next_cell = cell_path.pop_front()
				else:
					#arrived_at(next_cell)
					add_to_tile(next_cell)
					cell = next_cell
					next_cell = null
					migrating = false
					state = EState.MOVINGTOPOSITION
			else:
				direction = direction.normalized()
				move_and_slide(direction * speed)
		EState.MOVINGTOPOSITION:
			var direction = goal - self.global_position

			if direction.length() < 0.3:
				state = EState.IDLE
			else:
				move_and_slide(direction.normalized() * speed)

	

func add_to_tile(new_cell: Cell):
	pass

func arrived_at(p_cell: Cell):
	pass
