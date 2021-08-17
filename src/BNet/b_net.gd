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
var consuming_cells: Dictionary

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
	cell_consumed.triggered()
	var next_cell = from.breadth_search_neighbours()
	if next_cell != null:
		from.current_cell_consumption = next_cell
	else:
		from.current_cell_consumption = null
		

func tick_cells():
	for c in consuming_cells.values():
		c.tick()
		
#####
# Adding
#####

# Adds a new production cell to take into acount
func add_consuming_cell(hex_coord: Vector2, cell: Cell):
	consuming_cells[hex_coord] = cell
	cell.connect("consumption_complete", self, "cell_consumed")
	cell.triggered()
	var n = cell.find_neighbour_to_consume()
	if n != null:
		cell.current_cell_consumption = n
	else:
		consuming_cells.erase(hex_coord)
