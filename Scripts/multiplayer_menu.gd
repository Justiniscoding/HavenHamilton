extends Node2D

const multiplayerRoomScene = preload("res://Scenes/MultiplayerRoom.tscn")

func createRoom() -> void:
	var room_name = $GUI/VBoxContainer2/LineEdit.text
	Global.emit("createRoom", room_name)
	
func joinRoom(name) -> void:
	print("here")
	print(name)

func _ready() -> void:
	$GUI/VBoxContainer/CreatRoom.connect("pressed", createRoom)

	Global.on("createRoom", func(room_name):
		var multiplayerRoom = multiplayerRoomScene.instantiate()
		multiplayerRoom.init(room_name, joinRoom)
		$GUI/OpenRooms.add_child(multiplayerRoom))
