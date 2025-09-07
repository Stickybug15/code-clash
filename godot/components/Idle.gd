class_name Idle
extends EntityComponent


@export var chart: StateChart


func _entered() -> void:
	pass # Replace with function body.


func _on_idle_state_physics_processing(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		chart.send_event("jump")
		chart.send_event("to_nil_ground")
