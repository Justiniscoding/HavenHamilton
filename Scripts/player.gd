extends CharacterBody2D

@export var playerNumber: int = 1

var gravity = 1500
var speed = 900
var jump = -900

var pnum

func _ready() -> void:
	pnum = str(playerNumber)

func _physics_process(delta: float) -> void:
	velocity.x = Input.get_action_strength("right" + pnum) - Input.get_action_strength("left" + pnum)
	velocity.x *= speed

	if is_on_floor() and Input.is_action_just_pressed("up" + pnum):
		velocity.y = jump

	if not is_on_floor() and Input.is_action_just_released("up" + pnum):
		velocity.y *= 0.5

	velocity.y += gravity * delta

	move_and_slide()
