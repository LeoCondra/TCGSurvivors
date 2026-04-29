extends Control

func _ready():
	$ShooterBtn.pressed.connect(_on_shooter_pressed)
	$WarriorBtn.pressed.connect(_on_warrior_pressed)

func _on_shooter_pressed():
	GameData.player_class = "shooter"
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func _on_warrior_pressed():
	GameData.player_class = "warrior"
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
