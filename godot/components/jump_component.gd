class_name JumpComponent
extends Component


func execute(actor: Swordman) -> void:
	actor.velocity.y = actor.stats.jump_velocity


func _update(actor: Swordman, delta: float) -> void:
	if !actor.is_on_floor():
		var gravity = actor.stats.jump_gravity if actor.velocity.y < 0.0 else actor.stats.fall_gravity
		actor.velocity.y += gravity * delta
	actor.move_and_slide()
