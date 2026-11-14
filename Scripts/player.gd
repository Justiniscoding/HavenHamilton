extends CharacterBody2D

@export var playerNumber: int = 1

var gravity = 800
var speed = 300
var jump = -400
var doubleJumpSize = jump * 0.75

var canDoubleJump = false

var pnum

func _ready() -> void:
	pnum = str(playerNumber)

func _physics_process(delta: float) -> void:
	velocity.x = Input.get_action_strength("right" + pnum) - Input.get_action_strength("left" + pnum)
	velocity.x *= speed

	if Input.is_action_just_pressed("up" + pnum):
		if is_on_floor():
			canDoubleJump = true
			velocity.y = jump
		elif canDoubleJump:
			canDoubleJump = false
			velocity.y = doubleJumpSize
	if not is_on_floor() and Input.is_action_just_released("up" + pnum):
		velocity.y *= 0.5

	velocity.y += gravity * delta

	move_and_slide()
