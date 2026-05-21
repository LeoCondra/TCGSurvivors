extends Control
var shooter = load("res://Sprites/1.png")
var warrior = load("res://Sprites/3.png")
var aeo = load("res://Sprites/2.png")
var boomerang = load("res://Sprites/4.png")

func _ready():
	$HBoxContainer/VBoxContainer/ShooterBtn.pressed.connect(_on_shooter_pressed)
	$HBoxContainer/VBoxContainer2/WarriorBtn.pressed.connect(_on_warrior_pressed)
	$HBoxContainer/VBoxContainer/AOEBtn.pressed.connect(_on_aoe_pressed)
	$HBoxContainer/VBoxContainer2/BoomerangBtn.pressed.connect(_on_boomerang_pressed)

func _on_shooter_pressed():
	GameData.player_class = "shooter"
	Input.set_custom_mouse_cursor(shooter)
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func _on_warrior_pressed():
	GameData.player_class = "warrior"
	Input.set_custom_mouse_cursor(warrior)
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func _on_aoe_pressed():
	GameData.player_class = "aoe"
	Input.set_custom_mouse_cursor(aeo)
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func _on_boomerang_pressed():
	GameData.player_class = "boomerang"
	Input.set_custom_mouse_cursor(boomerang)
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
