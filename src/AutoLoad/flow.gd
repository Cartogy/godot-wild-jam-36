extends Node

enum STATE {MENU, GAME}

const OPTIONS_PATH := "res://options.cfg"
# Settings are a subset of options that can be modified by the user.
const USER_SETTINGS_PATH := "user://user_settings.cfg"

const DEFAULT_CONTEXT_PATH := "res://default_context.json"

### PUBLIC VARIABLES ###
var pause_menu : Control = null

# Is the game currently in editor mode? or not?
var is_in_editor_mode := false
var verbose_mode := true

var game_or_tutorial = "game"

var _game_scenes := {
	STATE.MENU: preload("res://src/Menu/Menu.tscn"),
	STATE.GAME: preload("res://src/Main/Main.tscn"),
}
var _game_state : int = STATE.MENU

onready var _options_loader := $OptionsLoader

func _ready():
	var _error := load_settings()

func load_settings() -> int:
	print("----- (Re)loading game settings from file -----")
	var _error : int = _options_loader.load_optionsCFG()
	# Also load the default context!? If the user context doesnt exist?
	if _error == OK:
		print("----> Succesfully loaded settings!")
	else:
		push_error("Failed to load settings! Check console for clues!")
	return _error

func save_user_settings() -> int:
	print("----- Saving user-modifiable settings to local system -----")
	var _error : int = _options_loader.save_settingsCFG()
	if _error == OK:
		print("----> Succesfully saved user settings!")
	else:
		push_error("Failed to save user settings! Check console for clues!")
	return _error

func _unhandled_input(event : InputEvent):
## Catch all unhandled input not caught be any other control nodes.
	if InputMap.has_action("toggle_full_screen") and event.is_action_pressed("toggle_full_screen"):
		OS.window_fullscreen = not OS.window_fullscreen

	match _game_state:
		STATE.GAME:
			if InputMap.has_action("toggle_paused") and event.is_action_pressed("toggle_paused"):
				toggle_paused()

func toggle_paused():
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		pause_menu.show()
	else:
		pause_menu.hide()

func deferred_quit() -> void:
## Quit the game during an idle frame.
	get_tree().quit()

func deferred_reload_current_scene() -> void:
## It is now safe to reload the current scene.
	var _error := load_settings()
	_error = get_tree().reload_current_scene()
	get_tree().paused = false

func change_scene_to(key : int) -> void:
	if _game_scenes.has(key):
		var packed_scene = _game_scenes[key]
		_game_state = key

		var error := get_tree().change_scene_to(packed_scene)
		get_tree().paused = false
		if error != OK:
			push_error("Failed to change scene to '{0}'.".format([key]))
		else:
			print("Succesfully changed scene to '{0}'.".format([key]))
	else:
		push_error("Requested scene '{0}' was not recognized... ignoring call for changing scene.".format([key]))

func go_to_game() -> void:
	change_scene_to(STATE.GAME)

func go_to_menu() -> void:
	change_scene_to(STATE.MENU)

func new_game() -> void:
	go_to_game()
