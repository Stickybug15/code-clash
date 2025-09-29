extends Node2D

var env: JSEnvironment = JSEnvironment.new()

func _ready() -> void:
	var action := MethodInput.new()

	action.path = "hero.dev.wait"
	action.actions = {}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		pass
	env.add_method_v2(action)

	var path: Array = action.path.split(".", false) as Array
	print("Method Name : ", path.pop_back())
	print("Method Path:", path)

	env.eval_async("""
hero.dev.wait()
	""")
