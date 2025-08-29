class_name EntityMoveRightState
extends EntityMovementState


func _setup() -> void:
	super()
	Console.add_command("move_right", func(): dispatch(&"move_right"))

func _enter() -> void:
	move_right()
