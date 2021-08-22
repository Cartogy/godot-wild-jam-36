extends BunnyBase
class_name ScubaBunny

var transitioning: bool = false
var to_swim: bool = false
var distance_to_cell_edge: Vector2

var next_cell_origin: Vector2

func _process(delta):
	if transitioning:
		var distance = next_cell_origin - self.global_position
		if distance.length() < distance_to_cell_edge.length():
			if to_swim:
				animation_player.play("swim")
			else:
				animation_player.play("move")
			transitioning = false


func arrival_from(from, to, next):
	var cell_to
	if to == null:
		cell_to = from
	else:
		cell_to = to

	if next != null:
		distance_to_cell_edge = (next.global_position - cell_to.global_position) / 2
		if cell_to.get_state() == "Water" and is_land(next):
			next_cell_origin = next.global_position
			transitioning = true
			to_swim = false
		elif is_land(cell_to) and next.get_state() == "Water":
			next_cell_origin = next.global_position
			transitioning = true
			to_swim = true
	else:
		if cell_to.get_state() == "Water":
			distance_to_cell_edge = (cell_to.global_position - from.global_position) / 2
			transitioning = true
			to_swim = true



func swim_effect():
	AudioEngine.play_effect("aqua-hop")

func hop_effect():
	AudioEngine.play_effect("hop")

func attack_effect():
	AudioEngine.play_effect("munch")

func is_land(cell) -> bool:
	if cell.get_state() == "Available" or cell.get_state() == "BNet" or cell.get_state() == "Conquered" or cell.get_state() == "Military":
		return true
	else:
		return false
