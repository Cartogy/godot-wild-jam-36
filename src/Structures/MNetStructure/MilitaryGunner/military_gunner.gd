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
			if sent_bullet == false:
				sent_bullet = true
				AudioEngine.play_effect("gunshot")
			var bullet = bullet_path.instance()
			bullet.direction = direction.normalized()
			add_child(bullet)
			
