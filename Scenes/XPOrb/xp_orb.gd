extends Area2D

var xp_value := 1

func _ready():
	body_entered.connect(_on_body_entered)
	collision_layer = 0
	collision_mask = 1
	queue_redraw()
func _on_body_entered(body):
	if body is Player:
		body.collect_xp(xp_value)
		queue_free()
