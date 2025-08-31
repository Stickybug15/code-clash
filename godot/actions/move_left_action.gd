class_name MoveLeftAction
extends EntityAction


func _ready() -> void:
	action_info = {
		"object_name": "hero",
		"method_name": "move_left",
		"parameters": [
			{
				"type": "int",
				"name": "steps",
				"description": "",
				"default": 1,
			}
		],
		"description": "",
		"method": execute,
		"method_is_active": is_active,
	}


func execute(actor: Swordman, components: EntityComponentManager, data: Dictionary) -> void:
	components.start_component("HorizontalMovementComponent", data.merged({"direction": "left"}, true))


func is_active(actor: Swordman, components: EntityComponentManager) -> bool:
	return components.get_component("HorizontalMovementComponent").is_active()


func _update(actor: Swordman, components: EntityComponentManager, delta: float) -> void:
	if Input.is_action_pressed("left"):
		execute(actor, components, {})
