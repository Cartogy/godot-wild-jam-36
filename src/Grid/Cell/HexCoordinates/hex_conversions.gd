extends Resource
class_name HexConversion

## Coordinate Conversions

func axial_to_cube(axial):
	var x = axial.x
	var z = axial.y
	var y = -x-z
	
	return CubeCoordinate.new(x, y, z)
	
func cube_to_axial(cube):
	var q = cube.x
	var r = cube.z
	
	return AxialCoordinate.new(q, r)
	
func cube_to_double_width(cube):
	var col = 2 * cube.x + cube.z
	var row = cube.z
	
	return DoubleCoordinate.new(row, col)

func doublewidth_to_cube(db):
	var x = (db.col - db.row) / 2
	var z = db.row
	var y = -x-z
	return CubeCoordinate.new(x,y,z)

## Pixel Conversions
func doublewidth_to_pixel(double, grid_origin: Vector2, p_size: Vector2) -> Vector2:
	var col = double.col
	var row = double.row
	
	var x = p_size.x * sqrt(3)/2 * col
	var y = p_size.y * 3/2 * row
	
	return Vector2(x + grid_origin.x, y - grid_origin.y)
	
func pixel_to_doublewidth(point: Vector2, grid_origin: Vector2, p_size: Vector2):
	var pt = Vector2(point.x - grid_origin.x, point.y + grid_origin.y)
	
	var col = pt.x / (p_size.x * sqrt(3)/2)
	var row = pt.y / (p_size.y * 3/2)
	
	return DoubleCoordinate.new(row, col)

func cube_round(cube):
	var rx = round(cube.x)
	var ry = round(cube.y)
	var rz = round(cube.z)
	
	var x_diff = abs(rx - cube.x)
	var y_diff = abs(ry - cube.y)
	var z_diff = abs(rz - cube.z)
	
	if x_diff > y_diff and x_diff > z_diff:
		rx = -ry-rz
	elif y_diff > z_diff:
		ry = -rx-rz
	else:
		rz = -rx-ry
	
	return CubeCoordinate.new(rx, ry, rz)
