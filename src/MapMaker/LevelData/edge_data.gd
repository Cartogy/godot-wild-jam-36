extends Resource
class_name EdgeData

export (Vector2) var hex_coord_0
export (Vector2) var hex_coord_1

func _init(dir, h0, h1):
	hex_coord_0 = h0
	hex_coord_1 = h1

