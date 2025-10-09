class_name MoveInputCommand
extends Command


var sprite: AnimatedSprite2D
var speed: float = 0
var direction: float


func _init(sprite: AnimatedSprite2D) -> void:
	self.sprite = sprite


func initialize(actor: CharacterBody2D, msg: Dictionary = {}) -> void:
	speed = get_var(msg, "speed", typeof(speed))
	direction = get_var(msg, "direction", typeof(direction))

	_to_active()


func execute(actor: EntityPlayer, delta: float) -> void:
	var direction: float = signf(direction)

	if direction:
		actor.velocity.x = move_toward(actor.velocity.x, direction * speed, speed * 0.5)
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, speed * 0.2)
		if is_zero_approx(actor.velocity.x):
			_to_complete()


func change_direction(direction: float) -> void:
	self.direction = signf(direction)
