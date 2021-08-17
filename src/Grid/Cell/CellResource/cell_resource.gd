extends Node
class_name CellResource

# Nom Noms
export (int) var resource_amount: int = 5
var special_res: CellSpecialResource = null

func set_resource_amout(amount: int):
	resource_amount = amount

func get_amount() -> int:
	return resource_amount

