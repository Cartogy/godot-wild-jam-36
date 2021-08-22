"""
Audio Engine

"""
extends Node

onready var background_players = {
	"first": $BackgroundPlayer,
	"second": $SecondBackgroundPlayer,
}

var current_background_player = null


const tracks = {
	"menu": "res://assets/audio/music/GWJ36_Menu_Loopable.ogg",
	"game": "res://assets/audio/music/GWJ36_Main_Theme_loopable_v1.ogg",
}

const sfx = {
	"munch": "res://assets/audio/sfx/Bunnies_Munching_v1.ogg",
	"spawn": "res://assets/audio/sfx/Bunnies_Spawning_v2.ogg",
	"death": "res://assets/audio/sfx/Bunny_death_v1.ogg",
	"hop": "res://assets/audio/sfx/Bunny_hop_v1.ogg",
	"defeat": "res://assets/audio/sfx/GWJ36_Losing_Tune_v1.ogg",
	"victory": "res://assets/audio/sfx/GWJ36_Winning_Tune_v2.ogg",
	"aqua-hop": "res://assets/audio/sfx/Aqua_Bunny_Swim_v1.ogg",
	"smash-attack": "res://assets/audio/sfx/Buff_Bunny_Smash_v2.ogg",
	"den-construction": "res://assets/audio/sfx/Den_construction_v2.ogg",
	"tile-consumed": "res://assets/audio/sfx/Tile_conquored_v2.ogg",
	"tile-lost": "res://assets/audio/sfx/Tile_unconquored_v1.ogg",
	"gas": "res://assets/audio/sfx/gas_v3.ogg",
	"gunshot": "res://assets/audio/sfx/Gunshot_v1.ogg",
	"nom-nom": "res://assets/audio/sfx/Nom_Noms_Gained_v1.ogg",
	"won": "res://assets/audio/sfx/GWJ36_Winning_Tune_v2.ogg",
	"lost": "res://assets/audio/sfx/GWJ36_Losing_Tune_v1.ogg",
}


onready var background_player: AudioStreamPlayer = $BackgroundPlayer
onready var ambiance_player: AudioStreamPlayer = $AmbiancePlayer
onready var dialogue_player: AudioStreamPlayer = $DialoguePlayer
onready var effects: Node = $Effects


func convert_scale_to_db(scale: float):
	return 20 * log(scale) / log(10)


var background_audio = null

export var MAX_SIMULTANEOUS_EFFECTS = 10


func _ready():
	#play_background_music("light_rain")
	for _i in range(MAX_SIMULTANEOUS_EFFECTS):
		effects.add_effect()


func play_effect(effect_name: String):
	effects.play_effect(sfx[effect_name])

func play_background_music(track_name: String):
	var track_path = tracks[track_name]
	if background_audio == track_path:
		return

	var background_player = null
	if current_background_player == null:
		current_background_player = background_players.first
		background_audio = track_path
		current_background_player.stream = load(track_path)
		current_background_player.play()
	else:
		if current_background_player == background_players.first:
			$AnimationPlayer.play("switch_2")
			current_background_player = background_players.second
			background_audio = track_path
			current_background_player.stream = load(track_path)
			current_background_player.play()
		elif current_background_player == background_players.second:
			$AnimationPlayer.play("switch_1")
			current_background_player = background_players.first
			background_audio = track_path
			current_background_player.stream = load(track_path)
			current_background_player.play()


func reset():
#	effects.reset()
	stop_background_music()

func play_ambiance():
	ambiance_player.play()

func stop_ambiance():
	ambiance_player.stop()

func stop_background_music():
	"""Stops the background music track"""
	if background_player.playing:
		background_player.stop()
		background_audio = null
