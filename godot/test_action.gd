class_name TestAction
extends EntityAction


func _ready() -> void:
	action_info = {
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


func _execute(actor: Entity, data: Dictionary) -> void:
	print("data: ", data)
	end(actor)


func _end(actor: Entity) -> void:
	pass
