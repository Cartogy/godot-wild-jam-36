extends Control

onready var resources = $Resources
onready var population = $Population

func _ready():
	Flow.b_net_ui = self

func update_resources(res: int):
	resources.text = str(res)

func update_population(pop: int):
	population.text = str(pop)
