extends Node

var total_resources: int
var total_population: int

signal update_res(new_amount)
signal update_pop(new_amount)

func add_resources(res: CellResource):
	var nom_noms = res.resource_amount
	var special:CellSpecialResource = res.special_res
	
	var total_gained = nom_noms
	if special != null:
		total_gained += special.amount
		
	total_resources += total_gained
	emit_signal("update_res", total_resources)
	
func remove_resources(amount: int):
	total_resources -= amount
	emit_signal("update_res", total_resources)
	
func add_population(amount: int):
	total_population += amount
	emit_signal("update_pop", total_population)
	
func remove_population(amount: int):
	total_population -= amount
	emit_signal("update_pop", total_population)
