class_name TestAction
extends EntityState


func _setup() -> void:
	get_root().add_transition(get_root().ANYSTATE, get_root().get_node(^"Test"), "to_test")
	var info := {
		"object_name": "hero",
		"method_name": "test",
		"parameters": [
			{
				"type": "bool",
				"name": "arg1",
				"description": "",
				"default": {},
			},
			{
				"type": "double",
				"name": "arg2",
				"description": "",
				"default": 1.0,
			},
			{
				"type": "string",
				"name": "arg3",
				"description": "",
				"default": "default string",
			},
			{
				"type": "list",
				"name": "arg4",
				"description": "",
				"default": [],
			},
			{
				"type": "map",
				"name": "arg5",
				"description": "",
				"default": {},
			},
		],
		"description": "",
		"self": self,
	}
