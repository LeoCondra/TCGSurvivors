extends Enemy

func _ready():
	hp = 2
	xp_value = 1
	speed = 60.0
	color = Color(1.0, 0.2, 0.2)
	radius = 20.0
	super._ready()
