extends CanvasLayer

func update(hp: int, xp: int, xp_next: int, level: int, time: float):
	$Control/LabelHP.text   = "HP: " + str(hp)
	$Control/LabelXP.text   = "XP: " + str(xp) + " / " + str(xp_next)
	$Control/LabelLevel.text = "Nível: " + str(level)
	$Control/LabelTime.text  = "Tempo: " + str(int(time)) + "s"
