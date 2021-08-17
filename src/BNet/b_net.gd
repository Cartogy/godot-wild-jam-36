extends Node
class_name BNet
"""
Responsible for ticking each cell that is being acquired.
"""

export (float) var tick_in_seconds = 1

onready var tick_timer = $TickTimer

# Cells that are consuming/populating another cell.
# These cells are already consumed
# Hex_Coord -> Cell

# TODO: Refactor. This will store production cells (Cells with Buildings) as cells that have Dens
# Will be the only ones to acquire/consume another cell.
var production_cells: Dictionary
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
	
# Called by cell production when consumption is finished
func cell_consumed(from: Cell, cell_consumed: Cell):
	consumed_cells[cell_consumed.hex_coords] = cell_consumed
	
	var next_cell = from.breadth_search_neighbours()
	if next_cell != null:
		from.consume_cell(next_cell)
	else:
		printerr("No neighbours to consume")
		

func tick_cells():
	for c in production_cells.values():
		c.tick()
		
#####
# Adding
#####

# Adds a new production cell to take into acount
func add_consuming_cell(hex_coord: Vector2, cell: Cell):
	production_cells[hex_coord] = cell
	cell.connect("consumption_complete", self, "cell_consumed")
	cell.triggered()
	var n = cell.breadth_search_neighbours()
	if n != null:
		# Make it a production cell
		cell.bnet_produce()
		cell.consume_cell(n)
	else:
		production_cells.erase(hex_coord)
