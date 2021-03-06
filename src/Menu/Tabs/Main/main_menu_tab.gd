extends MenuTab

onready var _new_button := $VBoxContainer/VBoxContainer/NewButton
onready var _settings_button := $VBoxContainer/VBoxContainer/SettingsButton
onready var _quit_button := $VBoxContainer/VBoxContainer/QuitButton
onready var _credits_button := $VBoxContainer/VBoxContainer/CreditsButton


const NEW_TEXT := "NEW_NOTIFICATION"
const SAVE_TEXT := "SAVE_NOTIFICATION"
const LOAD_TEXT := "LOAD_NOTIFICATION"

func _ready():
	var _error: int = _settings_button.connect("pressed", self, "_on_settings_button_pressed")

	if OS.get_name() == "HTML5":
		_quit_button.visible = false
	else:
		_quit_button.visible = true
		_error = _quit_button.connect("pressed", self, "_on_quit_button_pressed")

	_error = _credits_button.connect("pressed", self, "_on_credits_button_pressed")

	_error =_new_button.connect("pressed", self, "_on_new_button_pressed")


func _on_settings_button_pressed():
	emit_signal("button_pressed", TABS.SETTINGS)


func _on_new_button_pressed():
	emit_signal("button_pressed", TABS.LEVEL_SELECT)

func _on_button_mouse_entered():
	pass

func _on_credits_button_pressed():
	emit_signal("button_pressed", TABS.CREDITS)
