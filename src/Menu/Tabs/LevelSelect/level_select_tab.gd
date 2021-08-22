extends MenuTab

onready var _back_to_main_menu := $HBoxContainer/MarginContainer/VBoxContainer/BackButton
onready var _levels := $HBoxContainer/MarginContainer/Levels
onready var _start_button := $HBoxContainer/LevelInfo/PanelContainer/MarginContainer/VBoxContainer/StartButton
onready var _mission_image := $HBoxContainer/LevelInfo/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/CenterContainer/MissionImage
onready var _mission_explanation := $HBoxContainer/LevelInfo/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/MissionExplanation
onready var _mission_title := $HBoxContainer/LevelInfo/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/MissionTitle


onready var missions = [
	{
		"name": "Morning Simulation",
		"description": "Good morning, general! Today will be quite a different day,  and I'm afraid your carrot cake will have to wait. After millennia of domestication, we're finally striking back against humanity and will reclaim what's rightfully ours... Fluffland\n\nWe know this is sudden, so we'll first run you through a simple simulation to give you a refresher of your job... Be sure to give your staff a raise after this, general.\n\nIn this first simulation, try to claim all land tiles by clicking bunnies and right-clicking on unoccupied tiles. Make sure to avoid overpopulation, as this will fail the simulation.",
		"data": "res://src/Level/CustomLevels/level_1.tres",
		"image": load("res://assets/graphics/level_1_art.png"),
		"partime": 90,
	},
	{
		"name": "Bunny Bunny Revolution",
		"description": "In this second and last simulation, you'll learn how to engage with the futile human resistance. Note that we call them futile, but we really need to educate you first to make them futile, so listen well.\nTry to harvest special tiles for resources. After harvesting these, shift+click a bunny to upgrade them to a variant. I recommend the fighter variant.\nOrder your fighter to attack the human bases, ideally supporting them with brave decoy bunnies who we'll remember forever.",
		"data": "res://src/Level/CustomLevels/level_2.tres",
		"image": load("res://assets/graphics/level_2_art.png"),
		"partime": 180,
	},
	{
		"name": "First Blood",
		"description": "The day has finally come and we're taking the fight to the humans! They thought they could keep us happy and gentle forever with some hay and some pets... No more!\nYou'll find that our battlefield today is defended by walls. There's no way around them, unless you found a bug. Which you shouldn't, because we're rabbits. You can upgrade one of the troops by shift+clicking them and choosing to train them into an elite boxer unit. These can smash through these puny walls without problems.",
		"data": "res://src/Level/CustomLevels/level_3.tres",
		"image": load("res://assets/graphics/level_3_art.png"),
		"partime": 210,
	},
	{
		"name": "Sink Or Swim",
		"description": "Have you ever heard the story humans tell of the Galapagos, where one of their scientists stumbled upon the dated theory of evolution that we ourselves have furthered enormously? In the Galapagos islands, each island has vastly different animal evolutions adapted to that island's way of living.\nLong story short, our relatives there managed to get to each island by swimming! And so must we, if we want to take this important island.\nDon't forget that you can upgrade a bunny to have a scuba outfit, after which you can place a Den on the other side to start a new family",
		"data": "res://src/Level/CustomLevels/level_4.tres",
		"image": load("res://assets/graphics/level_4_art.png"),
		"partime": 300,
	},
	{
		"name": "Birth of the Wild",
		"description": "General. The humans have done it again! A new tactic! Bahaha! They really think they can stop us. But. We're. UNSTOPPABLE! Our specialized boxer units can smash through the walls they created, and blast away the choke point they think they created. Good luck, general!",
		"data": "res://src/Level/CustomLevels/level_5.tres",
		"image": load("res://assets/graphics/level_5_art.png"),
		"partime": 360,
	},
	{
		"name": "Dawn of the Bunnies",
		"description": "We have arrived at humanity's final stand. This will be a tight mission, general. Our landing zone is a little offshore island, and the humans did their best to mount worthy defenses.\nBut you know the drill, and we can't be stopped! For Fluffland! For Fluffland!",
		"data": "res://src/Level/CustomLevels/level_6.tres",
		"image": load("res://assets/graphics/level_6_art.png"),
		"partime": 420,
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
