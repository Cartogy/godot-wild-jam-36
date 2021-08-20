extends Node2D
class_name EdgeDisplay


export (Vector2) var direction
export (String, FILE, "*.tscn") var edge_scene

var self_scene

func _ready():
	self_scene = filename
