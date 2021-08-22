extends MilitaryBase
class_name MilitaryGunner

const bullet_path = preload("res://src/Structures/MNetStructure/MilitaryGunner/Bullet/Bullet.tscn")

# Determine if we play the sfx or not
var sent_bullet: bool = false

func tick():
	attack()

func attack():
	var cell_neighbours = cell.neighbours
	sent_bullet = false
	for n in cell_neighbours:
		var direction = n.global_position - cell.global_position
		
		if n.state_machine.current_state.name == "BNet":
			send_bullet(direction)	
	for e in entities_nearby:
		var bunny_from_cell = e.cell
		var direction = Vector2.ZERO
		if bunny_from_cell.get_state() != "BNet":
			direction = calculate_direction(cell.global_position, bunny_from_cell.global_position)

			send_bullet(direction)

func send_bullet(direction: Vector2):
	if sent_bullet == false:
		sent_bullet = true
		var bullet = bullet_path.instance()
		bullet.direction = direction.normalized()
		add_child(bullet)
			
func calculate_direction(from: Vector2, to: Vector2) -> Vector2:
	return to - from
