extends Resource
class_name CubeCoordinate

var x
var y
var z

func _init(xs, ys, zs):
	x = xs
	y = ys
	z = zs
	
func to_vector():
	return Vector3(x,y,z)
