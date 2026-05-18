extends Node2D

const PULSE_INTERVAL = 10.0
var pulse_radius := 80.0
var pulse_timer := PULSE_INTERVAL
var player: Node = null

var visual_radius := 0.0
var animating := false

func _ready():
	# começa desativado, ativado pelo upgrade
	set_process(false)

func activate():
	set_process(true)

func _process(delta):
	if player == null:
		return

	pulse_timer -= delta
	if pulse_timer <= 0.0:
		pulse_timer = PULSE_INTERVAL
		_do_pulse()

	if animating:
		visual_radius += 400.0 * delta
		if visual_radius >= pulse_radius:
			visual_radius = 0.0
			animating = false
		queue_redraw()

func _do_pulse():
	animating = true
	visual_radius = 0.0
	for body in get_tree().get_nodes_in_group("enemies"):
		if body.global_position.distance_to(player.global_position) <= pulse_radius:
			body.take_damage(1)

func _draw():
	if animating:
		draw_circle(Vector2.ZERO, visual_radius, Color(0.3, 0.8, 1.0, 0.25))
