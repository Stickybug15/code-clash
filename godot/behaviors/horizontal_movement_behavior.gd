class_name HorizontalMovementBehavior
extends EntityBehavior

enum Direction {
	LEFT,
	RIGHT,
}

var remaining: float = 0


func _update(actor: Entity, delta: float) -> void:
	if remaining == 0:
		velocity.x = 0
		return

	# constant speed, based on direction of remaining
	var step : float = sign(remaining) * actor.stats.speed

	# Clamp so we don’t overshoot
	if abs(step) * delta >= abs(remaining):
		velocity.x = remaining
		remaining = 0
		stop(actor)
	else:
		velocity.x = step
		remaining -= step * delta


func move(actor: Entity, steps: int, direction: Direction) -> void:
	var direction_unit := 0
	match direction:
		Direction.LEFT:
			direction_unit = -1
		Direction.RIGHT:
			direction_unit = 1

	remaining = actor.stats.distance * steps * direction_unit


func _start(actor: Entity, data: Dictionary) -> void:
	assert(data.has("direction"), "data must contain 'direction' data.")
	assert(data.get("direction") in ["left", "right"], "key 'direction' must be either 'left' or 'right'.")
	var direction: String = data.get("direction")
	if direction == "left":
		move(actor, data.get("steps", 1), Direction.LEFT)
	elif direction == "right":
		move(actor, data.get("steps", 1), Direction.RIGHT)
