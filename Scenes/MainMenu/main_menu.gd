extends Control


func _ready():   
	# Usando o caminho completo a partir do nó Control
	var btn = $VBoxContainer/PlayButton
	btn.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/CharacterSelect/character_select.tscn")
