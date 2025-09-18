class_name MoveInputCommand
extends Command

@export
var sprite: AnimatedSprite2D
var speed: float = 0
var initial_direction: float


func initialize(actor: CharacterBody2D, msg: Dictionary = {}) -> void:
	speed = get_var(msg, "speed", typeof(speed))
	initial_direction = Input.get_axis("left", "right")

	_to_active()


func execute(actor: EntityPlayer, delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if not is_equal_approx(direction, initial_direction):
		direction = 0.0

	if direction:
		actor.velocity.x = move_toward(actor.velocity.x, direction * speed, speed * 0.5)
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, speed * 0.2)
		if is_zero_approx(actor.velocity.x):
			_to_complete()
