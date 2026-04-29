extends CanvasLayer

signal option_chosen(power_up)

# power ups disponíveis para cada classe
const POWER_UPS = {
	"shooter": [
		{"id": "speed", "label": "Mais Velocidade\n+20% de movimento"},
		{"id": "fire_rate", "label": "Disparo Rápido\n+25% velocidade de tiro"},
		{"id": "bullet_size", "label": "Balas Maiores\n+50% tamanho das balas"},
	],
	"warrior": [
		{"id": "speed", "label": "Mais Velocidade\n+20% de movimento"},
		{"id": "slash_size", "label": "Corte Maior\n+30% alcance do corte"},
		{"id": "slash_rate", "label": "Corte Veloz\n+25% velocidade do corte"},
	]
}

var options := []

func _ready():
	$Opt1.pressed.connect(func(): _choose(0))
	$Opt2.pressed.connect(func(): _choose(1))
	$Opt3.pressed.connect(func(): _choose(2))

func show_options(player_class: String):
	var pool = POWER_UPS[player_class].duplicate()
	pool.shuffle()
	options = pool.slice(0, 3)
	
	$Opt1.text = options[0]["label"]
	$Opt2.text = options[1]["label"]
	$Opt3.text = options[2]["label"]
	
	get_tree().paused = true
	show()

func _choose(index: int):
	get_tree().paused = false
	hide()
	option_chosen.emit(options[index])
