extends Enemy

const WAIT_TIME = 2.0
const JUMP_SPEED = 400.0
const JUMP_DURATION = 0.4

var state := "waiting"
var state_timer := 0.0
var jump_direction := Vector2.ZERO

func _ready():
	hp = 2
	xp_value = 2
	speed = 0.0
	color = Color(0.2, 0.8, 1.0)
	radius = 18.0
	super._ready()
	state_timer = WAIT_TIME

func _behavior(delta):
	match state:
		"waiting":
			velocity = Vector2.ZERO
			state_timer -= delta
			# pisca para avisar que vai pular
			modulate.a = 0.5 + 0.5 * sin(state_timer * 10.0)
			if state_timer <= 0.0:
				_start_jump()
		"jumping":
			velocity = jump_direction * JUMP_SPEED
			move_and_slide()
			state_timer -= delta
			if state_timer <= 0.0:
				state = "waiting"
				state_timer = WAIT_TIME
				modulate.a = 1.0

func _start_jump():
	if player == null:
		return
	state = "jumping"
	state_timer = JUMP_DURATION
	jump_direction = (player.global_position - global_position).normalized()
