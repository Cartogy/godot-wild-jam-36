extends Resource
class_name BunnyUpgrade

export (int) var res_cost
export (Texture) var tex
export (String, FILE, "*.tscn") var scene_path

func get_cost() -> int:
	return res_cost
