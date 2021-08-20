extends Resource
class_name MapStructureInfo



var total_structures: int = 0
var current_inept_structure: int = 0

# Only used when loading the level!!
func add_structure_total(amount: int):
	total_structures += amount


func add_inept_structure(amount: int):
	current_inept_structure += 1
	
func remove_inept_structure(amount: int):
	current_inept_structure -= 1
	
# Game over condition
func all_structures_inept() -> bool:
	return total_structures <= current_inept_structure
