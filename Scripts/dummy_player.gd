extends Node2D

var targetPosition: Vector2

func _process(_delta: float) -> void:
	position = lerp(position, targetPosition, 0.2)
