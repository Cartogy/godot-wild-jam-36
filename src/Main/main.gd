extends Node2D

onready var level = $BaseLevel

func _ready():
	Flow.transition.set_color(Color(0, 0, 0, 1))
	level.start_bnet()
	yield(Flow.transition.transition_to_clear(1.0), "completed")




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
