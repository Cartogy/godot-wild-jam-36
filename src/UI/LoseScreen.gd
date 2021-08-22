extends Control

onready var restart_button = $VBoxContainer/ReplayLevelButton


func _ready():
	Flow.lose_screen = self

	restart_button.connect("pressed", self, "_on_restart_pressed")


func _on_restart_pressed():
	Flow.restart_level()
