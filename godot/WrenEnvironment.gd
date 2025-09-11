extends WrenEnvironment


signal on_execute(object_name: String, method_name: String, params: Dictionary)


func _ready() -> void:
	print(invokers)


func _execute(object_name: String, method_name: String, params: Dictionary) -> void:
	on_execute.emit(object_name, method_name, params)
