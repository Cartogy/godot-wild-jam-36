extends Control

onready var texture_rect= $TextureRect

var scene_tile
var texture_display: Texture

signal tile_selected(scene_tile_path)

func _ready():
	pass

func build_option(scene: String, texture: String):
	scene_tile = scene
	texture_display = load(texture)
	texture_rect.texture = texture_display


func _on_TileOption_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			emit_signal("tile_selected", scene_tile)
