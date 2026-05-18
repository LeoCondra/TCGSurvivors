extends Control

func _ready():
	$ShooterBtn.pressed.connect(_on_shooter_pressed)
	$WarriorBtn.pressed.connect(_on_warrior_pressed)
	$AOEBtn.pressed.connect(_on_aoe_pressed)
	$BoomerangBtn.pressed.connect(_on_boomerang_pressed)

func _on_shooter_pressed():
	GameData.player_class = "shooter"
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func _on_warrior_pressed():
	GameData.player_class = "warrior"
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func _on_aoe_pressed():
	GameData.player_class = "aoe"
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func _on_boomerang_pressed():
	GameData.player_class = "boomerang"
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
