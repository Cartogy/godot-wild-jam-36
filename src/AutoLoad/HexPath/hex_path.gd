extends Node

func path_finding(from: Cell, to: Cell, ignore_edges: bool, obstacles: Array) -> Array:
	var frontier = []
	frontier.append(from)
	var came_from = {}
	came_from[from] = null
	
	if to == null:
		return []
	print_debug(from.edge_data.edges)
	print_debug(to.edge_data.edges)
	
	if obstacles.has(to.state_machine.current_state.name):
		return []
	
	var found_goal: bool = false
	while frontier.size() > 0:
		var current: Cell =  frontier.pop_front()
		if current == to:
			found_goal = true
			break
		for next in current.neighbours:
			if came_from.has(next) == false:
				if ignore_edges:
					if an_obstacle(next, obstacles) == false:
						frontier.append(next)
						came_from[next] = current
				else:	# Check for edges
					var direction = next.hex_coords - current.hex_coords
					if current.has_edge(direction) == false:
						frontier.append(next)
						came_from[next] = current
					
	
	if found_goal:
	# Find path to cell
		var current: Cell = to
		var path = []
		while current != from:
			path.append(current)
			current = came_from[current]
		#path.append(from)
		path = reverse(path)
	
		return path
	else:
		return []

func an_obstacle(cell: Cell, obstacles: Array):
	var state = cell.state_machine.current_state.name
	if obstacles.has(state):
		return true
	else:
		return false

func reverse(xs: Array) -> Array:
	var rev = []
	for x in xs:
		rev.push_front(x)
	return rev
