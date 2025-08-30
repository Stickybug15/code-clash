class_name HorizontalMovementComponent
extends EntityComponent

enum Direction {
	LEFT,
	RIGHT,
}

var remaining: float = 0


func _update(actor: Swordman, delta: float) -> void:
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


func move(actor: Swordman, steps: int, direction: Direction) -> void:
	var direction_unit := 0
	match direction:
		Direction.LEFT:
			direction_unit = -1
		Direction.RIGHT:
			direction_unit = 1

	remaining = actor.stats.distance * steps * direction_unit

func move_left(actor: Swordman, steps: int = 1) -> void:
	move(actor, steps, Direction.LEFT)


func move_right(actor: Swordman, steps: int = 1) -> void:
	move(actor, steps, Direction.RIGHT)
