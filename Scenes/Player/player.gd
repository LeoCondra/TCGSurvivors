extends CharacterBody2D

class_name Player

var base_speed := 200.0
var speed_multiplier := 1.0

var hp := 5
var max_hp := 5
@onready var health_fill = $Healthbar/Fill
var invincible := false
var invincible_timer := 0.0
const INVINCIBLE_DURATION = 1.0

var xp := 0
var level := 1
var xp_to_next_level := 10
var weapon: Node = null
var extra_weapon: Node = null
var has_extra_weapon := false

var regen_level := 0
var regen_timer := 0.0
const REGEN_INTERVALS = [10.0, 7.0, 5.0]

var lightning_active := false
var lightning_timer := 0.0
var lightning_visual_timer := 0.0
var lightning_target_pos := Vector2.ZERO
const LIGHTNING_INTERVAL = 3.0
const LIGHTNING_RANGE = 400.0
const LIGHTNING_VISUAL_DURATION = 0.15

var knockback_on_hit := false
var xp_pull_radius := 0.0
var pulse_node: Node = null
var pause_node: Node = null

signal xp_collected

var level_up_scene = preload("res://Scenes/LevelUpScreen/level_up_screen.tscn")
var level_up_screen: Node = null

var hud_scene = preload("res://Scenes/HUD/hud.tscn")
var hud: Node = null

func _ready():
	$AnimatedSprite2D.play("Idle")
	add_to_group("players")

	var shape = CircleShape2D.new()
	shape.radius = 20.0
	var col = CollisionShape2D.new()
	col.shape = shape
	add_child(col)

	update_health_bar()
	_load_weapon()
	pulse_node = Node2D.new()
	pulse_node.set_script(load("res://Scenes/Player/pulse.gd"))
	pulse_node.player = self
	add_child(pulse_node)

	level_up_screen = level_up_scene.instantiate()
	add_child(level_up_screen)
	level_up_screen.hide()
	level_up_screen.option_chosen.connect(_on_power_up_chosen)

	hud = hud_scene.instantiate()
	add_child(hud)

	var hitbox = Area2D.new()
	var hitbox_col = CollisionShape2D.new()
	var hitbox_shape = CircleShape2D.new()
	hitbox_shape.radius = 20.1
	hitbox_col.shape = hitbox_shape
	hitbox.add_child(hitbox_col)
	hitbox.body_entered.connect(_on_hit)
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	add_child(hitbox)

	var pause_scene = preload("res://Scenes/Pause/pause.tscn")
	pause_node = pause_scene.instantiate()
	add_child(pause_node)

func update_health_bar():
	var hp_ratio = float(hp) / float(max_hp)
	health_fill.scale.x = hp_ratio

func _load_weapon():
	var weapon_scene
	match GameData.player_class:
		"warrior":
			weapon_scene = load("res://Scenes/Player/Weapons/warrior.tscn")
		"aoe":
			weapon_scene = load("res://Scenes/Player/Weapons/aoe.tscn")
		"boomerang":
			weapon_scene = load("res://Scenes/Player/Weapons/boomerang_weapon.tscn")
		_:
			weapon_scene = load("res://Scenes/Player/Weapons/shooter.tscn")
	weapon = weapon_scene.instantiate()
	weapon.player = self
	add_child(weapon)

func _draw():
	draw_circle(Vector2.ZERO, 20.0, Color(0.302, 0.6, 1.0, 0.0))
	if lightning_visual_timer > 0.0:
		draw_line(Vector2.ZERO, lightning_target_pos, Color(0.8, 0.8, 1.0, lightning_visual_timer / LIGHTNING_VISUAL_DURATION), 2.0)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_pause()

	if Input.is_action_just_pressed("dev_levelup"):
		_level_up()

	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_vector.normalized() * (base_speed * speed_multiplier)
	move_and_slide()
	
	_update_animation(move_vector)
	
	if invincible:
		invincible_timer -= delta
		var flash = sin(invincible_timer * 30.0) > 0.0
		modulate = Color(10, 10, 10, 1) if flash else Color(1, 1, 1, 1)
		if invincible_timer <= 0.0:
			invincible = false
			modulate = Color(1, 1, 1, 1)

	if regen_level > 0:
		regen_timer -= delta
		if regen_timer <= 0.0:
			regen_timer = REGEN_INTERVALS[regen_level - 1]
			hp = min(hp + 1, max_hp)
			update_health_bar()

	if lightning_active:
		lightning_timer -= delta
		if lightning_timer <= 0.0:
			lightning_timer = LIGHTNING_INTERVAL
			_strike_lightning()

	if lightning_visual_timer > 0.0:
		lightning_visual_timer -= delta

	queue_redraw()
	var elapsed = get_parent().time_elapsed if "time_elapsed" in get_parent() else 0.0
	hud.update(hp, xp, xp_to_next_level, level, elapsed)
	
	
