extends Node2D

func _ready() -> void:
	$Camera2D/Renee.value = 100
	$Camera2D/Boris.value = 100

	Global.connect("hpChange", hpChange)

func hpChange(playerNum, _amount):
	var tween: Tween = get_tree().create_tween()
	print(Global.p1hp)
	print(Global.p2hp)
	print("the palyer number is")
	if playerNum == 2:
		tween.tween_property($Camera2D/Renee, "value", Global.p2hp, 1.5)
	else:
		tween.tween_property($Camera2D/Boris, "value", Global.p1hp, 1.5)
	tween.play()
	# $Camera2D/Renee.value = Global.p1hp
	# $Camera2D/Boris.value = Global.p2hp
