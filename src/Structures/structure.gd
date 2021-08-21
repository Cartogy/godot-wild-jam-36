extends Node2D
class_name CellStructure

"""
A structure such as a Den, Town or any building.
"""

export (String) var structure_id
export (int) var health = 100

export (Texture) var conquered_sprite

# Current cell it is on
var cell
var hex_coord
var net
var grid


func _ready():
	pass

func place_on_cell(p_cell):
	var center = p_cell.get_hex_center()
	print_debug(center)

	cell = p_cell
	cell.structure = self
	hex_coord = cell.hex_coords
	self.global_position = p_cell.real_hex_center

func damage(amount: int):
	health -= amount

	if health <= 0:
		destroy()

func destroy():
	cell.structure_destroyed()
	get_node("Sprite").texture = conquered_sprite
	remove_from_net(net)

func remove_from_net(net):
	pass
