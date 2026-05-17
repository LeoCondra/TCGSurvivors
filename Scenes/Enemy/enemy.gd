extends CharacterBody2D

class_name Enemy

const XP_SCENE = preload("res://Scenes/XPOrb/xp_orb.tscn")

var player: Node = null
var hp := 2
var xp_value := 1
var speed := 60.0
var color := Color(1.0, 0.2, 0.2)
var radius := 20.0

var flash_timer := 0.0
const FLASH_DURATION = 0.1

func _ready():
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
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func take_damage(amount: int):
	hp -= amount
	_flash()
	if hp <= 0:
		die()

func _flash():
	modulate = Color(10, 10, 10, 1)  # branco intenso
	flash_timer = FLASH_DURATION

func die():
	var orb = XP_SCENE.instantiate()
	orb.global_position = global_position
	orb.xp_value = xp_value
	get_parent().add_child(orb)
	queue_free()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
