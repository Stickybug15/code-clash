class_name JumpComponent
extends EntityComponent


var jumping = false


var fall_component: FallComponent


func execute(actor: Swordman) -> void:
	if active:
		return
	if actor.is_on_floor():
		components.set_active_component("FallComponent", false)
		velocity = actor.up_direction * abs(actor.stats.jump_velocity)
		enable()


func _update(actor: Swordman, delta: float) -> void:
	if velocity.y < 0.0:
		velocity.y += actor.stats.jump_gravity * delta
	else:
		components.set_active_component("FallComponent", true)
		velocity = Vector2.ZERO
		disable()
