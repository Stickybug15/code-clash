class_name Jumping
extends EntityComponent


@export
var agent: Entity
@export
var chart: StateChart
var velocity: Vector2 = Vector2.ZERO

@export
var to_fall: Transition


func _state_entered() -> void:
	velocity = agent.up_direction * abs(agent.stats.jump_velocity)


func _physics_processing(delta: float) -> void:
	if velocity.y < 0.0:
		velocity.y += agent.stats.jump_gravity * delta
	else:
		velocity = Vector2.ZERO
		to_fall.take(false)
		#to_fall.resolve_target().state_exited.connect(Callable(), ConnectFlags.CONNECT_ONE_SHOT)
		#agent.air_hsm.get_active_state().exited.connect(falling_exit, ConnectFlags.CONNECT_ONE_SHOT)
