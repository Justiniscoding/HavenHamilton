extends CharacterBody2D

@export var playerNumber: int = 1

var gravity = 800
var speed = 300
var jump = -400
var doubleJumpSize = jump * 0.75

var canDoubleJump = false

var pnum

class timer:
	var time = 0

	func update(delta: float):
		if time > 0:
			time -= delta

	func reset(frames: int):
		time = frames / 60.0

	func can() -> bool:
		return time <= 0

# fighting system stuff
var startup = timer.new() 
var active = timer.new()
var end = timer.new()

enum Attacks {
	NONE,
	SHORT,
	RANGED
}

var currentAttack = Attacks.NONE

enum WeaponState{
	CHARGING,
	ATTACKING,
	COOLDOWN,
	READY
}

var targetVel := Vector2.ZERO

var weaponState = WeaponState.READY

func _ready() -> void:
	pnum = str(playerNumber)

	# fixes shader param issue
	$Sprite2D.material = $Sprite2D.material.duplicate()

func getCollider():
	if $Weapon.has_overlapping_bodies():
		for body in $Weapon.get_overlapping_bodies():
			if body.name.begins_with("Player") and not body.name == name:
				return body

	return null


func fight():
	if currentAttack == Attacks.NONE and weaponState == WeaponState.READY:
		if Input.is_action_just_pressed("short" + pnum):
			startup.reset(3)
			print("Starting")
			currentAttack = Attacks.SHORT
			weaponState = WeaponState.CHARGING
	
	if weaponState == WeaponState.CHARGING and startup.can():
		weaponState = WeaponState.ATTACKING
		print("Attacking")
		active.reset(5)

	if weaponState == WeaponState.ATTACKING:
		var player = getCollider()

		if not player == null and not currentAttack == Attacks.NONE:
			print("did attack")
			currentAttack = Attacks.NONE

			player.targetVel.y = -1000
			player.targetVel.x = sign(position.x - player.position.x) * -1000

	
	if weaponState == WeaponState.ATTACKING and active.can():
		weaponState = WeaponState.COOLDOWN
		print("cooling down")
		end.reset(6)
	
	if weaponState == WeaponState.COOLDOWN and end.can():
		weaponState = WeaponState.READY
		currentAttack = Attacks.NONE




func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("left" + pnum, "right" + pnum) * speed

	if not is_on_floor():
		direction *= 0.75

	targetVel = lerp(targetVel, Vector2.ZERO, 0.2)

	if direction != 0:
		velocity.x = lerp(velocity.x, direction, 0.25)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.25)

	if velocity.x > 0:
		$Sprite2D.flip_h = true
		$Sprite2D.offset.x = 7
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
		$Sprite2D.offset.x = -7

	if Input.is_action_just_pressed("up" + pnum):
		if is_on_floor():
			canDoubleJump = true
			velocity.y = jump
		elif canDoubleJump:
			canDoubleJump = false
			velocity.y = doubleJumpSize
	if not is_on_floor() and Input.is_action_just_released("up" + pnum) and canDoubleJump:
		velocity.y *= 0.5

	velocity.y += gravity * delta

	velocity += targetVel

	move_and_slide()

	velocity -= targetVel

	startup.update(delta)
	active.update(delta)
	end.update(delta)

	fight()
