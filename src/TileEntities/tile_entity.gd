extends KinematicBody2D
class_name TileEntity

var hex_center: Vector2
var hex_coord

# If the player cen select it or not.
var selectable: bool = false

# How far it can go from the center when idle
var max_radius_idle: float
