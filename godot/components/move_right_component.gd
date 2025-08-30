class_name MoveRightComponent
extends HorizontalMovementComponent


func _start(actor: Swordman) -> void:
	super(actor)
	components.disable_component("MoveLeftComponent")
	self.move_right(actor)


func _stop(actor: Swordman) -> void:
	super(actor)
	components.enable_component("MoveLeftComponent")
