extends Node2D

var timeTokenScene = preload("res://Scenes/TimeToken.tscn")
var timePerToken = 10

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
	# $Camera2D/Renee.value = Global.p1hp
	# $Camera2D/Boris.value = Global.p2hp

func _process(delta: float) -> void:
	timePerToken -= delta
	if timePerToken <= 0:
		var timeToken = timeTokenScene.instantiate()
		add_child(timeToken)
		timeToken.position.x = (randf() * 550) - 275
		timeToken.position.y = 50
		timePerToken = 8 + randf() * 4
		
