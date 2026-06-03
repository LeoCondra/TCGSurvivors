extends CanvasLayer

signal option_chosen(power_up)

const POWER_UPS_SHARED = [
	{"id": "speed",        "label": "- Energético Monstruoso -\n\n+20% movimento",            "max": 5,  "weight": 10},
	{"id": "pulse",        "label": "- Aura -\n\nOnda de dano ao redor do player",     "max": 1,  "weight": 8},
	{"id": "pulse_size",   "label": "- Aura + Ego -\n\n+30% raio do pulso",            "max": 3,  "weight": 7},
	{"id": "xp_pull_1",   "label": "- Mão Pegajosa -\n\nRaio de 100px",              "max": 1,  "weight": 8},
	{"id": "xp_pull_2",   "label": "- Braço Extensor -\n\nRaio de 200px",             "max": 1,  "weight": 7},
	{"id": "xp_pull_3",   "label": "- Aspirador de pó -\n\nRaio de 350px",            "max": 1,  "weight": 6},
	{"id": "regen_1",      "label": "- Merthiolate -\n\n+1 HP a cada 10s",                  "max": 1,  "weight": 8},
	{"id": "regen_2",      "label": "- Band-Aid - \n\n+1 HP a cada 7s",                  "max": 1,  "weight": 7},
	{"id": "regen_3",      "label": "- Bezetacil -\n\n+1 HP a cada 5s",                 "max": 1,  "weight": 6},
	{"id": "lightning",    "label": "- Rage Bait -\n\nAtinge inimigo aleatório próximo",      "max": 1,  "weight": 5},
	{"id": "knockback",    "label": "- ... e te joooj -\n\nEmpurra inimigos ao receber dano", "max": 1,  "weight": 6},
	{"id": "extra_weapon", "label": "- 1 é bom, mas 2 é top -\n\nGanha uma arma aleatória",        "max": 1,  "weight": 1},
]

const POWER_UPS_SHOOTER = [
	{"id": "fire_rate",   "label": "- Pilhas de Marca -\n\n+25% velocidade de tiro",     "max": 4,  "weight": 8},
	{"id": "bullet_size", "label": "- Pack-a-Punch -\n\n+75% tamanho",                 "max": 4,  "weight": 7},
	{"id": "multi_shot",  "label": "- ... e 3 é #### -\n\n3 projéteis em leque",         "max": 1,  "weight": 3},
]

const POWER_UPS_WARRIOR = [
	{"id": "slash_size",   "label": "- Diálogo -\n\n+20% alcance",                  "max": 3,  "weight": 8},
	{"id": "slash_rate",   "label": "Button Mashing -\n\n+25% velocidade",               "max": 4,  "weight": 7},
	{"id": "double_slash", "label": "- Tudo que vai ... volta -\n\nAtaca frente e atrás",          "max": 1,  "weight": 3},
]

const POWER_UPS_AOE = [
	{"id": "aoe_absorb_xp", "label": "- imã de geladeira -\n\nÁrea absorve XP ao redor",    "max": 1,  "weight": 4},
	{"id": "aoe_radius",    "label": "-And now i become death... -\n\n+20px de raio",                 "max": 5,  "weight": 8},
	{"id": "aoe_lifetime",  "label": "- ... the deestroyer of worlds. -\n\n+1.5s de duração",          "max": 4,  "weight": 7},
]

const POWER_UPS_BOOMERANG = [
	{"id": "extra_boomerang", "label": "- Random ######## go!!! -\n\n+1 bumerangue",         "max": 3,  "weight": 6},
]

var picked := {}
var options := []
var player_class := "shooter"

func _ready():
	$HBoxContainer/Opt1.pressed.connect(func(): _choose(0))
	$HBoxContainer/Opt2.pressed.connect(func(): _choose(1))
	$HBoxContainer/Opt3.pressed.connect(func(): _choose(2))

func show_options(p_class: String):
	player_class = p_class
	var pool = _build_pool()
	pool.shuffle()
	options = pool.slice(0, min(3, pool.size()))

	$HBoxContainer/Opt1.text = options[0]["label"] if options.size() > 0 else ""
	$HBoxContainer/Opt2.text = options[1]["label"] if options.size() > 1 else ""
	$HBoxContainer/Opt3.text = options[2]["label"] if options.size() > 2 else ""

	get_tree().paused = true
	show()

func _build_pool() -> Array:
	var eligible = []
	var class_ups: Array
	match player_class:
		"warrior":
			class_ups = POWER_UPS_WARRIOR
		"aoe":
			class_ups = POWER_UPS_AOE
		"boomerang":
			class_ups = POWER_UPS_BOOMERANG
		_:
			class_ups = POWER_UPS_SHOOTER

	var all = POWER_UPS_SHARED + class_ups

	for up in all:
		var count = picked.get(up["id"], 0)
		if count >= up["max"]:
			continue
		if up["id"] == "regen_2" and picked.get("regen_1", 0) == 0:
			continue
		if up["id"] == "regen_3" and picked.get("regen_2", 0) == 0:
			continue
		if up["id"] == "xp_pull_2" and picked.get("xp_pull_1", 0) == 0:
			continue
		if up["id"] == "xp_pull_3" and picked.get("xp_pull_2", 0) == 0:
			continue
		if up["id"] == "pulse_size" and picked.get("pulse", 0) == 0:
			continue
		eligible.append(up)

	# monta pool ponderado pelo weight
	var weighted_pool = []
	for up in eligible:
		for i in range(up["weight"]):
			weighted_pool.append(up)

	# sorteia 3 únicos do pool ponderado
	var result = []
	var used_ids = []
	weighted_pool.shuffle()
	for up in weighted_pool:
		if up["id"] not in used_ids:
			used_ids.append(up["id"])
			result.append(up)
		if result.size() >= 3:
			break

	return result

func _choose(index: int):
	if index >= options.size():
		return
	var chosen = options[index]
	picked[chosen["id"]] = picked.get(chosen["id"], 0) + 1
	get_tree().paused = false
	hide()
	option_chosen.emit(chosen)
