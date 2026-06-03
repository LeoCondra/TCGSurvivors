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
var double_slash := false
var back_slash_active := false
var back_slash_direction := Vector2.LEFT
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
	var dist = 30.0 + slash_height / 2.0
	slash_area.global_position = player.global_position + slash_direction * dist
	slash_area.rotation = slash_direction.angle()
	slash_area.monitoring = true

	if has_node("SlashSprite"):
		var sprite = $SlashSprite
		sprite.global_position = player.global_position + slash_direction * dist
		sprite.rotation = slash_direction.angle() - deg_to_rad(90)
		sprite.show()
		sprite.play("Slash")
		if not sprite.animation_finished.is_connected(_on_slash_animation_finished):
			sprite.animation_finished.connect(_on_slash_animation_finished, CONNECT_ONE_SHOT)

	if double_slash:
		back_slash_active = true
		back_slash_direction = -slash_direction
		_do_back_slash()

func _on_slash_animation_finished():
	if has_node("SlashSprite"):
		$SlashSprite.hide()

func _do_back_slash():
	back_slash_active = true
	back_slash_direction = -slash_direction
	var dist = 30.0 + slash_height / 2.0

	if has_node("SlashSpriteBack"):
		var sprite = $SlashSpriteBack
		sprite.global_position = player.global_position + back_slash_direction * dist
		sprite.rotation = back_slash_direction.angle() - deg_to_rad(90)
		sprite.show()
		sprite.play("Slash")
		if not sprite.animation_finished.is_connected(_on_back_slash_animation_finished):
			sprite.animation_finished.connect(_on_back_slash_animation_finished, CONNECT_ONE_SHOT)

	var back_area = Area2D.new()
	var col = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(slash_width, slash_height)
	col.shape = shape
	back_area.add_child(col)
	back_area.collision_layer = 0
	back_area.collision_mask = 4
	back_area.global_position = player.global_position + back_slash_direction * (30.0 + slash_height / 2.0)
	back_area.rotation = back_slash_direction.angle()
	get_tree().current_scene.add_child(back_area)
	back_area.body_entered.connect(func(body):
		if body is Enemy:
			body.take_damage(1, back_slash_direction)
	)
	await get_tree().create_timer(slash_duration).timeout
	back_slash_active = false
	if is_instance_valid(back_area):
		back_area.call_deferred("queue_free")

func _on_back_slash_animation_finished():
	if has_node("SlashSpriteBack"):
		$SlashSpriteBack.hide()

func _end_slash():
	slash_active = false
	slash_area.call_deferred("set", "monitoring", false)

func _on_slash_hit(body):
	if body is Enemy:
		body.take_damage(1, slash_direction)

func enable_double_slash():
	double_slash = true

func increase_slash_size():
	slash_width = min(slash_width + slash_width * 0.2, 40.0 * 3.0)
	slash_height = min(slash_height + slash_height * 0.2, 50.0 * 3.0)
	var shape = slash_col.shape as RectangleShape2D
	shape.size = Vector2(slash_width, slash_height)

func increase_slash_rate():
	slash_rate = max(slash_rate * 0.75, 0.375)
