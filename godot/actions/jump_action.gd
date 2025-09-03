class_name JumpAction
extends EntityAction


func _ready() -> void:
	action_info = {
		"object_name": "hero",
		"method_name": "jump",
		"parameters": [],
		"description": "",
		"self": self,
	}

# TODO: just remove actor, since it already exist in components.
func execute(actor: Swordman, data: Dictionary) -> void:
	actor.component_manager.start_component("JumpComponent", {})


func is_active(actor: Swordman) -> bool:
	return actor.component_manager.is_any_components_active(["JumpComponent", "FallComponent"])


func print_string(string: String) -> void:
	print("print_string: ", string)


func _update(actor: Swordman, delta: float) -> void:
	if Input.is_action_pressed("jump"):
		execute(actor, {})
