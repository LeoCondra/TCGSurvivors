extends CanvasLayer

var came_from := "menu"  # "menu" ou "pause"

func open(from: String):
	came_from = from
	show()
	get_tree().paused = true

func _ready():
	$Control/BackBtn.pressed.connect(_on_back_pressed)
	hide()

signal closed

func _on_back_pressed():
	get_tree().paused = false if came_from == "menu" else true
	hide()
	closed.emit()
	if came_from == "menu":
		get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
