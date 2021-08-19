extends Node2D

onready var bnet = $BNet

func _ready():
	bnet.actor_data.connect("update_res", Flow.b_net_ui, "update_resources")
	bnet.actor_data.connect("update_pop", Flow.b_net_ui, "update_population")
	bnet.actor_data.connect("update_max_pop", Flow.b_net_ui, "update_max_population")
