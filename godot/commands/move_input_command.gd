class_name MoveInputCommand
extends Command

@export
var sprite: AnimatedSprite2D
var speed: float = 0


func initialize(actor: CharacterBody2D, msg: Dictionary = {}) -> void:
	speed = get_var(msg, "speed", typeof(speed))

	_to_active()


func execute(actor: EntityPlayer, delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	if direction:
		actor.velocity.x = move_toward(actor.velocity.x, direction * speed, speed * 0.5)
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, speed * 0.2)
		if is_zero_approx(actor.velocity.x):
			_to_complete()

	if signf(actor.velocity.x) != 0:
		actor.sprite.flip_h = actor.velocity.x < 0
