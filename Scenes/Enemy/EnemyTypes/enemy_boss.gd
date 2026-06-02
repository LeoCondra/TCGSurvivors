extends Enemy

class_name BossMOD

signal hp_changed(current_hp)

const JUMP_SPEED = 600.0
const JUMP_DISTANCE = 500.0
const WAIT_TIME = 3.0
const WARN_TIME = 1.0

var state := "walking"
var state_timer := 0.0
var jump_direction := Vector2.ZERO

func _ready():
	base_hp = 100
	xp_value = 50
	speed = 65.0
	color = Color(0.8, 0.0, 0.0)
	radius = 45.0
	super._ready()
	state_timer = WAIT_TIME

func _behavior(delta):
	match state:
		"walking":
			if player:
				var direction = (player.global_position - global_position).normalized()
				velocity = direction * speed
				move_and_slide()
			state_timer -= delta
			if state_timer <= 0.0:
				state = "warning"
				state_timer = WARN_TIME
				velocity = Vector2.ZERO

		"warning":
			velocity = Vector2.ZERO
			modulate = Color(1, 1, 1, 1) + Color(1, 1, 0, 0) * abs(sin(state_timer * 20.0))
			state_timer -= delta
			if state_timer <= 0.0:
				state = "jumping"
				if player:
					jump_direction = (player.global_position - global_position).normalized()
				state_timer = JUMP_DISTANCE / JUMP_SPEED

		"jumping":
			velocity = jump_direction * JUMP_SPEED
			move_and_slide()
			modulate = Color(1, 1, 1, 1)
			state_timer -= delta
			if state_timer <= 0.0:
				state = "walking"
				state_timer = WAIT_TIME

func take_damage(amount: int, knockback_dir: Vector2 = Vector2.ZERO):
	hp -= amount
	_flash()
	if knockback_dir != Vector2.ZERO:
		knockback_velocity = knockback_dir * KNOCKBACK_FORCE * 0.3
	hp_changed.emit(hp)
	if hp <= 0:
		die()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
	var crown_points = [
		Vector2(-20, -radius - 5),
		Vector2(-20, -radius - 20),
		Vector2(-8, -radius - 10),
		Vector2(0, -radius - 25),
		Vector2(8, -radius - 10),
		Vector2(20, -radius - 20),
		Vector2(20, -radius - 5),
	]
	draw_polyline(crown_points, Color(1.0, 0.8, 0.0), 3.0)
