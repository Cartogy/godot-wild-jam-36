extends Node2D
class_name MNet

export (float) var tick_in_seconds = 1.0

onready var tick_timer = $Timer

var active: bool = false

# hex Coord -> Base
var military_base = {}


func _physics_process(delta):
	if active:
		if tick_timer.is_stopped():
			tick_base()
			tick_timer.start(tick_in_seconds)

func tick_base():
	for m in military_base.values():
		m.tick()

func add_structure(structure: MilitaryBase, hex_coord: Vector2, cell):
	structure.place_on_cell(cell)
	structure.add_to_mnet(self)
	structure.net = self
	add_child(structure)
	military_base[hex_coord] = structure

func remove_structure(structure: MilitaryBase):
	pass
