extends Control


onready var green = $MarginContainer/HBoxContainer/Land/Green
onready var desert = $MarginContainer/HBoxContainer/Land/Desert
onready var nom = $MarginContainer/HBoxContainer/NomNom/Nom
onready var population = $MarginContainer/HBoxContainer/Population/Count
onready var time = $MarginContainer/HBoxContainer/Time/Time

var population_count = 0
var max_population = 0


func _ready():
	Flow.elapsed_time = 0.0
	Flow.b_net_ui = self

func update_resources(res: int):
	nom.text = str(res)

func update_population_warning():
	if max_population == 0:
		return

	var population_ratio = float(population_count) / max_population
	if population_ratio < 0.7:
		print("Lower population...")
		population.modulate = Color(1, 1, 1, 1)
		$MarginContainer/HBoxContainer/Population/Warning1.visible = false
		$MarginContainer/HBoxContainer/Population/Warning2.visible = false
		$MarginContainer/HBoxContainer/Population/Warning3.visible = false
#		population.get_font("font").size = 16
	elif population_ratio > 0.7 and population_ratio < 0.85:
		population.modulate = Color(1, 1, 0, 1)
		$MarginContainer/HBoxContainer/Population/Warning1.visible = true
		$MarginContainer/HBoxContainer/Population/Warning2.visible = false
		$MarginContainer/HBoxContainer/Population/Warning3.visible = false
#		population.get_font("font").size = 20
	else:
		population.modulate = Color(1, 0, 0, 1)
		$MarginContainer/HBoxContainer/Population/Warning1.visible = true
		$MarginContainer/HBoxContainer/Population/Warning2.visible = true
		$MarginContainer/HBoxContainer/Population/Warning3.visible = true

func update_population(pop: int):
	green.text = str(Flow.loaded_level.current_map_info.total_land_cells - Flow.loaded_level.current_map_info.current_land_consumed)
	desert.text = str(Flow.loaded_level.current_map_info.current_land_consumed)
	population_count = pop

	update_population_warning()
	update_population_text()

func update_population_text():
	population.text = str(population_count) + "/" + str(max_population)

func update_max_population(max_pop: int):
	max_population = max_pop
	update_population_warning()
	update_population_text()


func _process(delta):
	Flow.elapsed_time += delta

	var elapsed_time = Flow.elapsed_time
	time.text = str(int(elapsed_time / 3600)).pad_zeros(2) + ":" + str(int(fmod(elapsed_time / 60, 60))).pad_zeros(2) + ":" + str(int(fmod(elapsed_time, 60))).pad_zeros(2)
