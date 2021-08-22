extends Control

onready var back_to_level_select_button = $VBoxContainer/NextLevelButton

func _ready():
	Flow.win_screen = self

	back_to_level_select_button.connect("pressed", self, "_on_back_to_level_select_pressed")


func _on_back_to_level_select_pressed():
	Flow.go_to_level_select()


func update_time():
	var elapsed_time = Flow.elapsed_time
	var partime = Flow.level.partime
	var elapsed_text = str(int(elapsed_time / 3600)).pad_zeros(2) + ":" + str(int(fmod(elapsed_time / 60, 60))).pad_zeros(2) + ":" + str(int(fmod(elapsed_time, 60))).pad_zeros(2)
	var partime_text = str(int(partime / 3600)).pad_zeros(2) + ":" + str(int(fmod(partime / 60, 60))).pad_zeros(2) + ":" + str(int(fmod(partime, 60))).pad_zeros(2)
	$VBoxContainer/Information.text = "You completed the mission in " + elapsed_text + ".\n\n"
	if Flow.elapsed_time < Flow.level.partime:
		$VBoxContainer/Information.text += "Amazing job, general, you beat the partime of " + partime_text + "!\n\nYou're very good at this huh?"
	else:
		$VBoxContainer/Information.text = "While you did a good job, there's definitely room to grow. The partime for this level is " + partime_text + "."
