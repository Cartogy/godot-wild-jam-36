extends Control

onready var _tab_container := $TabContainer

func _ready():
	Flow.pause_menu = self

func show():
	_tab_container.set_current_tab(PauseTab.TABS.MAIN)
	visible = true

func hide():
	visible = false
