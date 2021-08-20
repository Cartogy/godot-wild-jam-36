extends Node2D
class_name EdgeDisplay


export (Vector2) var direction
export (Vector2) var hex_coord_0
export (Vector2) var hex_coord_1
export (String, FILE, "*.tscn") var edge_scene

var self_scene

func _ready():
	self_scene = filename

func build_data() -> Dictionary:
	var data = {
			"direction": direction,
			"from": hex_coord_0,
			"to": hex_coord_1,
			"edge_scene": edge_scene,
			"edge_position": self.global_position,
			"tile_display": self_scene
	}

	return data
