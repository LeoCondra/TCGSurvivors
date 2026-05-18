extends Node2D

const BOOMERANG_SCENE = preload("res://Scenes/Player/Weapons/boomerang.tscn")

var throw_rate := 1.5
var throw_timer := 0.0
var boomerang_count := 1
var active_boomerangs := 0
var player: Node = null

func _process(delta):
	if player == null:
		return
	throw_timer -= delta
	if throw_timer <= 0.0 and active_boomerangs < boomerang_count:
		throw_timer = throw_rate
		_throw()

func _throw():
	var b = BOOMERANG_SCENE.instantiate()
	b.global_position = player.global_position
	b.direction = (player.get_global_mouse_position() - player.global_position).normalized()
	b.player = player
	b.weapon = self
	get_tree().current_scene.add_child(b)
	active_boomerangs += 1

func on_boomerang_returned():
	active_boomerangs -= 1

func add_boomerang():
	boomerang_count += 1
