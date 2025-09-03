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

# TODO: just remove actor, since it already exist in behaviors.
func _execute(actor: Entity, data: Dictionary) -> void:
	var jump: JumpBehavior = actor.behavior_manager.get_behavior("JumpBehavior")
	jump.start(actor, {})


func is_active(actor: Entity) -> bool:
	return actor.behavior_manager.is_any_behaviors_active(["JumpBehavior", "FallBehavior"])


func update(actor: Entity, delta: float) -> void:
	if Input.is_action_pressed("jump"):
		execute(actor, {})

	if not is_active(actor):
		end(actor)
