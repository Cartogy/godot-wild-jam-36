extends HexCoordinates
class_name DoubledHexCoordinate

# 0 index -> row
# 1 index -> col
func _init(c: Array).(c):
	pass

func to_cubed() -> Array:
	return []

func to_axial() -> Array:
	return []

func to_double() -> Array:
	return coordinates	
