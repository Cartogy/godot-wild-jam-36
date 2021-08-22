extends Resource
class_name CellSpecialResource

export (Texture) var res_texture
export (Texture) var consumed_texture
export (Texture) var consumed_bnet_texture
export (Texture) var consumed_stationary_texture
var special_resource_name: String
export (int) var amount: int

func consumed() -> bool:
	return amount <= 0

func get_res_texture() -> Texture:
	return res_texture
	
func get_consumed_texture() -> Texture:
	return consumed_texture
	
func get_bnet_consumed_texture() -> Texture:
	return consumed_bnet_texture

func get_consumed_stationary_texture():
	return consumed_stationary_texture
