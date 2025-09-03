class_name JumpComponent
extends EntityComponent


var jumping = false


var fall_component: FallComponent


func _start(actor: Swordman, data: Dictionary) -> void:
	if actor.is_on_floor():
		components.stop_component("FallComponent")
		velocity = actor.up_direction * abs(actor.stats.jump_velocity)


func _update(actor: Swordman, delta: float) -> void:
	if velocity.y < 0.0:
		velocity.y += actor.stats.jump_gravity * delta
	else:
		components.start_component("FallComponent")
		velocity = Vector2.ZERO
		stop(actor)
