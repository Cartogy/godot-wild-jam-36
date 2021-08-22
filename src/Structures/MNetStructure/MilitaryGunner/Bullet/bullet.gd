extends KinematicBody2D

var direction: Vector2
var speed = 10

var killed_bunny = false

func _ready():
	$Timer.start()

func _physics_process(delta):
	if $Timer.is_stopped():
		self.queue_free()
	move_and_slide(direction * speed)

func _on_Area2D_body_entered(body):
	if body is BunnyBase:
		if killed_bunny == false:
			body.die()
			killed_bunny = true
			self.queue_free()
