extends Node2D

const BULLET_SCENE = preload("res://Scenes/Bullet/bullet.tscn")

var fire_rate := 0.25
var bullet_scale := 1.0
var fire_timer := 0.0
var player: Node = null


func _process(delta):
	fire_timer -= delta
	if fire_timer <= 0.0:
		fire_timer = fire_rate
		_shoot()

func _shoot():
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position = player.global_position
	bullet.direction = (player.get_global_mouse_position() - player.global_position).normalized()
	bullet.scale = Vector2(bullet_scale, bullet_scale)
	get_tree().current_scene.add_child(bullet)

func increase_fire_rate():
	fire_rate = max(0.05, fire_rate * 0.75)

func increase_bullet_size():
	bullet_scale += 0.5
