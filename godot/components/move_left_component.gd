class_name MoveLeftComponent
extends HorizontalMovementComponent


func _start(actor: Swordman) -> void:
	super(actor)
	components.disable_component("MoveRightComponent")
	self.move_left(actor)


func _stop(actor: Swordman) -> void:
	super(actor)
	components.enable_component("MoveRightComponent")
