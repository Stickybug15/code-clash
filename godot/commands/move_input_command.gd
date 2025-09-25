class_name MoveInputCommand
extends Command


var sprite: AnimatedSprite2D
var speed: float = 0

var input: CustomInput


func _init(input: CustomInput, sprite: AnimatedSprite2D) -> void:
	self.input = input
	self.sprite = sprite


func initialize(actor: CharacterBody2D, msg: Dictionary = {}) -> void:
	speed = get_var(msg, "speed", typeof(speed))
	print("move: ", input.is_action_pressed("left"), "<>", input.is_action_pressed("left"))

	var direction: float = input.get_axis("left", "right")
	sprite.flip_h = direction < 0.0

	_to_active()


func execute(actor: EntityPlayer, delta: float) -> void:
	var direction: float = input.get_axis("left", "right")

	if direction:
		actor.velocity.x = move_toward(actor.velocity.x, direction * speed, speed * 0.5)
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, speed * 0.2)
		if is_zero_approx(actor.velocity.x):
			_to_complete()
