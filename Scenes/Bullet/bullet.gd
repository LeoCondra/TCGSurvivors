extends Area2D

const SPEED = 500.0

var direction := Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	collision_layer = 0
	collision_mask = 4
	queue_redraw()

func _process(delta):
	position += direction * SPEED * delta
	if position.distance_to(Vector2.ZERO) > 20000:
		queue_free()

func _on_body_entered(body):
	if body is Enemy:
		body.take_damage(1, direction)
		call_deferred("queue_free")

func _draw():
	draw_circle(Vector2.ZERO, 5.0, Color(1.0, 1.0, 0.2))
