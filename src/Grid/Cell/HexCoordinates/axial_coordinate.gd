extends Resource
class_name AxialCoordinate

# x -> q
# y -> r
var x
var y

func _init(q, r):
	x = q
	y = r

func to_vector():
	return Vector2(x,y)
