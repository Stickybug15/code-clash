class_name FallComponent
extends EntityComponent


func _update(actor: Swordman, delta: float) -> void:
	if !actor.is_on_floor():
		velocity.y += actor.stats.fall_gravity * delta
	else:
		stop(actor)


func _stop(actor: Swordman) -> void:
	velocity = Vector2.ZERO
