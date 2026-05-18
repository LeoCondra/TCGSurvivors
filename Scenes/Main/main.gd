extends Node2D

const PLAYER_SCENE  = preload("res://Scenes/Player/player.tscn")
const ENEMY_NORMAL  = preload("res://Scenes/Enemy/EnemyTypes/enemy_normal.tscn")
const ENEMY_RUNNER  = preload("res://Scenes/Enemy/EnemyTypes/enemy_runner.tscn")
const ENEMY_BRUTE   = preload("res://Scenes/Enemy/EnemyTypes/enemy_brute.tscn")
const ENEMY_JUMPER  = preload("res://Scenes/Enemy/EnemyTypes/enemy_jumper.tscn")
const ENEMY_SPECIAL = preload("res://Scenes/Enemy/EnemyTypes/enemy_special.tscn")

const SPAWN_DISTANCE = 600

var player: Node = null
var spawn_timer := 0.0
var spawn_interval := 3.0
var time_elapsed := 0.0

var normal_spawn_counter := 0
var special_timer := 0.0

func _ready():
	player = PLAYER_SCENE.instantiate()
	player.global_position = Vector2(0, 0)
	add_child(player)
	RenderingServer.set_default_clear_color(Color(0.15, 0.15, 0.15))

func _process(delta):
	time_elapsed += delta
	special_timer += delta

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
