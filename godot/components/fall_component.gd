class_name FallComponent
extends EntityComponent


func _update(actor: Swordman, delta: float) -> void:
	if !actor.is_on_floor():
		velocity.y += actor.stats.fall_gravity * delta
	else:
		velocity = Vector2.ZERO
