extends Node2D

var playerNum = 1
var player2Num = 2
var otherPlayerNum
var otherPlayer2Num
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left1"):
		playerNum -= 1
	if Input.is_action_just_pressed("right1"):
		playerNum += 1
	if Input.is_action_just_pressed("left2"):
		player2Num -= 1
	if Input.is_action_just_pressed("right2"):
		player2Num += 1
	
	if(abs(playerNum) % 2 == 0):
		otherPlayerNum = 2
	else:
		otherPlayerNum = 1
		
	if(abs(player2Num) % 2 == 0):
		otherPlayer2Num = 2
	else:
		otherPlayer2Num = 1
		
	$CharacterBody2D/AnimatedSprite2D.play("idle" + str(otherPlayer2Num))
	$CharacterBody2D2/AnimatedSprite2D.play("idle" + str(otherPlayerNum))	
	
	if Input.is_action_just_pressed("Set1"):
		Global.playerNumber = otherPlayerNum
		Global.player2Number = otherPlayer2Num
		get_tree().change_scene_to_file("res://Scenes/Countdown.tscn")
	pass
