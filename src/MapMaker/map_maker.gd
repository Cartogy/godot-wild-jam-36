extends Node2D

onready var grid = $Grid

onready var panel = $CanvasLayer/Control/ScrollContainer/VBoxContainer
onready var line_edit = $CanvasLayer/Control/LineEdit
onready var cell_holder = $CellHolder
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
	"res://src/MapMaker/TileDisplay/Cells/WaterDisplay.tscn": "res://assets/graphics/c_water.png"
}

var selected_tile: Node2D = null
var selected_scene_path: String  = ""
var converter = HexConversion.new()
var level = LevelData.new()
# Hex coord -> tile display
var current_tiles: Dictionary

func _ready():
	make_tile_options(tiles)
	grid.display_hex_grid(origin)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if selected_tile != null:
				add_tile(selected_tile, self.get_global_mouse_position())
				selected_tile = null
				selected_scene_path = ""
				
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			if selected_tile != null:
				selected_tile.queue_free()
				selected_tile = null
			else:
				var hex_coord = grid.pixel_to_hex(self.get_global_mouse_position(), origin)
				var pixel_center = converter.doublewidth_to_pixel(hex_coord, origin, grid.size)
				
				if level.level_data.has(hex_coord.to_vector()):
					var tile: TileDisplay = current_tiles[hex_coord.to_vector()]
					level.level_data.erase(hex_coord.to_vector())
					tile.queue_free()
		

func _process(delta):
	if selected_tile != null:
		var hex_coord = grid.pixel_to_hex(self.get_global_mouse_position(), origin)
		var pixel_center = converter.doublewidth_to_pixel(hex_coord, origin, grid.size)
		
		selected_tile.global_position = pixel_center

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
	if selected_tile != null:
		remove_child(selected_tile)
		var old_tile = selected_tile
		selected_tile = null
		old_tile.queue_free()
	var scene: PackedScene = load(scene_path)
	var tile = scene.instance()
	cell_holder.add_child(tile)
	selected_tile = tile
	selected_scene_path = scene_path

func add_tile(cell: TileDisplay, cursor: Vector2):
	var hex_coord = grid.pixel_to_hex(self.get_global_mouse_position(), origin)
	var pixel_center = converter.doublewidth_to_pixel(hex_coord, origin, grid.size)
	cell.global_position = pixel_center
	
	current_tiles[hex_coord.to_vector()] = selected_tile
	level.add_cell(hex_coord, cell)

func save_level(p_level: LevelData, file_to_save: String):
	p_level.grid_origin = origin
	ResourceSaver.save(file_to_save, p_level)
	
func load_level(file_to_load):
	var dir = Directory.new()
	if not dir.file_exists(file_to_load):
		return false
	print_debug(file_to_load)
	var level_save: LevelData = load(file_to_load)
	
	origin = level_save.grid_origin
	for hex_coord in level_save.level_data.keys():
		var cell_data:Dictionary = level_save.level_data[hex_coord]
		spawn_cell(hex_coord, cell_data)

		
func spawn_cell(hex_coord: Vector2, cell_data: Dictionary):
	var scene: PackedScene = load(cell_data.tile_display)
	print_debug(cell_data)
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
