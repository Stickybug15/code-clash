class_name SimulateInput
extends CustomInput

# this epsilon is too big, but using 0.01 doesn't work.
var EPSILON: float = 0.1

var env: ScriptEnvironment = ScriptEnvironment.new()

var _actions: Dictionary[String, bool] = {}
var timer: Timer = Timer.new()

# required variables.
var _code_edit: TextEdit
var _run: Button


func _init(code_edit: TextEdit, run: Button) -> void:
	_code_edit = code_edit
	_run = run

	_run.pressed.connect(_on_run_pressed)
	add_child(timer)

	# TODO: investigate why isn't showing any errors(in env) when passing arguments to methods that doesn't have parameters
	var action := MethodInput.new()
	action.object_name = "hero"
	action.method_name = "jump"
	action.actions = {
		"jump": 0.0
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		#fsm.ctx.populate_from_dict({
			#"args": args,
			#"method_name": info.method_name,
		#})
		_actions_press(info.actions)
	_add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "walk_left"
	action.actions = {
		"left": 0.5
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		_actions_press(info.actions)
	_add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "walk_right"
	action.actions = {
		"right": 0.5
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		_actions_press(info.actions)
	_add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "dash_left"
	action.actions = {
		"left": 0.0,
		"dash": 0.0,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		_actions_press(info.actions)
	_add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "dash_right"
	action.actions = {
		"right": 0.0,
		"dash": 0.0,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		_actions_press(info.actions)
	_add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "run_left"
	action.actions = {
		"left": 0.5,
		"run": 0.5,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		_actions_press(info.actions)
	_add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "run_right"
	action.actions = {
		"right": 0.5,
		"run": 0.5,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		_actions_press(info.actions)
	_add_method(action)


var methods: Array[MethodInput] = []
func _add_method(action: MethodInput) -> void:
	methods.append(action)
	env.add_method(action)

var prev: String = ""
func _debug() -> void:
	var out: String = ""
	for action in methods:
		out += "{0}.[color=cyan]{1}[/color]: ".format([action.object_name, action.method_name])
		for action_name: String in action.actions.keys():
			var pressed: String = "[color=green]true" if Input.is_action_pressed(action_name) else "[color=red]false"
			out += "{0}={1}[/color], ".format([action_name, pressed])
	if prev != out:
		prev = out
		print_rich("methods: ", out)


func _actions_press(actions: Dictionary[String, float]) -> void:
	for action_name: String in actions.keys():
		_action_press(action_name, actions[action_name] as float)


func _action_press(action_name: StringName, duration: float) -> void:
	_actions[action_name] = true
	Input.action_press(action_name)
	if duration < 0.0:
		duration = 0.0
	if is_zero_approx(duration):
		duration += EPSILON
	# TODO: what's better way to do this?
	timer.start(duration)
	await timer.timeout
	_actions[action_name] = false
	Input.action_release(action_name)


func _on_run_pressed() -> void:
	env.eval_async(_code_edit.text)
	#env.finished.connect(debug, ConnectFlags.CONNECT_ONE_SHOT)


func is_action_pressed(action: StringName) -> bool:
	return _actions.get(action, false)


func get_axis(negative_action: StringName, positive_action: StringName) -> float:
	return float(is_action_pressed(positive_action)) - float(is_action_pressed(negative_action))
