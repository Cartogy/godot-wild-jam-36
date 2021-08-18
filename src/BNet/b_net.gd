extends Node2D
class_name BNet
"""
Responsible for ticking each cell that is being acquired.
"""

export (float) var tick_in_seconds = 1

onready var tick_timer = $TickTimer
onready var actor_data = $ActorData

# Cells that are consuming/populating another cell.
# These cells are already consumed
# Hex_Coord -> Cell

# Will be the only ones to acquire/consume another cell.
var production_structures: Dictionary
# HexCoord -> Cell
var consumed_cells: Dictionary

# Run BNet
var active = false

func _ready():
	#active = true
	tick_timer.start(tick_in_seconds)

func _physics_process(delta):
	if active:
		if tick_timer.is_stopped():
			tick_cells()
			tick_timer.start(tick_in_seconds)
	
func tick_cells():
	for c in production_structures.values():
		c.tick()
		
#####
# Adding
#####

func add_structure(structure: BNetStructure, hex_coord: Vector2, cell: Cell):
	
	production_structures[hex_coord] = structure

	print_debug()
	structure.place_on_cell(cell)
	structure.add_to_bnet(self)
	add_child(structure)

func add_starting_structure(structure: BNetStructure, hex_coord:Vector2, cell: Cell):
	add_structure(structure, hex_coord, cell)
	structure.starting_structure()
