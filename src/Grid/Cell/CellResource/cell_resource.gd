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

func consume_special_resource() -> int:
	if special_res == null:
		return 0
	var res_gained = special_res
	var amount = special_res.amount
	special_res.amount = 0

	return amount

func consumed_special_res():
	return special_res.consumed()
	
func has_special_res():
	return special_res != null
