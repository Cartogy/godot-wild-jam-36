extends Node2D

export (bool) var DEBUG

export (Vector2) var starting_cell

onready var grid = $Grid
onready var bnet = $BNetView/BNet

var starting_den: PackedScene = load("res://src/Structures/BNetStructure/Den/Den.tscn")

func _ready():
	# Add starting cell
	var cell = grid.get_cell(starting_cell)
	var den = starting_den.instance()

	bnet.add_starting_structure(den, starting_cell, cell)

func start_bnet():
	bnet.active = true

func stop_bnet():
	bnet.active = false

func _on_Button_pressed():
	start_bnet()


func _on_Stop_pressed():
	stop_bnet()
