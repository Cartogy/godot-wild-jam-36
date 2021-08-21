extends CellStructure
class_name MilitaryBase

var mnet

export (Texture) var military_texture

func tick():
	pass

func attack():
	pass

func add_to_mnet(p_mnet):
	mnet = p_mnet

func remove_from_net(net):
	net.remove_structure(self)
