extends Control

func _ready():   
	var btn = get_node("Button")
	btn.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/CharacterSelect/character_select.tscn")
