extends Area2D

var lifetime := 4.0
const TICK_RATE = 1.0
var radius := 60.0

var lifetime_timer := 0.0
var tick_timer := 0.0

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("default")
	update_visual_size()
	var shape = CircleShape2D.new()
	shape.radius = radius
	var col = CollisionShape2D.new()
	col.shape = shape
	add_child(col)
	collision_layer = 0
	collision_mask = 4
	queue_redraw()

func _process(delta):
	lifetime_timer += delta
	tick_timer += delta

	if tick_timer >= TICK_RATE:
		tick_timer = 0.0
		for body in get_overlapping_bodies():
			if body is Enemy:
				body.take_damage(1)

	if lifetime_timer >= lifetime:
		queue_free()

	modulate.a = 0.4 + 0.2 * sin(lifetime_timer * 5.0)
	queue_redraw()

func update_visual_size():
	var texture_size = sprite.sprite_frames.get_frame_texture("default", 0).get_size()

	var desired_diameter = radius * 2.0

	sprite.scale = Vector2.ONE * (desired_diameter / texture_size.x)

func _draw():
	draw_circle(Vector2.ZERO, radius, Color(0.8, 0.2, 1.0, 0.3))
	for i in range(32):
		var angle = (float(i) / 32.0) * TAU
		var next_angle = (float(i + 1) / 32.0) * TAU
		draw_line(
			Vector2(cos(angle), sin(angle)) * radius,
			Vector2(cos(next_angle), sin(next_angle)) * radius,
			Color(0.8, 0.2, 1.0, 0.8), 2.0
		)
