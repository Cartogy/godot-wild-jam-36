extends Resource
class_name HexOrientation

# A matrix of 2x2
# 0 -> first row of matrix
# 1 -> Second row of matrix
var hex_to_pixel: Array = []
var pixel_to_hex: Array = []

# Percentage amount going from 0 to 60 degrees
# Flat angle starts at 0 degrees
# Pointy angle starts at 30 degrees.
var start_angle: float

# Determine the orientation
func _init(orientation_type: String) -> void:
	match orientation_type:
		"pointy":
			hex_to_pixel[0] = [sqrt(3.0), sqrt(3.0)/2.0]
			hex_to_pixel[1] = [0, 3.0/2.0]

			pixel_to_hex[0] = [sqrt(3.0)/3.0, -1.0/3.0]
			pixel_to_hex[1] = [0, 2/3]

			start_angle = 0.5
			return
		"flat":
			hex_to_pixel[0] = [3/2, 0]
			hex_to_pixel[1] = [sqrt(3.0)/2.0, sqrt(3)]

			pixel_to_hex[0] = [2.0/3.0, 0]
			pixel_to_hex[1] = [-1.0/3.0, sqrt(3.0)/3.0]

			start_angle = 0.0
			return
	printerr("Invalid orientation type")
	return
