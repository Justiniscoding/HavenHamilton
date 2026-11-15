extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Set1"):
		print("enter")
		$AudioStreamPlayer2D.stop()
		get_tree().change_scene_to_file("res://Scenes/Countdown.tscn")
	pass


func _on_button_button_down() -> void:
	print("enter")
	$AudioStreamPlayer2D.stop()
	get_tree().change_scene_to_file("res://Scenes/Countdown.tscn")
	pass # Replace with function body.
