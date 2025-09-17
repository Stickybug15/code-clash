class_name SimulateInput
extends Node

# this epsilon is too big, but using 0.01 doesn't work.
var EPSILON: float = 0.1

var env: ScriptEnvironment = ScriptEnvironment.new()
@export
var fsm: StateMachine
@export
var code_edit: TextEdit


func _ready() -> void:
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
		actions_press(info.actions)
	add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "walk_left"
	action.actions = {
		"left": 0.5
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		actions_press(info.actions)
	add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "walk_right"
	action.actions = {
		"right": 0.5
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		actions_press(info.actions)
	add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "dash_left"
	action.actions = {
		"left": 0.0,
		"dash": 0.0,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		actions_press(info.actions)
	add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "dash_right"
	action.actions = {
		"right": 0.0,
		"dash": 0.0,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		actions_press(info.actions)
	add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "run_left"
	action.actions = {
		"left": 0.5,
		"run": 0.5,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		actions_press(info.actions)
	add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "run_right"
	action.actions = {
		"right": 0.5,
		"run": 0.5,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		actions_press(info.actions)
	add_method(action)


var methods: Array[MethodInput] = []
func add_method(action: MethodInput) -> void:
	methods.append(action)
	env.add_method(action)

var prev: String = ""
func debug() -> void:
	var out: String = ""
	for action in methods:
		out += "{0}.[color=cyan]{1}[/color]: ".format([action.object_name, action.method_name])
		for action_name: String in action.actions.keys():
			var pressed: String = "[color=green]true" if Input.is_action_pressed(action_name) else "[color=red]false"
			out += "{0}={1}[/color], ".format([action_name, pressed])
	if prev != out:
		prev = out
		print_rich("methods: ", out)


func actions_press(actions: Dictionary[String, float]) -> void:
	for action_name: String in actions.keys():
		action_press(action_name, actions[action_name] as float)


func action_press(action_name: StringName, duration: float) -> void:
	Input.action_press(action_name)
	if duration < 0.0:
		duration = 0.0
	if is_zero_approx(duration):
		duration += EPSILON
	# TODO: what's better way to do this?
	await get_tree().create_timer(duration).timeout
	Input.action_release(action_name)


func _on_run_pressed() -> void:
	env.eval_async(code_edit.text)
	#env.finished.connect(debug, ConnectFlags.CONNECT_ONE_SHOT)
