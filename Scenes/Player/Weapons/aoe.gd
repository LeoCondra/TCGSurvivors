extends Node2D

const AOE_ZONE_SCENE = preload("res://Scenes/Player/Weapons/aoe_zone.tscn")

var cooldown := 4.0
var cooldown_timer := 0.0
var player: Node = null
var absorb_xp := false

var zone_radius := 60.0
var zone_lifetime := 4.0

func _process(delta):
	if player == null:
		return
	cooldown_timer -= delta
	if cooldown_timer <= 0.0:
		cooldown_timer = cooldown
		_place_zone()

	if absorb_xp:
		for orb in get_tree().get_nodes_in_group("xp_orbs"):
			if orb.global_position.distance_to(player.global_position) <= zone_radius:
				orb.pull_radius = zone_radius

func _place_zone():
	var zone = AOE_ZONE_SCENE.instantiate()
	zone.global_position = player.global_position
	zone.radius = zone_radius
	zone.lifetime = zone_lifetime
	get_tree().current_scene.add_child(zone)

func enable_xp_absorb():
	absorb_xp = true

func increase_radius():
	zone_radius = min(zone_radius + 20.0, 160.0)

func increase_lifetime():
	zone_lifetime = min(zone_lifetime + 1.5, 10.0)
