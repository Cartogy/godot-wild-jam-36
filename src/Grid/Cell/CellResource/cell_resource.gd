extends Node
class_name CellResource

# Nom Noms
export (int) var resource_amount: int = 5
export (int) var population_amount: int = 7
var special_res: CellSpecialResource = null

func set_resource_amout(amount: int):
	resource_amount = amount

func get_amount() -> int:
	return resource_amount

func get_population() -> int:
	return population_amount

func consume_resource() -> int:
	var resource_gained = resource_amount
	resource_amount = 0
	
	return resource_gained

func consume_special_resource() -> CellSpecialResource:
	var res_gained = special_res
	special_res = null

	return res_gained
