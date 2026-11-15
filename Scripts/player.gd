extends CharacterBody2D

@export var playerNumber: int = 1

var fireballScene = preload("res://Scenes/fireball.tscn")
var lightningScene = preload("res://Scenes/lightning.tscn")

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

var stun = timer.new()

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

var weapons = {
	short1 = {
		charge = 18,
		attack = 15,
		cooldown = 10
	},
	short2 = {
		charge = 8,
		attack = 24,
		cooldown = 12
	},
	range2 = {
		charge = 12,
		attack = 36,
		cooldown = 12
	},
	range1 = {
		charge = 7,
		attack = 24,
		cooldown = 12
	}
}

var targetVel := Vector2.ZERO

var weaponState = WeaponState.READY
var didAttack = false

func _ready() -> void:
	pnum = str(playerNumber)

	# fixes shader param issue
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()

func getCollider():
	if $Weapon.has_overlapping_bodies():
		for body in $Weapon.get_overlapping_bodies():
			if body.name.begins_with("Player") and not body.name == name:
				return body

	return null


func fight():
	if currentAttack == Attacks.NONE and weaponState == WeaponState.READY:
		if Input.is_action_just_pressed("short" + pnum):
			$AnimatedSprite2D.play("short" + pnum)
			startup.reset(weapons["short" + pnum].charge)
			currentAttack = Attacks.SHORT
			weaponState = WeaponState.CHARGING
			print("charging")

		if Input.is_action_just_pressed("range" + pnum):
			$AnimatedSprite2D.play("range" + pnum)
			startup.reset(weapons["range" + pnum].charge)
			currentAttack = Attacks.RANGED
			weaponState = WeaponState.CHARGING
	
	if weaponState == WeaponState.CHARGING and startup.can():
		weaponState = WeaponState.ATTACKING
		print("attacking")
		if currentAttack == Attacks.SHORT:
			active.reset(weapons["short" + pnum].attack)
		else:
			active.reset(weapons["range" + pnum].attack)

	if weaponState == WeaponState.ATTACKING:
		if currentAttack == Attacks.SHORT:
			var player = getCollider()

			if not player == null and not currentAttack == Attacks.NONE and not didAttack:
				didAttack = true

				player.targetVel.y = -1000
				player.targetVel.x = 1000 if $AnimatedSprite2D.flip_h else -1000
		else:
			if not didAttack:
				didAttack = true
				if playerNumber == 1:
					var fireball = fireballScene.instantiate()
					get_parent().add_child(fireball)

					var currDurr = 1 if $AnimatedSprite2D.flip_h else -1

					fireball.position = position + Vector2(currDurr * 20, -10)

					fireball.direction = currDurr
				if playerNumber == 2:
					var lightning = lightningScene.instantiate()
					get_parent().add_child(lightning)

					var currDurr = 1 if $AnimatedSprite2D.flip_h else -1

					lightning.position = position + Vector2(currDurr * 200, -30)


	
	if weaponState == WeaponState.ATTACKING and active.can():
		didAttack = false
		print("on cooldown")
		weaponState = WeaponState.COOLDOWN
		if currentAttack == Attacks.SHORT:
			end.reset(weapons["short" + pnum].cooldown)
		else:
			end.reset(weapons["range" + pnum].cooldown)
	
	if weaponState == WeaponState.COOLDOWN and end.can():
		print("cooldown over")
		weaponState = WeaponState.READY
		currentAttack = Attacks.NONE


var isJumping = false

func _physics_process(delta: float) -> void:
	startup.update(delta)
	end.update(delta)
	active.update(delta)
	stun.update(delta)

	if not stun.can():
		$AnimatedSprite2D.play("idle1")
		return

	fight()

	var direction = Input.get_axis("left" + pnum, "right" + pnum) * speed

	if not is_on_floor():
		direction *= 0.75

	targetVel = lerp(targetVel, Vector2.ZERO, 0.2)

	if direction != 0:
		if is_on_floor() and currentAttack == Attacks.NONE and weaponState == WeaponState.READY and not didAttack:
			$AnimatedSprite2D.play("run" + pnum)
		velocity.x = lerp(velocity.x, direction, 0.25)
	else:
		if is_on_floor() and currentAttack == Attacks.NONE and weaponState == WeaponState.READY and not didAttack:
			$AnimatedSprite2D.play("idle" + pnum)
		velocity.x = lerp(velocity.x, 0.0, 0.25)

	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.offset.x = 7
		$Weapon.scale.x = -1
		$Weapon.position.x = 18
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.offset.x = -7
		$Weapon.scale.x = 1
		$Weapon.position.x = -4

	if Input.is_action_just_pressed("up" + pnum):
		if is_on_floor():
			isJumping = true
			$AnimatedSprite2D.play("jump" + pnum)
			canDoubleJump = true
			velocity.y = jump
		elif canDoubleJump:
			$AnimatedSprite2D.play("double_jump" + pnum)
			canDoubleJump = false
			velocity.y = doubleJumpSize
	if not is_on_floor() and Input.is_action_just_released("up" + pnum) and canDoubleJump:
		velocity.y *= 0.5

	velocity.y += gravity * delta

	velocity += targetVel

	move_and_slide()

	velocity -= targetVel

	fight()
