extends KinematicBody2D
class_name Nuke

var speed = 10

var base_from
var cell_to_nuke: Cell
var from_cell: Cell
var launch_direction = Vector2(0,-1)

var max_distance_away =  20

enum STATES { LAUNCHING, LANDING } 
var state

func _ready():
	state = STATES.LAUNCHING
	
func _physics_process(delta):
	if launching():
		if far_away():
			state = STATES.LANDING
			teleport()
		move_and_slide(launch_direction * speed)
	elif landing():
		if has_landed():
			nuke()
		
		move_and_slide(launch_direction * -speed)

func launching() -> bool:
	return state == STATES.LAUNCHING

func landing() -> bool:
	return state == STATES.LANDING

func far_away() -> bool:
	var distance_away = self.global_position - from_cell.global_position
	
	if distance_away.length() > max_distance_away:
		return true
	return false
		
		
func teleport():
	var to_nuke_position = cell_to_nuke.global_position
	var vector_away = (launch_direction * max_distance_away)
	var teleport_to = to_nuke_position + vector_away
	
	self.rotate(deg2rad(180))
	self.global_position = teleport_to

func has_landed() -> bool:
	var distance_away = cell_to_nuke.global_position - self.global_position
	
	if distance_away.length() < 0.3:
		return true
	
	return false

func nuke():
	cell_to_nuke.remove_all_bunnies()
	base_from.detonated()
	self.queue_free()
