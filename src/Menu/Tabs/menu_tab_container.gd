extends TabContainer

func _ready():
	for child in get_children():
		if child is MenuTab:
			child.connect("button_pressed", self, "set_current_tab")

	if Flow.menu_tab != null:
		if Flow.menu_tab == "level":
			# bit dirty hardcode, uses enum from menu_tab.gd value
			set_current_tab(2)
		Flow.menu_tab = null

func set_current_tab(type : int):
	var index := 0
	for child in get_children():
		if child.tab_type == type:
			child.update_tab()
			current_tab = index

			return
		index += 1
