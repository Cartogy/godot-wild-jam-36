extends Node2D

var upgrade: BunnyUpgrade

signal selected(upgr)

func display():
	self.visible = true
	
func hide():
	self.visible = false
	
func set_upgrade(p_upgrade: BunnyUpgrade):
	upgrade = p_upgrade
	
func set_texture(tex: Texture):
	$Sprite.texture= tex


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			emit_signal("selected", upgrade)
