extends Enemy

func _ready():
	base_hp = 5
	xp_value = 4
	speed = 35.0
	color = Color(0.6, 0.1, 0.8)
	radius = 35.0
	super._ready()
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("Walk")

func _behavior(delta):
	if player == null:
		return
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.flip_h = player.global_position.x < global_position.x
	if knockback_velocity.length() > 0:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_DECAY * delta)
		velocity = knockback_velocity
	else:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	move_and_slide()
