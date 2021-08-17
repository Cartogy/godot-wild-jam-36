extends Node2D

onready var bnet = $BNet
onready var ui = $BNetUI

func _ready():
	bnet.actor_data.connect("update_res", ui, "update_resources")
	bnet.actor_data.connect("update_pop", ui, "update_population")
