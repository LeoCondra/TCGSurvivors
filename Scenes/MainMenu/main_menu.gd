extends Control

var settings_scene = preload("res://Scenes/Settings/settings.tscn")
var settings_node: Node = null

func _ready():
	$VBoxContainer/PlayButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/SettingsBtn.pressed.connect(_on_settings_pressed)
	$VBoxContainer/TutorialBtn.pressed.connect(_on_tutorial_pressed)

	settings_node = settings_scene.instantiate()
	add_child(settings_node)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/CharacterSelect/character_select.tscn")

func _on_settings_pressed():
	settings_node.open("menu")

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes/Tutorial/tutorial.tscn")
