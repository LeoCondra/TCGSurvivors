extends "res://Scenes/Enemy/enemy.gd"

var pulse_timer := 0.0

func _ready():
	base_hp = 10
	xp_value = 0
	speed = 45.0
	color = Color(1.0, 0.9, 0.1)
	radius = 25.0
	super._ready()
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("Walk")

func _behavior(delta):
	pulse_timer += delta
	if not has_node("AnimatedSprite2D"):
		modulate.a = 0.7 + 0.3 * sin(pulse_timer * 4.0)
	if player:
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.flip_h = player.global_position.x < global_position.x
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	move_and_slide()

func die():
	if player != null and player.has_method("_level_up_from_special"):
		player._level_up_from_special()
	call_deferred("queue_free")
