extends Node2D

var slash_rate := 1.5
var slash_duration := 0.2
var slash_radius := 80.0
var slash_timer := 0.0
var slash_active := false
var slash_duration_timer := 0.0
var slash_direction := Vector2.RIGHT
var slash_area: Area2D = null
var player: Node = null

func _ready():
	slash_area = Area2D.new()
	var slash_col = CollisionShape2D.new()
	var slash_shape = CircleShape2D.new()
	slash_shape.radius = slash_radius
	slash_col.shape = slash_shape
	slash_area.add_child(slash_col)
	slash_area.body_entered.connect(_on_slash_hit)
	slash_area.collision_layer = 0
	slash_area.collision_mask = 4
	slash_area.monitoring = false
	add_child(slash_area)

func _process(delta):
	if player == null:
		return
	slash_direction = (player.get_global_mouse_position() - player.global_position).normalized()
	slash_timer -= delta
	if slash_timer <= 0.0:
		slash_timer = slash_rate
		_do_slash()
	if slash_active:
		slash_duration_timer -= delta
		if slash_duration_timer <= 0.0:
			_end_slash()
	queue_redraw()

func _do_slash():
	slash_active = true
	slash_duration_timer = slash_duration
	slash_area.global_position = player.global_position + slash_direction * (slash_radius * 0.7)
	slash_area.monitoring = true

func _end_slash():
	slash_active = false
	slash_area.monitoring = false

func _on_slash_hit(body):
	if body is Enemy:
		body.die()

func _draw():
	if slash_active:
		var slash_pos = slash_direction * (slash_radius * 0.7)
		draw_circle(slash_pos, slash_radius * 0.6, Color(1.0, 0.8, 0.2, 0.4))

func increase_slash_size():
	slash_radius += slash_radius * 0.3
	var col = slash_area.get_child(0)
	var shape = col.shape as CircleShape2D
	shape.radius = slash_radius

func increase_slash_rate():
	slash_rate = max(0.3, slash_rate * 0.75)
