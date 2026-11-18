extends Control

var callback: Callable

func init(username: String, joinCallback: Callable) -> void:
	$VBoxContainer/Label.text = username + "'s Room"
	callback = joinCallback

func _ready() -> void:
	$VBoxContainer/Button.connect("pressed", callback)
