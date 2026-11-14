extends Area2D

var hasBeenPickedUp = false
var playerNode
var teleTo
var beenPlaced = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hasBeenPickedUp:
		if playerNode.name == "Player":
			if Input.is_action_just_released("down1") and not beenPlaced:
				teleTo = playerNode.position
				beenPlaced = true
			if Input.is_action_just_pressed("down1") and beenPlaced:
				playerNode.position = teleTo
				queue_free()
		else:
			if Input.is_action_just_released("down2") and not beenPlaced:
				teleTo = playerNode.position
				beenPlaced = true
			if Input.is_action_just_pressed("down2") and beenPlaced:
				playerNode.position = teleTo
				queue_free()
		
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Player"):
		hasBeenPickedUp = true
		playerNode = body
		$CollisionShape2D.disabled = true
		$Sprite2D.visible = false

		
		
	pass # Replace with function body.
