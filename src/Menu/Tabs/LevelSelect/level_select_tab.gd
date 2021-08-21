extends MenuTab

onready var _back_to_main_menu := $HBoxContainer/MarginContainer/VBoxContainer/BackButton
onready var _levels := $HBoxContainer/MarginContainer/Levels
onready var _start_button := $HBoxContainer/LevelInfo/PanelContainer/MarginContainer/VBoxContainer/StartButton
onready var _mission_image := $HBoxContainer/LevelInfo/PanelContainer/MarginContainer/CenterContainer/MissionImage
onready var _mission_explanation := $HBoxContainer/LevelInfo/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MissionExplanation
onready var _mission_title := $HBoxContainer/LevelInfo/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MissionTitle


onready var missions = [
	{
		"name": "Closed Edges",
		"description": "In this first mission, you're going to learn the ropes",
		"data": "res://src/Level/CustomLevels/closed_edges.tres",
		"image": load("res://assets/graphics/Bunny_Eating.png"),
	},
	{
		"name": "Military Test",
		"description": "In this second mission, you're going to kick some ass",
		"data": "res://src/Level/CustomLevels/military_test.tres",
		"image": load("res://assets/graphics/Buff_Smash.png"),
	}
]

func _ready():
	_mission_explanation.text = ""
	_mission_title.text = "Please select a level"
	_mission_image.texture = null
	_start_button.disabled = true

	for mission in missions:
		var new_button = Button.new()
		_levels.add_child(new_button)
		new_button.text = mission.name
		new_button.connect("pressed", self, "_on_mission_button_clicked", [mission])

	var _error: int = _back_to_main_menu.connect("pressed", self, "_on_main_menu_pressed")
	_error += _start_button.connect("pressed", self, "_on_start_level_pressed")

func _on_mission_button_clicked(mission):
	print("Selected mission", mission)
	_mission_title.text = mission.name
	_mission_explanation.text = mission.description
	if mission.image:
		_mission_image.texture = mission.image
	else:
		_mission_image.texture = null
	_start_button.disabled = false

	Flow.level = mission

func _on_main_menu_pressed():
	emit_signal("button_pressed", TABS.MAIN)

func _on_start_level_pressed():
	Flow.start_level()

func _on_button_mouse_entered():
	pass
