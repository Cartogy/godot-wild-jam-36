extends Control

onready var resources = $Resources
onready var population = $Population
onready var max_population = $MaxPopulation

func _ready():
	Flow.b_net_ui = self

func update_resources(res: int):
	resources.text = str(res)

func update_population(pop: int):
	population.text = str(pop)

func update_max_population(max_pop: int):
	max_population.text = str(max_pop)
