extends Area2D

const MAX_DISTANCE = 300.0
const SPEED = 350.0

var direction := Vector2.RIGHT
var player: Node = null
var weapon: Node = null
var traveled := 0.0
var returning := false
var hit_enemies := []

func _ready():
	$AnimatedSprite2D.play("default")
	var shape = CircleShape2D.new()
	shape.radius = 10.0
	var col = CollisionShape2D.new()
	col.shape = shape
	add_child(col)
	collision_layer = 0
	collision_mask = 4
	body_entered.connect(_on_body_entered)
	queue_redraw()

func _process(delta):
	if player == null:
		return

	if not returning:
		position += direction * SPEED * delta
		traveled += SPEED * delta
		if traveled >= MAX_DISTANCE:
			returning = true
			hit_enemies.clear()
	else:
		var to_player = player.global_position - global_position
		if to_player.length() < 20.0:
			if weapon:
				weapon.on_boomerang_returned()
			queue_free()
			return
		position += to_player.normalized() * SPEED * delta

func _on_body_entered(body):
	if body is Enemy and body not in hit_enemies:
		body.take_damage(1, direction)
		hit_enemies.append(body)
