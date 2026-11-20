extends Node2D

const playerScene = preload("res://Scenes/player.tscn")
const dummyPlayerScene = preload("res://Scenes/dummy_player.tscn")

var player
var otherPlayers

func playerMove(id: String, x: String, y: String) -> void:
	get_node("OtherPlayers/" + id).targetPosition = Vector2(int(x), int(y))

func _ready() -> void:
	Global.on("inGame", func(x, y):
		player = playerScene.instantiate()
		player.position = Vector2(int(x), int(y))
		add_child(player))
	Global.on("newPlayer", func(id, x, y):
		var newPlayer = dummyPlayerScene.instantiate()
		newPlayer.targetPosition = Vector2(int(x), int(y))
		newPlayer.name = id
		$OtherPlayers.add_child(newPlayer))
	Global.on("playerMove", playerMove)

var lastUpdate = 0

func _process(delta: float) -> void:
	if !player:
		return

	lastUpdate += delta

	if lastUpdate >= 1 / 20.0:
		lastUpdate = 0
		Global.emit("playerMove", player.position.x, player.position.y)
