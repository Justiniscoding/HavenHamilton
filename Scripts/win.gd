extends Node2D

func _ready() -> void:
	get_tree().create_timer(5).connect("timeout", func():
		get_tree().change_scene_to_file("res://Scenes/menu.tscn"))
