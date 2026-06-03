extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/VFlowContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$HBoxContainer/VFlowContainer/CharacterChoiceButton.pressed.connect(_on_character_choice_pressed)
	MusicManager.play_music(preload("res://Audio/DeathMusic.mp3"))
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_main_menu_pressed () -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
	
func _on_character_choice_pressed () -> void:	
	get_tree().change_scene_to_file("res://Scenes/CharacterSelect/character_select.tscn")
