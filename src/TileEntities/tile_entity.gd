extends KinematicBody2D
class_name TileEntity

var hex_center: Vector2
var hex_coord
var cell: Cell

# If the player cen select it or not.
var selectable: bool = false
var migrating: bool = false
var speed: float = 4

# How far it can go from the center when idle
var max_radius_idle: float

var cell_path: Array = []
var next_cell: Cell

func move_to(p_cell_path: Array):
	pass
		
func _physics_process(_delta):
	if migrating:
		var direction = next_cell.global_position - self.global_position

		# Arrived at cell
		if direction.length() < 0.3:
			# Keep going
			if cell_path.size() > 0:
				arrived_at(next_cell)
				next_cell = cell_path.pop_front()
			else:
				migrating = false
		direction = direction.normalized()
		move_and_slide(direction * speed)


func arrived_at(p_cell: Cell):
	pass
