class_name MethodInput
extends Resource

enum Type {
	ACTION,
	WAIT,
	MISC,
}

var object_name: String
var method_name: String
var action_name: StringName = ActionNames.none
var path: String
var type: Type
# key = action, value = duration
var actions: Dictionary[String, float]
var callable: Callable
var pre_callable: Callable
var post_callable: Callable

var params_schema: Array[Dictionary] = []

var _env: JSEnvironment


func _init(env: JSEnvironment) -> void:
	_env = env


func resume() -> void:
	_env.poll()
