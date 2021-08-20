extends MilitaryBase
class_name MilitaryGunner

const bullet_path = preload("res://src/Structures/MNetStructure/MilitaryGunner/Bullet/Bullet.tscn")

func tick():
	attack()

func attack():
	var cell_neighbours = cell.neighbours
	for n in cell_neighbours:
		var direction = n.global_position - cell.global_position
		
		if n.state_machine.current_state.name == "BNet":
			var bullet = bullet_path.instance()
			bullet.direction = direction.normalized()
			add_child(bullet)
			
