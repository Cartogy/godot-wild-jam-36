extends Node

func path_finding(from: Cell, to: Cell, ignore_edges: bool, obstacles: Array) -> Array:
	var frontier = []
	frontier.append(from)
	var came_from = {}
	came_from[from] = null
	
	while frontier.size() > 0:
		var current: Cell =  frontier.pop_front()
		for next in current.neighbours:
			if came_from.has(next) == false:
				if an_obstacle(next, obstacles) == false:
					frontier.append(next)
					came_from[next] = current
	
	# Find path to cell
	var current: Cell = to
	var path = []
	while current != from:
		path.append(current)
		current = came_from[current]
	#path.append(from)
	path = reverse(path)
	
	return path

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
