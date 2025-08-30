class_name MoveLeftComponent
extends HorizontalMovementComponent


func _start(actor: Swordman) -> void:
	components.disable_component("MoveRightComponent")
	self.move_left(actor)


func _stop(actor: Swordman) -> void:
	components.enable_component("MoveRightComponent")
