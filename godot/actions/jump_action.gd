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
func _execute(actor: Swordman, data: Dictionary) -> void:
	var jump: JumpComponent = actor.component_manager.get_component("JumpComponent")
	jump.start(actor, {})


func is_active(actor: Swordman) -> bool:
	return actor.component_manager.is_any_components_active(["JumpComponent", "FallComponent"])


func update(actor: Swordman, delta: float) -> void:
	if Input.is_action_pressed("jump"):
		execute(actor, {})

	if not is_active(actor):
		end(actor)
