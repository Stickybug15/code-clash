class_name JumpBehavior
extends EntityBehavior


var jumping = false


var fall_behavior: String = "FallBehavior"


func _start(actor: Entity, data: Dictionary) -> void:
	if actor.is_on_floor():
		velocity = actor.up_direction * abs(actor.stats.jump_velocity)
	else:
		stop(actor)


func _update(actor: Entity, delta: float) -> void:
	if velocity.y < 0.0:
		velocity.y += actor.stats.jump_gravity * delta
	else:
		actor.behavior_manager.start_behavior(fall_behavior)
		velocity = Vector2.ZERO
		stop(actor)
