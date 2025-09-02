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
func execute(actor: Swordman, components: EntityComponentManager, data: Dictionary) -> void:
	print("jumping")
	components.start_component("JumpComponent", {})


func is_active(actor: Swordman, components: EntityComponentManager) -> bool:
	return components.get_component("JumpComponent").is_active()


func print_string(string: String) -> void:
	print("print_string: ", string)


func _update(actor: Swordman, components: EntityComponentManager, delta: float) -> void:
	if Input.is_action_pressed("jump"):
		execute(actor, components, {})
