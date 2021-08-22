extends Node2D

export (bool) var DEBUG

export (Vector2) var starting_cell

onready var grid = $Grid
onready var mnet = $MNet
onready var bnet = $BNetView/BNet
onready var camera = $Camera

var starting_den: PackedScene = load("res://src/Structures/BNetStructure/Den/Den.tscn")

var grid_bounds: Rect2
var CAMERA_MOVE_SPEED = 200

# Level Info
var current_map_info: MapInfo = null
var bnet_structure_info: MapStructureInfo = null

func _ready():
	AudioEngine.play_background_music("game")
	# Add starting cell
	#var cell = grid.get_cell(starting_cell)
	#var den = starting_den.instance()

	#bnet.add_starting_structure(den, starting_cell, cell)
	load_level()

func load_level():
	var level_data = Flow.get_level_data()
	if level_data != "":
		var level = load(level_data)
		grid.load_level_grid(level, bnet, mnet,grid.dimensions)
		grid.load_edges(level, grid.hexagon_coords)
	else:
		grid.generate_hex_grid(grid.dimensions, grid.origin, grid.size)

	grid_bounds = grid.get_grid_bounds()
	# Load cell maps
	current_map_info = build_map_info(grid.hexagon_coords)
	# reference den structures
	bnet_structure_info = build_structure_info(bnet.production_structures)

func start_bnet():
	bnet.active = true
	mnet.active = true

func stop_bnet():
	bnet.active = false
	mnet.active = false

func _on_Button_pressed():
	start_bnet()

func _on_Stop_pressed():
	stop_bnet()


func _process(delta):
	if Input.is_action_pressed("ui_down"):
		camera.position += Vector2(0, CAMERA_MOVE_SPEED * delta)
	if Input.is_action_pressed("ui_up"):
		camera.position -= Vector2(0, CAMERA_MOVE_SPEED * delta)
	if Input.is_action_pressed("ui_left"):
		camera.position -= Vector2(CAMERA_MOVE_SPEED * delta, 0)
	if Input.is_action_pressed("ui_right"):
		camera.position += Vector2(CAMERA_MOVE_SPEED * delta, 0)

	camera.position.x = min(max(camera.position.x, grid_bounds.position.x), grid_bounds.end.x)
	camera.position.y = min(max(camera.position.y, grid_bounds.position.y), grid_bounds.end.y)

#####################
## BNet Structures
#####################

func build_structure_info(structures: Dictionary) -> MapStructureInfo:
	var structure_data = MapStructureInfo.new()

	for s in structures.values():
		var bnet_struct: BNetStructure = s
		# Allow buildings to notify when they stop producing
		bnet_struct.connect("became_inept", self, "inept_structure")
		bnet_struct.connect("no_longer_inept", self, "producing_structure")
		structure_data.add_structure_total(1)

	return structure_data

func inept_structure():
	bnet_structure_info.add_inept_structure(1)
	if lost_level():
		AudioEngine.play_effect("lost")
		print_debug("You lost")
		stop_bnet()

func producing_structure():
	bnet_structure_info.remove_inept_structure(1)

func lost_level():
	if bnet_structure_info.all_structures_inept():
		return true
	else:
		return false

#################
## Cell notification
#################

func bnet_lost():
	AudioEngine.play_effect("tile-lost")
	current_map_info.remove_consumed(1)

func bnet_gained():
	AudioEngine.play_effect("tile-consumed")
	current_map_info.add_consumed(1)
	if won_level():
		#Game over
		AudioEngine.play_effect("won")
		print_debug("You Won!!")
		bnet.active = false
		mnet.active = false
		pass

func won_level():
	return current_map_info.consumed_all()

##################
## Level Map Info
##################

func is_consumed(cell: Cell):
	return cell.get_state() == "BNet"

func is_land(cell: Cell):
	if cell.get_state() != "Water":
		return true
	else:
		return false

func build_map_info(hex_cells: Dictionary) -> MapInfo:
	var map_info = MapInfo.new()
	for cell in hex_cells.values():
		if is_consumed(cell):
			map_info.add_consumed(1)
		if is_land(cell):
			map_info.add_to_total_land(1)
			# allow them to notify when consumption occurs
			cell.connect("consumed_cell", self, "bnet_gained")
			cell.connect("lost_cell", self, "bnet_lost")

	return map_info
