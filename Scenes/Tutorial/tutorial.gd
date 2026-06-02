extends Node2D
const EnemyScript = preload("res://Scenes/Enemy/enemy.gd")

const ENEMY_SCENE = preload("res://Scenes/Enemy/EnemyTypes/enemy_normal.tscn")
const SPAWN_DISTANCE = 400.0

var player: Node = null
var step := 0
var final_kills := 0
var player_moved := false
var move_timer := 0.0
const MOVE_WAIT := 4.0

var steps = [
	"Use WASD para se mover.\n\nExplore o campo livremente.",
	"Muito bem!\n\nAgora mire com o mouse.\nVocê atira automaticamente na direção do cursor.\n\nMate o inimigo que vai aparecer!",
	"Mire com o mouse.\nVocê atira automaticamente na direção do cursor.\n\nMate o inimigo que apareceu!",
	"Colete o XP que o inimigo deixou.\n\nPasse por cima do orbe verde.",
	"Você subiu de nível!\nEscolha um upgrade para continuar.",
	"Ótimo! Agora mate mais 3 inimigos.",
	"Parabéns! Você está pronto para jogar!\n\nBoa sorte!",
]

func _ready():
	GameData.player_class = "shooter"
	var player_scene = preload("res://Scenes/Player/player.tscn")
	player = player_scene.instantiate()
	player.global_position = Vector2(0, 0)
	add_child(player)

	player.xp_collected.connect(_on_xp_collected)
	player.level_up_screen.option_chosen.connect(_on_level_up_chosen)

	RenderingServer.set_default_clear_color(Color(0.15, 0.15, 0.15))

	$TutorialUI/Control/ContinuteBtn.pressed.connect(_on_continue_pressed)
	_show_step(0)

func _show_step(index: int):
	step = index
	$TutorialUI/Control/Label.text = steps[index]
	$TutorialUI/Control/ColorRect.show()
	$TutorialUI/Control/Label.show()
	$TutorialUI/Control/ContinuteBtn.show()
	get_tree().paused = true

func _hide_ui():
	$TutorialUI/Control/ColorRect.hide()
	$TutorialUI/Control/Label.hide()
	$TutorialUI/Control/ContinuteBtn.hide()
	get_tree().paused = false

func _on_continue_pressed():
	_hide_ui()
	match step:
		0:
			player_moved = false
			move_timer = 0.0
		1:
			# após "muito bem", spawna o inimigo
			step = 2
			_spawn_enemy()
			return
		4:
			pass
		6:
			get_tree().paused = false
			get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")

func _process(delta):
	if player == null or get_tree().paused:
		return

	if step == 0 and not player_moved:
		var moving = Input.get_vector("move_left", "move_right", "move_up", "move_down").length() > 0.1
		if moving:
			player_moved = true
			move_timer = 0.0

	if step == 0 and player_moved:
		move_timer += delta
		if move_timer >= MOVE_WAIT:
			_show_step(1)

func _spawn_enemy():
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * SPAWN_DISTANCE
	var enemy = ENEMY_SCENE.instantiate()
	enemy.global_position = player.global_position + offset
	enemy.player = player
	enemy.died.connect(_on_enemy_died)
	add_child(enemy)

func _on_enemy_died():
	match step:
		2:
			_show_step(3)
		5:
			final_kills += 1
			if final_kills >= 3:
				_show_step(6)
			else:
				_spawn_enemy()

func _on_xp_collected():
	if step == 3:
		step = 4
		player.xp = player.xp_to_next_level - 1
		player.collect_xp(1)

func _on_level_up_chosen(_power_up):
	_show_step(5)
	for i in range(3):
		_spawn_enemy()
