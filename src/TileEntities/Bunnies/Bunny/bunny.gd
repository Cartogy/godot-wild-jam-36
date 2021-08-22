extends BunnyBase
class_name Bunny

onready var upgrades = $Upgrades

# Resource of bunny
export (Array) var bunny_upgrades

var upgrade_select = preload("res://src/TileEntities/Bunnies/Bunny/Upgrades/Upgrade.tscn")


func _ready():
	#._ready()
	obstacles = ["Water"]
	_fill_upgrades(bunny_upgrades)
	hide_upgrades()


func show_upgrades():
	upgrades.visible = true

func hide_upgrades():
	upgrades.visible = false

func _upgrade_bunny(upgrade: BunnyUpgrade):
	var cost = upgrade.get_cost()
	var bnet_data = bnet.actor_data

	var total_nom_noms = bnet_data.total_resources
	if cost <= total_nom_noms:
		bnet_data.remove_resources(cost)

		buy_upgrade(cell, upgrade)

		# Goodbye, bunny
		self.queue_free()
	else:
		print_debug("Cant buy upgrade")
		hide_upgrades()

func buy_upgrade(p_cell: Cell, upgrade: BunnyUpgrade):

	var new_bunny_scene: PackedScene = load(upgrade.scene_path)
	var new_bunny = new_bunny_scene.instance()
	pass_bunny_info(self, new_bunny)

	p_cell.bunnies.remove_bunny(self)

func can_not_buy_upgrades():
	hide_upgrades()

func _fill_upgrades(upgr: Array):
	for u in upgr:
		var upgrade: BunnyUpgrade = u
		var upgrade_holder = upgrade_select.instance()

		upgrade_holder.set_upgrade(upgrade)
		upgrade_holder.set_texture(upgrade.tex)

		upgrade_holder.connect("selected", self, "_upgrade_bunny")
		upgrades.add_holder(upgrade_holder)
	upgrades.place_in_tree()

func pass_bunny_info(from: BunnyBase, to: BunnyBase):
	to.hex_center = from.hex_center
	to.hex_coord = from.hex_coord
	to.cell = from.cell
	to.selectable = from.selectable

	to.bnet = from.bnet
	to.on_cell = from.on_cell

	to.global_position = from.global_position
	to.z_index = from.z_index
	to.bnet.add_child(to)
	to.arrived_at(to.cell)


func hop_effect():
	AudioEngine.play_effect("hop")
	
func attack_effect():
	AudioEngine.play_effect("munch")
