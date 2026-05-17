extends Node2D

var slash_rate := 1.5
var slash_duration := 0.2
var slash_width := 40.0
var slash_height := 50.0
var slash_timer := 0.0
var slash_active := false
var slash_duration_timer := 0.0
var slash_direction := Vector2.RIGHT
var slash_area: Area2D = null
var slash_col: CollisionShape2D = null
var player: Node = null

func _ready():
	slash_area = Area2D.new()
	slash_col = CollisionShape2D.new()
	var slash_shape = RectangleShape2D.new()
	slash_shape.size = Vector2(slash_width, slash_height)
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
	# posiciona o retangulo na frente do player na direção da mira
	var dist = 30.0 + slash_height / 2.0
	slash_area.global_position = player.global_position + slash_direction * dist
	# rotaciona o retangulo para apontar na direção da mira
	slash_area.rotation = slash_direction.angle()
	slash_area.monitoring = true

func _end_slash():
	slash_active = false
	slash_area.monitoring = false

func _on_slash_hit(body):
	if body is Enemy:
		body.take_damage(1)

func _draw():
	if not slash_active:
		return
	# desenha o retangulo visual na mesma posição e rotação da hitbox
	var dist = 30.0 + slash_height / 2.0
	var slash_pos = slash_direction * dist
	var angle = slash_direction.angle()

	# salva e aplica rotação para desenhar o retangulo orientado
	draw_set_transform(slash_pos, angle)
	draw_rect(
		Rect2(-slash_width / 2.0, -slash_height / 2.0, slash_width, slash_height),
		Color(1.0, 0.8, 0.2, 0.5)
	)
	draw_set_transform(Vector2.ZERO, 0.0)

func increase_slash_size():
	slash_width += slash_width * 0.2
	slash_height += slash_height * 0.2
	var shape = slash_col.shape as RectangleShape2D
	shape.size = Vector2(slash_width, slash_height)

func increase_slash_rate():
	slash_rate = max(0.3, slash_rate * 0.75)
