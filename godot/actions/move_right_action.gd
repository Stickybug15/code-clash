class_name MoveRightAction
extends EntityAction


func _ready() -> void:
	action_info = {
		"object_name": "hero",
		"method_name": "move_right",
		"parameters": [
			{
				"type": "int",
				"name": "steps",
				"description": "",
				"default": 1,
			}
		],
		"description": "",
		"self": self,
	}


func _execute(actor: Entity, data: Dictionary) -> void:
	actor.component_manager.start_component("HorizontalMovementComponent", data.merged({"direction": "right"}, true))


func is_active(actor: Entity) -> bool:
	return actor.component_manager.get_component("HorizontalMovementComponent").is_active()


func update(actor: Entity, delta: float) -> void:
	if Input.is_action_pressed("right"):
		execute(actor, {})

	if not is_active(actor):
		end(actor)
