extends Area2D

var speed = 250

var direction = 1

var timer = 0

func _ready() -> void:
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("roll")

func _physics_process(delta: float) -> void:
	timer += delta

	if timer > 1.5:
		$AnimatedSprite2D.play("explode")
		set_physics_process(false)
		$AnimatedSprite2D.connect("animation_finished", func():
			queue_free())
		return

	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body.name == "Player2":
				$AnimatedSprite2D.play("explode")
				set_physics_process(false)
				body.targetVel.x = 400 * direction
				Global.remove_hp(2, 5)
				$AnimatedSprite2D.connect("animation_finished", func():
					queue_free())
				return


	position.x += direction * speed * delta
