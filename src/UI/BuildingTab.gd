extends Control

onready var buttons = $VBoxContainer.get_children()


func _ready():
	for button in buttons:
		button.connect("gui_input", self, "_on_button_clicked", [button])


func _on_button_clicked(event: InputEvent, button: TextureRect):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			Flow.select_structure(button.structure_name)