func _update_animation(move_vector: Vector2):
	if move_vector == Vector2.ZERO:
		$AnimatedSprite2D.play("Idle")
	else:
		$AnimatedSprite2D.play("Walk")

func _toggle_pause():
	if get_tree().paused and not pause_node.visible:
		return
	if pause_node.visible:
		get_tree().paused = false
		pause_node.hide()
	else:
		get_tree().paused = true
		pause_node.show()

func _on_hit(body):
	if body is Enemy and not invincible:
		var damage = 2 if body is BossMOD else 1
		hp -= damage
		update_health_bar()
		invincible = true
		invincible_timer = INVINCIBLE_DURATION
		if knockback_on_hit:
			body.apply_knockback(global_position)
		queue_redraw()
		if hp <= 0:
			_die()

func _die():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")

func _level_up_from_special():
	level_up_screen.show_options(GameData.player_class)

func collect_xp(amount: int):
	xp += amount
	xp_collected.emit()
	if xp >= xp_to_next_level:
		_level_up()

func _level_up():
	level += 1
	xp = 0
	xp_to_next_level = int(xp_to_next_level * 1.5)
	level_up_screen.show_options(GameData.player_class)

func set_xp_pull(radius: float):
	xp_pull_radius = radius
	for orb in get_tree().get_nodes_in_group("xp_orbs"):
		orb.pull_radius = radius

func _strike_lightning():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearby = enemies.filter(func(e):
		return e.global_position.distance_to(global_position) <= LIGHTNING_RANGE
	)
	if nearby.is_empty():
		return
	nearby.shuffle()
	var target = nearby[0]
	target.take_damage(5)
	target._flash()
	lightning_target_pos = target.global_position - global_position
	lightning_visual_timer = LIGHTNING_VISUAL_DURATION
	queue_redraw()

func _add_extra_weapon():
	if has_extra_weapon:
		return
	has_extra_weapon = true
	var options = []
	if GameData.player_class != "shooter":
		options.append("res://Scenes/Player/Weapons/shooter.tscn")
	if GameData.player_class != "warrior":
		options.append("res://Scenes/Player/Weapons/warrior.tscn")
	if GameData.player_class != "aoe":
		options.append("res://Scenes/Player/Weapons/aoe.tscn")
	if GameData.player_class != "boomerang":
		options.append("res://Scenes/Player/Weapons/boomerang_weapon.tscn")
	options.shuffle()
	extra_weapon = load(options[0]).instantiate()
	extra_weapon.player = self
	add_child(extra_weapon)

func _on_power_up_chosen(power_up: Dictionary):
	match power_up["id"]:
		"speed":
			speed_multiplier = min(speed_multiplier + 0.2, 2.0)
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
		"multi_shot":
			if weapon.has_method("enable_multi_shot"):
				weapon.enable_multi_shot()
		"double_slash":
			if weapon.has_method("enable_double_slash"):
				weapon.enable_double_slash()
		"pulse":
			if pulse_node:
				pulse_node.activate()
		"pulse_size":
			if pulse_node:
				pulse_node.pulse_radius += pulse_node.pulse_radius * 0.3
		"xp_pull_1":
			set_xp_pull(100.0)
		"xp_pull_2":
			set_xp_pull(200.0)
		"xp_pull_3":
			set_xp_pull(350.0)
		"regen_1":
			regen_level = 1
			regen_timer = 10.0
		"regen_2":
			regen_level = 2
			regen_timer = 7.0
		"regen_3":
			regen_level = 3
			regen_timer = 5.0
		"lightning":
			lightning_active = true
			lightning_timer = LIGHTNING_INTERVAL
		"knockback":
			knockback_on_hit = true
		"extra_weapon":
			_add_extra_weapon()
		"extra_boomerang":
			if weapon.has_method("add_boomerang"):
				weapon.add_boomerang()
		"aoe_absorb_xp":
			if weapon.has_method("enable_xp_absorb"):
				weapon.enable_xp_absorb()
		"aoe_radius":
			if weapon.has_method("increase_radius"):
				weapon.increase_radius()
		"aoe_lifetime":
			if weapon.has_method("increase_lifetime"):
				weapon.increase_lifetime()
