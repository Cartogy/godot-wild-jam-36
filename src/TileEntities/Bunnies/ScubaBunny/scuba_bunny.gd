extends BunnyBase
class_name ScubaBunny



func arrival_from(from, next):
	if next.get_state() == "Water":
		# Implement water animation
		print_debug("Scuba bunny going swimmming")
		pass
	elif next.get_state() == "Available" or next.get_state() == "BNet":
			# implement surfacing animation
			print_debug("Scuba bunny surfacing")

func swim_effect():
	AudioEngine.play_effect("aqua-hop")

func hop_effect():
	AudioEngine.play_effect("hop")
	
func attack_effect():
	AudioEngine.play_effect("munch")
