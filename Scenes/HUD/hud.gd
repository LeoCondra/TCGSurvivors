extends CanvasLayer

var boss_hp := 0
var boss_max_hp := 0
var boss_active := false

func _ready():
	$Control/BossContainer.hide()
	
func update(hp: int, xp: int, xp_next: int, level: int, time: float):
	$Control/LabelHP.text   = "HP: " + str(hp)
	$Control/LabelXP.text   = "XP: " + str(xp) + " / " + str(xp_next)
	$Control/LabelLevel.text = "Nível: " + str(level)
	$Control/LabelTime.text  = "Tempo: " + str(int(time)) + "s"

func show_boss(boss_name: String, hp: int):
	boss_hp = hp
	boss_max_hp = hp
	boss_active = true
	$Control/BossContainer.show()
	$Control/BossContainer/BossName.text = boss_name
	await get_tree().process_frame
	_update_boss_bar()

func update_boss_hp(hp: int):
	boss_hp = hp
	if boss_hp <= 0:
		boss_active = false
		$Control/BossContainer.hide()
		return
	_update_boss_bar()

func _update_boss_bar():
	var bar_full_width = $Control/BossContainer/BossBarBG.size.x
	var ratio = float(boss_hp) / float(boss_max_hp)
	$Control/BossContainer/BossBarBG/BossBarFill.size.x = bar_full_width * ratio
