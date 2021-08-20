extends Node2D

export (bool) var DEBUG

export (Vector2) var starting_cell

onready var grid = $Grid
onready var mnet = $MNet
onready var bnet = $BNetView/BNet
onready var camera = $Camera

export (String, FILE, "*.tres") var level_data
var starting_den: PackedScene = load("res://src/Structures/BNetStructure/Den/Den.tscn")

var grid_bounds: Rect2
var CAMERA_MOVE_SPEED = 200

func _ready():
	# Add starting cell
	#var cell = grid.get_cell(starting_cell)
	#var den = starting_den.instance()

	#bnet.add_starting_structure(den, starting_cell, cell)
	
	if level_data != "":
		var level = load(level_data)
		grid.load_level_grid(level, bnet, mnet,grid.dimensions)
	else:
		grid.generate_hex_grid(grid.dimensions, grid.origin, grid.size)
	grid.display_hex_grid(grid.origin)
	
	grid_bounds = grid.get_grid_bounds()

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

