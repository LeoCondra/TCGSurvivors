extends CanvasLayer

var settings_scene = preload("res://Scenes/Settings/settings.tscn")
var settings_node: Node = null

func _ready():
	$Control/ResumeBtn.pressed.connect(_on_resume_pressed)
	$Control/SettingsBtn.pressed.connect(_on_settings_pressed)
	$Control/MenuBtn.pressed.connect(_on_menu_pressed)
	hide()

	settings_node = settings_scene.instantiate()
	add_child(settings_node)

func _on_resume_pressed():
	get_tree().paused = false
	hide()

func _on_settings_pressed():
	$Control.hide()
	settings_node.open("pause")
	await settings_node.closed
	$Control.show()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
