extends Node2D

export (bool) var DEBUG

export (Vector2) var starting_cell

onready var grid = $Grid
onready var bnet = $BNetView/BNet

func _ready():
	# Add starting cell
	var cell = grid.get_cell(starting_cell)
	bnet.add_consuming_cell(starting_cell, cell)

func start_bnet():
	bnet.active = true


func _on_Button_pressed():
	start_bnet()
