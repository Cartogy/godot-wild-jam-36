extends MenuTab

onready var _back_button := $BackContainer/BackButton


func _ready():
	var _error : int = _back_button.connect("pressed", self, "_on_back_button_pressed")

func _on_back_button_pressed():
	Flow.save_user_settings()
	emit_signal("button_pressed", TABS.MAIN)
