extends Node2D
class_name TileDisplay

export (String, FILE, "*.tscn") var cell_scene_path
export (String, FILE, "*.tscn") var structure_scene_path
export (String, FILE, "*.tres") var resource_path

var hex_coord: Vector2
var self_scene

func _ready():
	self_scene = self.filename

