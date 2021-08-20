extends Node2D

onready var grid = $Grid

onready var panel = $CanvasLayer/Control/ScrollContainer/VBoxContainer
onready var edges = $CanvasLayer/Control/ScrollContainer2/VBoxContainer
onready var line_edit = $CanvasLayer/Control/LineEdit
onready var cell_holder = $CellHolder
onready var edge_holder = $EdgeHolder
export (Vector2) var origin = Vector2(0,0)

var tile_option: PackedScene = preload("res://src/MapMaker/Selection/TileOption.tscn")

const level_locations = "res://src/Level/CustomLevels/"

# Path to pass to data
var structures = {
	"den": "res://src/Structures/BNetStructure/Den/Den.tscn"
}

var tiles = {
	"res://src/MapMaker/TileDisplay/Cells/AvailableDisplay.tscn": "res://assets/graphics/grass.png",
	"res://src/MapMaker/TileDisplay/Cells/BNetDisplay.tscn": "res://assets/graphics/desert.png",
	"res://src/MapMaker/TileDisplay/Cells/WaterDisplay.tscn": "res://assets/graphics/c_water.png",
	"res://src/MapMaker/TileDisplay/Cells/GunnerDisplay.tscn": "res://assets/graphics/desert_city.png",
}

var selected_entity: Node2D = null
var selected_scene_path: String  = ""
var converter = HexConversion.new()
var level = LevelData.new()
# Hex coord -> tile display
var current_tiles: Dictionary
# Hex Coord -> [EdgesDisplay]
var current_edges: Dictionary

func _ready():
	make_tile_options(tiles)
	grid.origin = origin
	grid.display_hex_grid(origin)
	for e in edges.get_children():
		e.connect("tile_selected", self, "edge_selected")
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if selected_entity != null:
				if selected_entity is TileDisplay:
					add_tile(selected_entity, self.get_global_mouse_position())
					selected_entity = null
				elif selected_entity is EdgeDisplay:
					add_edge(selected_entity, self.get_global_mouse_position())
					selected_entity = null
		# Remove Stuff
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			if selected_entity != null:
				selected_entity.queue_free()
				selected_entity = null
			else:
				var hex_coord = grid.pixel_to_hex(self.get_global_mouse_position())
				var pixel_center = converter.doublewidth_to_pixel(hex_coord, origin, grid.size)
				
				if level.level_data.has(hex_coord.to_vector()):
					var tile: TileDisplay = current_tiles[hex_coord.to_vector()]
					level.level_data.erase(hex_coord.to_vector())
					tile.queue_free()
				remove_edge(hex_coord)
						
		

func _process(delta):
	if selected_entity != null:
		var hex_coord = grid.pixel_to_hex(self.get_global_mouse_position())
		var pixel_center = converter.doublewidth_to_pixel(hex_coord, grid.origin, grid.size)
		
		if selected_entity is EdgeDisplay:
			var next_coord = hex_coord.to_vector() + selected_entity.direction
			var next_center = converter.doublewidth_to_pixel(DoubleCoordinate.new(next_coord.y,next_coord.x), origin, grid.size)
			
			var mid_v = (next_center - pixel_center) / 2
			var edge_centre = mid_v + pixel_center
			
			selected_entity.global_position = edge_centre
			
		else:
			selected_entity.global_position = pixel_center
			
func calculate_edge_position(hex_coord: DoubleCoordinate, direction: Vector2):
	var pixel_center = converter.doublewidth_to_pixel(hex_coord, grid.origin, grid.size)
	var next_coord = hex_coord.to_vector() + direction
	var next_center = converter.doublewidth_to_pixel(DoubleCoordinate.new(next_coord.y, next_coord.x), grid.origin, grid.size)
	
	var mid_v = (next_center - pixel_center) / 2
	var edge_centre = mid_v + pixel_center
	
	return edge_centre

func make_tile_options(p_tiles: Dictionary):
	for k in p_tiles.keys():
		var scene_path = k
		var texture_path = p_tiles[k]
		
		var option = tile_option.instance()
		panel.add_child(option)
		option.connect("tile_selected", self, "tile_selected")
		option.build_option(scene_path, texture_path)
		
func tile_selected(scene_path):
	# Delete old tile before selecting a new one
	if selected_entity != null:
		remove_child(selected_entity)
		var old_tile = selected_entity
		selected_entity = null
		old_tile.queue_free()
	var scene: PackedScene = load(scene_path)
	var tile = scene.instance()
	cell_holder.add_child(tile)
	selected_entity = tile
	selected_scene_path = scene_path

func add_tile(cell: TileDisplay, cursor: Vector2):
	var hex_coord = grid.pixel_to_hex(self.get_global_mouse_position())
	var pixel_center = converter.doublewidth_to_pixel(hex_coord, origin, grid.size)
	cell.global_position = pixel_center
	
	if level.level_data.has(hex_coord.to_vector()) == false:
		current_tiles[hex_coord.to_vector()] = selected_entity
		level.add_cell(hex_coord, cell)
	else:
		printerr("Adding ontop of edge")
	
	
