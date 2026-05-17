extends Enemy

func _ready():
	hp = 1
	xp_value = 1
	speed = 140.0
	color = Color(1.0, 0.6, 0.1)
	radius = 14.0
	super._ready()
