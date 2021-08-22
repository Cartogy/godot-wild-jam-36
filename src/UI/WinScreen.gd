extends Control

onready var back_to_level_select_button = $VBoxContainer/NextLevelButton

func _ready():
	Flow.win_screen = self

	back_to_level_select_button.connect("pressed", self, "_on_back_to_level_select_pressed")


func _on_back_to_level_select_pressed():
	Flow.go_to_level_select()
