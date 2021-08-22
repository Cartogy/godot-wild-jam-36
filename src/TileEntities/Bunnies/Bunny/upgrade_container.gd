extends Node2D

var upgrade_holders: Array
var space_between_holders: Vector2 = Vector2(30,0)

func add_holder(holder: Node2D):
	upgrade_holders.append(holder)
	
func place_in_tree():
	var amount = upgrade_holders.size()
	var is_odd = amount % 2 != 0
	
	var center = self.position
	
	# My persoal equation I discovered to
	# obtain that pattern the pascal triangle's rows is known for.
	var pascal_end = center - (space_between_holders / 2) * (amount - 1)
	
	var index = 0
	for h in upgrade_holders:
		var step_from_end_point = index * space_between_holders
		h.global_position = pascal_end + step_from_end_point
		add_child(h)
		index += 1
		
		
