extends Area2D

func _ready() -> void:
	$AudioStreamPlayer.play()
	$AnimatedSprite2D.play()

var didStunm = false

func _physics_process(_delta: float) -> void:
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body.name == "Player" and not didStunm:
				didStunm = true
				Global.remove_hp(1, 5)
				body.stun.reset(45)

	if not $AnimatedSprite2D.is_playing():
		queue_free()
