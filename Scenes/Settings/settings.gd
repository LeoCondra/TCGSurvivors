extends CanvasLayer

var came_from := "menu"

func _ready():
	$Control/BackBtn.pressed.connect(_on_back_pressed)
	$Control/FullscreenBtn.pressed.connect(_on_fullscreen_pressed)
	_update_fullscreen_btn()
	hide()

func open(from: String):
	came_from = from
	_update_fullscreen_btn()
	show()
	if came_from == "pause":
		get_tree().paused = true

func _update_fullscreen_btn():
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	$Control/FullscreenBtn.text = "Tela Cheia: ON" if is_fullscreen else "Tela Cheia: OFF"

func _on_fullscreen_pressed():
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_update_fullscreen_btn()

func _on_back_pressed():
	hide()
	if came_from == "menu":
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
	else:
		get_tree().paused = true
		emit_signal("closed")

signal closed
