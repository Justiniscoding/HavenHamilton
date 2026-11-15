extends Area2D

var hasBeenPickedUp = false
var playerNode
var teleTo
var beenPlaced = false

var debounce = 0

var isTeleporting = false

func teleport() -> void:
	isTeleporting = true
	playerNode.get_node("AnimatedSprite2D").material.set_shader_parameter("enabled", true)

func _process(delta: float) -> void:
	if isTeleporting:
		var time = playerNode.get_node("AnimatedSprite2D").material.get_shader_parameter("time")

		if time >= 0.5:
			playerNode.get_node("AnimatedSprite2D").material.set_shader_parameter("enabled", false)
			playerNode.position = teleTo
			playerNode.canDoubleJump = true
			playerNode.get_node("AnimatedSprite2D").material.set_shader_parameter("time", 0.0)
			queue_free()
			return

		playerNode.get_node("AnimatedSprite2D").material.set_shader_parameter("time", time + delta * 3.0)
		return

	if debounce > 0:
		debounce -= delta

	if hasBeenPickedUp:
		if playerNode.name == "Player":
			if Input.is_action_just_released("down1") and not beenPlaced:
				teleTo = playerNode.position
				debounce = 1
				beenPlaced = true
			elif Input.is_action_just_released("down1") and beenPlaced and debounce < 0:
				teleport()
		else:
			if Input.is_action_just_released("down2") and not beenPlaced:
				teleTo = playerNode.position
				beenPlaced = true
				debounce = 1
			elif Input.is_action_just_released("down2") and beenPlaced and debounce < 0:
				teleport()

func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Player"):
		hasBeenPickedUp = true
		playerNode = body
		$AudioStreamPlayer2D.play()
		$CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D/AnimatedSprite2D.visible = false
