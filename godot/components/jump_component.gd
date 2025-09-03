class_name JumpComponent
extends EntityComponent


var jumping = false


var fall_component: String = "FallComponent"


func _start(actor: Entity, data: Dictionary) -> void:
	if actor.is_on_floor():
		velocity = actor.up_direction * abs(actor.stats.jump_velocity)
	else:
		stop(actor)


func _update(actor: Entity, delta: float) -> void:
	if velocity.y < 0.0:
		velocity.y += actor.stats.jump_gravity * delta
	else:
		actor.component_manager.start_component(fall_component)
		velocity = Vector2.ZERO
		stop(actor)
