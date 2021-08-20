extends KinematicBody2D

var direction: Vector2
var speed = 10

func _physics_process(delta):
	move_and_slide(direction * speed)

func _on_Area2D_body_entered(body):
	if body is BunnyBase:
		body.die()
		self.queue_free()
