extends Node2D

onready var grid = $Grid

onready var panel = $CanvasLayer/Control/ScrollContainer/VBoxContainer
export (Vector2) var origin = Vector2(0,0)

var tile_option: PackedScene = preload("res://src/MapMaker/Selection/TileOption.tscn")

# Path to pass to data
var structures = {
	"den": "res://src/Structures/BNetStructure/Den/Den.tscn"
}

var tiles = {
	"res://src/Grid/Cell/CellScenes/AvailableCell.tscn": "res://assets/graphics/grass.png",
}

var selected_tile: Node2D = null
var converter = HexConversion.new()

func _ready():
	make_tile_options(tiles)
	grid.display_hex_grid(origin)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if selected_tile != null:
				add_tile(selected_tile, self.get_global_mouse_position())
				selected_tile = null

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
	add_child(tile)
	selected_tile = tile

func add_tile(cell: Cell, cursor: Vector2):
	var hex_coord = grid.pixel_to_hex(self.get_global_mouse_position(), origin)
	var pixel_center = converter.doublewidth_to_pixel(hex_coord, origin, grid.size)
	cell.global_position = pixel_center
