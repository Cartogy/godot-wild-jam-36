extends Control

export (String, FILE, "*.tscn") var scene_tile

signal tile_selected(scene)


func _on_EdgeOption_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			emit_signal("tile_selected", scene_tile)
