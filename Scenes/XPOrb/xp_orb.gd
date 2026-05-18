extends Area2D

var xp_value := 1
var pull_radius := 0.0

func _ready():
	add_to_group("xp_orbs")
	body_entered.connect(_on_body_entered)
	collision_layer = 0
	collision_mask = 1
	queue_redraw()

func _process(delta):
	if pull_radius > 0.0:
		var players = get_tree().get_nodes_in_group("players")
		if players.is_empty():
			return
		var p = players[0]
		if global_position.distance_to(p.global_position) <= pull_radius:
			global_position = global_position.move_toward(p.global_position, 200.0 * delta)

func _on_body_entered(body):
	if body is Player:
		body.collect_xp(xp_value)
		queue_free()

func _draw():
	draw_circle(Vector2.ZERO, 10.0, Color(0.2, 1.0, 0.4))
