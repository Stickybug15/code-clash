class_name ImpulseCommand
extends Command

var acceleration: float
var direction: Vector2


func initialize(actor: CharacterBody2D, msg: Dictionary = {}) -> void:
	assert(msg.has("magnitude") and msg["magnitude"] is float)
	assert(msg.has("time_to_peak") and msg["time_to_peak"] is float)
	assert(msg.has("direction") and msg["direction"] is Vector2)

	var magnitude: float = msg["magnitude"]     # how far/high to reach
	var time_to_peak: float = msg["time_to_peak"]
	direction = (msg["direction"] as Vector2).normalized()

	# Same math as jump but applied along direction
	acceleration = (2.0 * magnitude) / (time_to_peak * time_to_peak)
	actor.velocity = direction * ((2.0 * magnitude) / time_to_peak)

	_to_active()


func execute(actor: CharacterBody2D, delta: float) -> void:
	# Project acceleration along direction
	if actor.velocity.dot(direction) > 0.0:
		actor.velocity += direction * acceleration * delta
	else:
		_to_complete()
