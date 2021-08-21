extends Control

onready var _tab_container := $CanvasLayer/TabContainer

func _ready():
	Flow.set_game_state_menu()
	AudioEngine.play_background_music("menu")
	if ConfigData.skip_menu:
		if ConfigData.verbose_mode : print("Automatically skipping menu as requested by configuration data...")
		Flow.go_to_game()
	else:
		pass
#		_tab_container.set_current_tab(class_pause_tab.TABS.MAIN)
