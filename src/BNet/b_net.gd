extends Node

export (float) var tick_in_seconds = 1

onready var tick_timer = $TickTimer

# Cells that are consuming/populating another cell.
# These cels are already consume.
# Hex_Coord -> Cell
var consuming_cells: Dictionary

var active=  false

func _ready():
	#active = true
	tick_timer.start(tick_in_seconds)

func _physics_process(delta):
	if active:
		if tick_timer.is_stopped():
			tick_cells()
			tick_timer.start(tick_in_seconds)
	
# Called by cell when consumption is finished
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

func add_consuming_cell(hex_coord: Vector2, cell: Cell):
	consuming_cells[hex_coord] = cell
	cell.connect("consumption_complete", self, "cell_consumed")
	cell.triggered()
	var n = cell.find_neighbour_to_consume()
	if n != null:
		cell.current_cell_consumption = n
	else:
		consuming_cells.erase(hex_coord)
