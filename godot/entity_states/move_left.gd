class_name EntityMoveLeftState
extends EntityMovementState

func _setup() -> void:
	super()
	Console.add_command("move_left", func(): dispatch(&"move_left"))


func _enter() -> void:
	move_left()
