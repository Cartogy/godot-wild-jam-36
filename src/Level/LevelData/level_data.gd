extends Resource
class_name MapInfo

var total_land_cells: int = 0
var current_land_consumed: int = 0

func reset():
	total_land_cells = 0
	current_land_consumed = 0

# When building the level. DONT USER OTHER THAN THAT PURPOSE
func add_to_total_land(amount: int):
	total_land_cells += 1

func add_consumed(amount: int):
	current_land_consumed += 1

func remove_consumed(amount: int):
	current_land_consumed -= amount

func consumed_all() -> bool:
	if total_land_cells <= current_land_consumed:
		return true
	else:
		return false
