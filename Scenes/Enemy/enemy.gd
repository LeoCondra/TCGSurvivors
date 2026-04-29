extends CharacterBody2D

class_name Enemy

const SPEED = 60.0
const XP_SCENE = preload("res://Scenes/XPOrb/xp_orb.tscn")

var player: Node = null

func _ready():
	collision_layer = 4
	collision_mask = 0

func _process(delta):
	if player == null:
		return
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * SPEED
	move_and_slide()

func _draw():
	draw_circle(Vector2.ZERO, 20.0, Color(1.0, 0.2, 0.2))

func die():
	var orb = XP_SCENE.instantiate()
	orb.global_position = global_position
	get_parent().add_child(orb)
	queue_free()
