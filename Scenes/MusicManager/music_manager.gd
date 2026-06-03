extends Node

var player: AudioStreamPlayer
var current_music: AudioStream

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	player.volume_db = -20

func play_music(music: AudioStream):
	if current_music == music:
		return

	current_music = music
	player.stream = music
	player.play()

func stop_music():
	player.stop()
	current_music = null
