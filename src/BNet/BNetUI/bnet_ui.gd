extends Control


onready var green = $MarginContainer/HBoxContainer/Land/Green
onready var desert = $MarginContainer/HBoxContainer/Land/Desert
onready var nom = $MarginContainer/HBoxContainer/NomNom/Nom
onready var population = $MarginContainer/HBoxContainer/Population/Count
onready var time = $MarginContainer/HBoxContainer/Time/Time

var population_count = 0
var max_population = 0
var elapsed_time = 0.0

func _ready():
	Flow.b_net_ui = self

func update_resources(res: int):
	nom.text = str(res)

func update_population(pop: int):
	green.text = str(Flow.loaded_level.current_map_info.total_land_cells - Flow.loaded_level.current_map_info.current_land_consumed)
	desert.text = str(Flow.loaded_level.current_map_info.current_land_consumed)
	population_count = pop
	update_population_text()

func update_population_text():
	population.text = str(population_count) + "/" + str(max_population)

func update_max_population(max_pop: int):
	max_population = max_pop
	update_population_text()


func _process(delta):
	elapsed_time += delta

	time.text = str(int(elapsed_time / 3600)).pad_zeros(2) + ":" + str(int(fmod(elapsed_time / 60, 60))).pad_zeros(2) + ":" + str(int(fmod(elapsed_time, 60))).pad_zeros(2)
