extends Enemy

var pulse_timer := 0.0

func _ready():
	hp = 10
	xp_value = 0
	speed = 45.0
	color = Color(1.0, 0.9, 0.1)
	radius = 25.0
	super._ready()

func _behavior(delta):
	# brilho pulsante
	pulse_timer += delta
	modulate.a = 0.7 + 0.3 * sin(pulse_timer * 4.0)
	
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func die():
	# dropa upgrade em vez de XP
	if player != null and player.has_method("_level_up_from_special"):
		player._level_up_from_special()
	queue_free()
