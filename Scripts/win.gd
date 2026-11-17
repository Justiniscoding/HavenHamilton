extends Node2D

func _ready() -> void:
	get_tree().create_timer(4).connect("timeout", func():
		if Global.p1hp == 100 or Global.p2hp == 100:
			var tween = get_tree().create_tween()
			tween.tween_property($Sprite2D, "position:x", 0.0, 2.0)
			tween.play()
			await get_tree().create_timer(6).timeout
		get_tree().change_scene_to_file("res://Scenes/PlayerSelect.tscn")
		Global.p1hp = 100
		Global.p2hp = 100)
