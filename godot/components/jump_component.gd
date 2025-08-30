class_name JumpComponent
extends Component


@onready var jump_velocity : float
@onready var jump_gravity : float
@onready var fall_gravity : float

@export var jump_height : float:
	get:
		return jump_height
	set(value):
		jump_height = value
		update_jump_properties(jump_height, jump_time_to_peak, jump_time_to_descent)
@export var jump_time_to_peak : float = 0.3:
	get:
		return jump_time_to_peak
	set(value):
		jump_time_to_peak = value
		update_jump_properties(jump_height, jump_time_to_peak, jump_time_to_descent)
@export var jump_time_to_descent: float = 0.3:
	get:
		return jump_time_to_descent
	set(value):
		jump_time_to_descent = value
		update_jump_properties(jump_height, jump_time_to_peak, jump_time_to_descent)


func _init() -> void:
	jump_height = 48
	jump_time_to_peak = 0.35
	jump_time_to_descent = 0.25


func update_jump_properties(jump_height: float, jump_time_to_peak: float, jump_time_to_descent: float) -> void:
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


func execute(actor: Swordman) -> void:
	actor.velocity.y = jump_velocity


func _update(actor: Swordman, delta: float) -> void:
	if !actor.is_on_floor():
		var gravity = jump_gravity if actor.velocity.y < 0.0 else fall_gravity
		actor.velocity.y += gravity * delta
	actor.move_and_slide()
