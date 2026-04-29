extends CharacterBody2D

class_name Player

var base_speed := 200.0
var speed_multiplier := 1.0

var hp := 5
var max_hp := 5
var invincible := false
var invincible_timer := 0.0
const INVINCIBLE_DURATION = 1.0  # segundos de invencibilidade após tomar dano

var xp := 0
var level := 1
var xp_to_next_level := 10
var weapon: Node = null

var level_up_scene = preload("res://Scenes/LevelUpScreen/level_up_screen.tscn")
var level_up_screen: Node = null

var hud_scene = preload("res://Scenes/HUD/hud.tscn")
var hud: Node = null

func _ready():
	var shape = CircleShape2D.new()
	shape.radius = 20.0
	var col = CollisionShape2D.new()
	col.shape = shape
	add_child(col)

	_load_weapon()

	level_up_screen = level_up_scene.instantiate()
	add_child(level_up_screen)
	level_up_screen.hide()
	level_up_screen.option_chosen.connect(_on_power_up_chosen)

	hud = hud_scene.instantiate()
	add_child(hud)

	# detecta inimigos tocando no player
	var hitbox = Area2D.new()
	var hitbox_col = CollisionShape2D.new()
	var hitbox_shape = CircleShape2D.new()
	hitbox_shape.radius = 18.0
	hitbox_col.shape = hitbox_shape
	hitbox.add_child(hitbox_col)
	hitbox.body_entered.connect(_on_hit)
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	add_child(hitbox)

func _load_weapon():
	var weapon_scene
	if GameData.player_class == "warrior":
		weapon_scene = load("res://Scenes/Player/Weapons/warrior.tscn")
	else:
		weapon_scene = load("res://Scenes/Player/Weapons/shooter.tscn")
	weapon = weapon_scene.instantiate()
	weapon.player = self
	add_child(weapon)

func _draw():
	draw_circle(Vector2.ZERO, 20.0, Color(0.3, 0.6, 1.0))
	# barra de HP embaixo do player
	var bar_width := 40.0
	var bar_height := 5.0
	var bar_x := -bar_width / 2
	var bar_y := 28.0
	# fundo vermelho
	draw_rect(Rect2(bar_x, bar_y, bar_width, bar_height), Color(0.6, 0.1, 0.1))
	# frente verde proporcional ao HP
	var hp_ratio := float(hp) / float(max_hp)
	draw_rect(Rect2(bar_x, bar_y, bar_width * hp_ratio, bar_height), Color(0.2, 0.9, 0.2))

func _process(delta):
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_vector.normalized() * (base_speed * speed_multiplier)
	move_and_slide()

	if invincible:
		invincible_timer -= delta
		if invincible_timer <= 0.0:
			invincible = false

	queue_redraw()
	hud.update(hp, xp, xp_to_next_level, level, get_parent().time_elapsed if get_parent().has_method("_spawn_enemy") else 0.0)

func _on_hit(body):
	if body is Enemy and not invincible:
		hp -= 1
		invincible = true
		invincible_timer = INVINCIBLE_DURATION
		if hp <= 0:
			_die()

func _die():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")

func collect_xp(amount: int):
	xp += amount
	if xp >= xp_to_next_level:
		_level_up()

func _level_up():
	level += 1
	xp = 0
	xp_to_next_level = int(xp_to_next_level * 1.5)
	level_up_screen.show_options(GameData.player_class)

func _on_power_up_chosen(power_up: Dictionary):
	match power_up["id"]:
		"speed":
			speed_multiplier += 0.2
		"fire_rate":
			if weapon.has_method("increase_fire_rate"):
				weapon.increase_fire_rate()
		"bullet_size":
			if weapon.has_method("increase_bullet_size"):
				weapon.increase_bullet_size()
		"slash_size":
			if weapon.has_method("increase_slash_size"):
				weapon.increase_slash_size()
		"slash_rate":
			if weapon.has_method("increase_slash_rate"):
				weapon.increase_slash_rate()
