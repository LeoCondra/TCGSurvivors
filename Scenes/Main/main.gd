extends Node2D

const ENEMY_SCENE = preload("res://Scenes/Enemy/enemy.tscn")
const PLAYER_SCENE = preload("res://Scenes/Player/player.tscn")
const WORLD_SIZE = 10000.0
const SPAWN_DISTANCE = 600.0

var player: Node = null
var spawn_timer := 0.0
var spawn_interval := 1.5
var time_elapsed := 0.0

func _ready():
	player = PLAYER_SCENE.instantiate()
	player.global_position = Vector2(WORLD_SIZE / 2, WORLD_SIZE / 2)
	add_child(player)
	RenderingServer.set_default_clear_color(Color(0.15, 0.15, 0.15))

func _process(delta):
	time_elapsed += delta
	spawn_interval = max(0.3, 1.5 - (time_elapsed / 30.0) * 0.5)
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		spawn_timer = spawn_interval
		_spawn_enemy()

func _spawn_enemy():
	if player == null:
		return
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * SPAWN_DISTANCE
	var enemy = ENEMY_SCENE.instantiate()
	enemy.global_position = player.global_position + offset
	enemy.player = player
	add_child(enemy)
