extends Resource
class_name DoubleCoordinate

var col
var row

func _init(r, c):
	row = r
	col = c

func to_pixel(grid_origin: Vector2, p_size: Vector2) -> Vector2:
	
	var x = p_size.x * sqrt(3)/2 * col
	var y = p_size.y * 3/2 * row
	
	return Vector2(x + grid_origin.x, y - grid_origin.y)

func to_vector():
	return Vector2(col, row)
