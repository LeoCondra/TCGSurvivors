extends CharacterBody2D

class_name Enemy

signal died

const XP_SCENE = preload("res://Scenes/XPOrb/xp_orb.tscn")

var player: Node = null
var hp := 2
var xp_value := 1
var speed := 60.0
var color := Color(1.0, 0.2, 0.2)
var radius := 20.0

var flash_timer := 0.0
const FLASH_DURATION = 0.1

var knockback_velocity := Vector2.ZERO
const KNOCKBACK_FORCE = 300.0
const KNOCKBACK_DECAY = 800.0

func _ready():
	add_to_group("enemies")
	collision_layer = 4
	collision_mask = 1
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	wall_min_slide_angle = 0.0

	var shape = CircleShape2D.new()
	shape.radius = radius
	var col = CollisionShape2D.new()
	col.shape = shape
	add_child(col)

	queue_redraw()

func _process(delta):
	if player == null:
		return

	if flash_timer > 0.0:
		flash_timer -= delta
		if flash_timer <= 0.0:
			modulate = Color(1, 1, 1, 1)

	_behavior(delta)

func _behavior(delta):
	if knockback_velocity.length() > 0:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_DECAY * delta)
		velocity = knockback_velocity
	else:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	move_and_slide()

func take_damage(amount: int, knockback_dir: Vector2 = Vector2.ZERO):
	hp -= amount
	_flash()
	if knockback_dir != Vector2.ZERO:
		knockback_velocity = knockback_dir * KNOCKBACK_FORCE
	if hp <= 0:
		die()

func _flash():
	modulate = Color(10, 10, 10, 1)
	flash_timer = FLASH_DURATION

func apply_knockback(from_position: Vector2):
	var dir = (global_position - from_position).normalized()
	knockback_velocity = dir * KNOCKBACK_FORCE

func die():
	died.emit()
	var orb = XP_SCENE.instantiate()
	orb.global_position = global_position
	orb.xp_value = xp_value
	var players = get_tree().get_nodes_in_group("players")
	if not players.is_empty():
		orb.pull_radius = players[0].xp_pull_radius
	get_parent().add_child(orb)
	call_deferred("queue_free")

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