###################
## Edge interface
###################
	
	
func edge_selected(scene_path):
	if selected_entity != null:
		remove_child(selected_entity)
		var old_tile = selected_entity
		selected_entity = null
		old_tile.queue_free()
		
	var scene: PackedScene = load(scene_path)
	var edge = scene.instance()
	edge_holder.add_child(edge)
	selected_entity = edge
	
func add_edge(edge: EdgeDisplay, cursor: Vector2):
	var hex_coord = grid.pixel_to_hex(cursor)
	var edge_center = calculate_edge_position(hex_coord, edge.direction)

	if level.has_edge(hex_coord.to_vector(), edge.direction) == false:
		edge.global_position = edge_center
		# Add edge data to level
		edge.hex_coord_0 = hex_coord.to_vector()
		edge.hex_coord_1 = hex_coord.to_vector() + edge.direction
		level.add_edge(hex_coord, edge)
		# Store edge in scene for later manipulation
		store_edge_in_tree(edge, hex_coord.to_vector())
			
		selected_entity = null
	else:
		printerr("Edge already in place")
		
		
func remove_edge(hex_coord: DoubleCoordinate):
	var hex = hex_coord.to_vector()
	var edges = edge_holder[hex]
	
	for e in edges:
		level.remove_edge(e)
		e.queue_free()

func store_edge_in_tree(edge: EdgeDisplay, hex_coord: Vector2):
	if current_edges.has(hex_coord):
		# Get directions added
		var edges: Array = current_edges.get(hex_coord)
		# Add edge if not in coord
		if edges.has(edge) == false:
			edges.append(edge)
	else:	# Add edge
		current_edges[hex_coord] = [edge]

########################
## Load/Save Interface
#########################


func save_level(p_level: LevelData, file_to_save: String):
	p_level.grid_origin = origin
	ResourceSaver.save(file_to_save, p_level)
	
func load_level(file_to_load):
	var dir = Directory.new()
	if not dir.file_exists(file_to_load):
		return false
	var level_save: LevelData = load(file_to_load)
	
	origin = level_save.grid_origin
	# Load cells
	for hex_coord in level_save.level_data.keys():
		var cell_data:Dictionary = level_save.level_data[hex_coord]
		spawn_cell(hex_coord, cell_data)
		
	# TODO: Load Edges
	for hex_coord in level_save.edge_data.keys():
		var directions: Dictionary = level_save.edge_data.get(hex_coord)
		for edge_data in directions.values():
			spawn_edge(hex_coord, edge_data)
			

		
func spawn_cell(hex_coord: Vector2, cell_data: Dictionary):
	var scene: PackedScene = load(cell_data.tile_display)
	var cell: TileDisplay = scene.instance()
	
	cell.hex_coord = cell_data.hex_coord
	cell.global_position = cell_data.cell_position
	cell.cell_scene_path = cell_data.scene_path
	cell.structure_scene_path = cell_data.structure_path
	cell.resource_path = cell_data.spec_resource_path
	cell.self_scene = cell_data.tile_display
	
	current_tiles[hex_coord] = cell
	level.add_cell(DoubleCoordinate.new(hex_coord.y, hex_coord.x), cell)
	current_tiles[hex_coord] = cell
	cell_holder.add_child(cell)
	
func spawn_edge(hex_coord: Vector2, edge_data: Dictionary):
	print_debug(edge_data)
	var direction = edge_data.direction
	var edge_position = edge_data.edge_position
	var edge_scene = edge_data.edge_scene
	var from = edge_data.from
	var to = edge_data.to
	var tile_display_scene = edge_data.tile_display
	
	var scene: PackedScene = load(tile_display_scene)
	var edge: EdgeDisplay = scene.instance()
	edge.global_position = edge_position
	edge.direction = direction
	edge.hex_coord_0 = from
	edge.hex_coord_1 = to
	edge.edge_scene = edge_scene
	
	store_edge_in_tree(edge, from)
	edge_holder.add_child(edge)
	
	
	
func clear_level():
	level.clear()
	current_tiles.clear()
	for c in cell_holder.get_children():
		c.queue_free()

func _on_Button_pressed():
	line_edit.text
	var file_location = level_locations + line_edit.text + ".tres"
	if line_edit.text != "":
		save_level(level, file_location)
	else:
		printerr("Enter a Save location")


func _on_Save2_pressed():
	var file_location = level_locations + line_edit.text + ".tres"
	if line_edit.text != "":
		clear_level()
		load_level(file_location)
	else:
		printerr("Enter a save location")


func _on_Clear_pressed():
	clear_level()
