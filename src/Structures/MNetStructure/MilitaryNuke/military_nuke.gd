extends MilitaryBase
class_name MilitaryNuke

const nuke_path = preload("res://src/Structures/MNetStructure/MilitaryNuke/Nuke/Nuke.tscn")

# [[Cells]]
# Each index is part of a layer around the base
# layer[0] -> current cell layer [cell]
# layer[1] -> First outer layer [n0, n1, n2, ...]
var layers_to_search: Array = []
var max_layers: int = 3
var missile_launched = false

var scanned = false

func detonated():
	missile_launched = false

func tick():
	if scanned == false:
		scan_and_store(grid.hexagon_coords)
		#debug_layers()
		scanned = true
	attack()

func attack():
	if missile_launched == false:
		var cell_to_fire = find_cell()
		
		if cell_to_fire != null:
		
			var nuke = nuke_path.instance()
			nuke.base_from = self
			nuke.cell_to_nuke = cell_to_fire
			nuke.from_cell = cell
			missile_launched = true
			add_child(nuke)
		
func find_cell():
	randomize()
	var rand_layer = randi() % max_layers + 1
	var layer = layers_to_search[rand_layer]
	while rand_layer >= 0:
		for c in layer:
			print_debug(c.get_state())
			if c.get_state() == "BNet":
				return c
		rand_layer -= 1
			
	return null
		
func scan_and_store(hex_coord: Dictionary):
	layers_to_search.append([cell])
	var visited = {}
	visited[cell] = true
	# Got over layers
	for i in range(0,max_layers+1):
		var layer = []
		# Build layers from neighbours
		for c in layers_to_search[i]:
			for n in c.neighbours:
				if visited.has(n) == false:
					layer.append(n)
					visited[n] = true
		layers_to_search.append(layer)

func debug_layers():
	for l in layers_to_search:
		for c in l:
			c.debug_cell()
