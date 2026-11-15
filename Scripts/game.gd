extends Node2D

func _ready() -> void:
	$Control/Renee.value = 100
	$Control/Boris.value = 100

	Global.connect("hpChange", hpChange)

func hpChange(playerNum, _amount):
	var tween: Tween = get_tree().create_tween()
	print(Global.p1hp)
	print(Global.p2hp)
	if playerNum == 2:
		tween.tween_property($Control/Renee, "value", Global.p2hp, 1.5)
	else:
		tween.tween_property($Control/Boris, "value", Global.p1hp, 1.5)
	tween.play()
