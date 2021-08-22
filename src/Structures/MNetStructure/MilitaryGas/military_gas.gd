extends MilitaryBase
class_name MilitaryGas

#const bullet_path = preload("res://src/Structures/MNetStructure/MilitaryGunner/Bullet/Bullet.tscn")

var kill_per_gas = 4
var max_ticks_per_gas = 2
var ticks_before_gas = 0

var killed_per_tick = 0

func tick():
	if ticks_before_gas == 0:
		attack()
	else:
		fuel_gas()
	



func attack():
	var adjacent_cells = cell.neighbours
	var sfx_played = false
	for n in adjacent_cells:
		if n.has_bunnies():
			if sfx_played == false:
				AudioEngine.play_effect("gas")
				sfx_played = true
			reset_gas()
			n.remove_bunny_amount(kill_per_gas)



	
func reset_gas():
	ticks_before_gas = max_ticks_per_gas
	
func fuel_gas():
	ticks_before_gas -= 1


