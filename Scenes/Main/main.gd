extends Node2D

const PLAYER_SCENE  = preload("res://Scenes/Player/player.tscn")
const ENEMY_NORMAL  = preload("res://Scenes/Enemy/EnemyTypes/enemy_normal.tscn")
const ENEMY_RUNNER  = preload("res://Scenes/Enemy/EnemyTypes/enemy_runner.tscn")
const ENEMY_BRUTE   = preload("res://Scenes/Enemy/EnemyTypes/enemy_brute.tscn")
const ENEMY_JUMPER  = preload("res://Scenes/Enemy/EnemyTypes/enemy_jumper.tscn")
const ENEMY_SPECIAL = preload("res://Scenes/Enemy/EnemyTypes/enemy_special.tscn")
const ENEMY_BOSS    = preload("res://Scenes/Enemy/EnemyTypes/enemy_boss.tscn")

const SPAWN_DISTANCE = 600

var player: Node = null
var spawn_timer := 0.0
var spawn_interval := 3.0
var time_elapsed := 0.0

var normal_spawn_counter := 0
var special_timer := 0.0
var boss_spawned := false

func _ready():
	player = PLAYER_SCENE.instantiate()
	player.global_position = Vector2(0, 0)
	add_child(player)
	RenderingServer.set_default_clear_color(Color(0.15, 0.15, 0.15))

func _process(delta):
	time_elapsed += delta
	special_timer += delta

	# boss após 10 minutos
	if not boss_spawned and time_elapsed >= 600.0:
		boss_spawned = true
		_spawn_boss()

	if special_timer >= 180.0:
		special_timer = 0.0
		_spawn_enemy(ENEMY_SPECIAL)

	spawn_interval = max(0.5, 3.0 - (time_elapsed / 60.0) * 1.5)
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		spawn_timer = spawn_interval
		_decide_spawn()

func _decide_spawn():
	normal_spawn_counter += 1
	if normal_spawn_counter >= 5:
		normal_spawn_counter = 0
		var substitute = _roll_substitute()
		if substitute != null:
			_spawn_enemy(substitute)
			return
	_spawn_enemy(ENEMY_NORMAL)

func _roll_substitute():
	var candidates = []
	if time_elapsed >= 30.0:
		candidates.append({"scene": ENEMY_RUNNER, "chance": 0.25})
	if time_elapsed >= 60.0:
		candidates.append({"scene": ENEMY_BRUTE, "chance": 0.15})
	if time_elapsed >= 120.0:
		candidates.append({"scene": ENEMY_JUMPER, "chance": 0.20})
	if candidates.is_empty():
		return null
	candidates.shuffle()
	for c in candidates:
		if randf() <= c["chance"]:
			return c["scene"]
	return null

func _spawn_enemy(scene):
	if player == null:
		return
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * SPAWN_DISTANCE
	var enemy = scene.instantiate()
	enemy.global_position = player.global_position + offset
	enemy.player = player
	add_child(enemy)

func _spawn_boss():
	if player == null:
		return
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * SPAWN_DISTANCE
	var boss = ENEMY_BOSS.instantiate()
	boss.global_position = player.global_position + offset
	boss.player = player
	boss.hp_changed.connect(_on_boss_hp_changed)
	boss.died.connect(_on_boss_died)
	add_child(boss)
	player.hud.show_boss("Scalper Discord MOD", 100)

func _on_boss_hp_changed(hp: int):
	player.hud.update_boss_hp(hp)

func _on_boss_died():
	player.hud.update_boss_hp(0)
	_show_victory()

func _show_victory():
	get_tree().paused = true
	var canvas = CanvasLayer.new()
	canvas.process_mode = Node.PROCESS_MODE_ALWAYS

	var control = Control.new()
	control.set_anchors_preset(Control.PRESET_FULL_RECT)

	var bg = ColorRect.new()
	bg.color = Color(0, 0, 0, 0.8)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)

	var label = Label.new()
	label.text = "Parabéns!\nVocê é o TCG Survivors!"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 32)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)

	var btn = Button.new()
	btn.text = "Voltar ao Menu"
	btn.size = Vector2(200, 50)
	btn.set_anchors_preset(Control.PRESET_CENTER)
	btn.position = Vector2(-100, 60)
	btn.pressed.connect(func():
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
	)

	control.add_child(bg)
	control.add_child(label)
	control.add_child(btn)
	canvas.add_child(control)
	add_child(canvas)
