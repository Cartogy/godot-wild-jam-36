extends Node

enum STATE {MENU, GAME}

const OPTIONS_PATH := "res://options.cfg"
# Settings are a subset of options that can be modified by the user.
const USER_SETTINGS_PATH := "user://user_settings.cfg"

const DEFAULT_CONTEXT_PATH := "res://default_context.json"

### PUBLIC VARIABLES ###
var pause_menu : Control = null
var b_net_ui: Control = null
var win_screen: Control = null
var lose_screen: Control = null
var transition: Control = null
var b_net: BNet = null
var b_commander = null
var grid = null

# Is the game currently in editor mode? or not?
var is_in_editor_mode := false
var verbose_mode := true

var game_or_tutorial = "game"

var _game_scenes := {
	STATE.MENU: preload("res://src/Menu/Menu.tscn"),
	STATE.GAME: preload("res://src/Main/Main.tscn"),
}
var _game_state : int = STATE.GAME

var menu_tab = null

var level = null
var loaded_level = null

var selected_structure = null
var hex_converter: HexConversion = HexConversion.new()

onready var _options_loader := $OptionsLoader

var elapsed_time = 0.0

func _ready():
	var _error := load_settings()

func set_game_state_menu():
	_game_state = STATE.MENU

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
			if InputMap.has_action("ui_cancel") and event.is_action_pressed("ui_cancel"):
				if selected_structure:
					selected_structure = null
				else:
					toggle_paused()

func _process(delta):
	if selected_structure != null:
		var cursor = b_net.get_global_mouse_position()
		
		var hex_coord = grid.pixel_to_hex(b_net.get_global_mouse_position())
		var pixel_center = hex_converter.doublewidth_to_pixel(hex_coord, grid.origin, grid.size)
		selected_structure.global_position = pixel_center
		
		if Input.is_action_just_pressed("left_click"):
			if can_place_den(hex_coord):
				if can_afford_building("den"):
					var den_pack = load(selected_structure.structure_scene_path)
					var den = den_pack.instance()
					var cell = grid.hexagon_coords[hex_coord.to_vector()]
					b_net.add_structure(den, hex_coord.to_vector(), cell)
					selected_structure.queue_free()
					selected_structure = null
		elif Input.is_action_just_pressed("right_click"):
			var old_struct = selected_structure
			b_net.remove_child(selected_structure)
			old_struct.queue_free()
			selected_structure = null
			
					

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

func start_level() -> void:
	change_scene_to(STATE.GAME)


func can_afford_building(structure_name: String) -> bool:
	var noms_available = b_net.actor_data.total_resources
	var den_price = 10
	
	if noms_available >= den_price:
		b_net.actor_data.remove_resources(den_price)
		
		return true
	else:
		return false


func select_structure(structure_name: String):
	selected_structure = load_den_display()
	b_net.add_child(selected_structure)
		
		

func load_den_display() -> TileDisplay:
	var display_pack = load("res://src/MapMaker/TileDisplay/Cells/BNetDisplay.tscn")
	var display = display_pack.instance()
	
	return display
	
func can_place_den(cursor: DoubleCoordinate):
	var cell: Cell = grid.hexagon_coords[cursor.to_vector()]
	
	if cell.get_state() == "BNet" and cell.has_structure() == false:
		return true
	else:
		return false
	
	

func get_level_data():
	if level == null:
		return "res://src/Level/CustomLevels/level_1.tres"
	else:
		return level.data


func won_game():
	loaded_level.stop_bnet()
	win_screen.update_time()
	win_screen.visible = true


func lost_game():
	loaded_level.stop_bnet()
	lose_screen.visible = true


func restart_level():
	yield(transition.transition_to_dark(), "completed")
	start_level()

func go_to_level_select():
	menu_tab = "level"
	yield(transition.transition_to_dark(), "completed")
	change_scene_to(STATE.MENU)

