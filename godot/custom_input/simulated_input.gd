class_name SimulateInput
extends CustomInput

# this epsilon is too big, but using 0.01 doesn't work.
var EPSILON: float = 0.1

var _env: ScriptEnvironment = ScriptEnvironment.new()

var _actions: Dictionary[String, bool] = {}
var _wait: bool = false
var _pending_code: String = ""

# required variables.
var _entity: Entity
var _code_edit: TextEdit
var _run: Button


func _init(entity: Entity, code_edit: TextEdit, run: Button) -> void:
	_entity = entity
	_code_edit = code_edit
	_run = run

	_run.pressed.connect(_on_run_pressed)

	_env.finished.connect(_on_env_finished)

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


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "attack"
	action.actions = {
		"attack_1": 0.0,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		_actions_press(info.actions)
	_add_method(action)


var methods: Array[MethodInput] = []
func _add_method(action: MethodInput) -> void:
	methods.append(action)
	_env.add_method(action)

var prev: String = ""
func _debug() -> void:
	var out: String = ""
	for action in methods:
		out += "{0}.[color=cyan]{1}[/color]: ".format([action.object_name, action.method_name])
		for action_name: String in action.actions.keys():
			var pressed: String = "[color=green]true" if is_action_pressed(action_name) else "[color=red]false"
			out += "{0}={1}[/color], ".format([action_name, pressed])
	if prev != out:
		prev = out
		print_rich("methods: ", out)


func _actions_press(actions: Dictionary[String, float]) -> void:
	var tasks: Array[Callable] = []
	_entity.as_pending()
	for action_name: String in actions.keys():
		var task := _action_press.bind(action_name, actions[action_name] as float)
		tasks.append(task)

	await Awaiter.all(tasks)



func _action_press(action_name: StringName, duration: float) -> void:
	_actions[action_name] = true

	duration = maxf(duration, EPSILON)

	# TODO: what's better way to do this?
	var timer := Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = duration
	add_child(timer)
	await timer.timeout
	_actions[action_name] = false


func _on_run_pressed() -> void:
	_pending_code = _code_edit.text
	#if not _env.finished.has_connections():
		#_env.finished.connect(func() -> void:
			#_on_run_pressed())


func _on_env_finished() -> void:
	_entity.as_idle()


func resume() -> void:
	_env.poll()


# === Overrides ===

func is_action_pressed(action: StringName) -> bool:
	return _actions.get(action, false)


func get_axis(negative_action: StringName, positive_action: StringName) -> float:
	return float(is_action_pressed(positive_action)) - float(is_action_pressed(negative_action))


func _try_wait() -> void:
	_wait = true


func _try_post() -> void:
	if _wait:
		_entity.as_waiting()


func post() -> void:
	if _wait:
		_entity.input.resume()
		_wait = false


func can_post() -> bool:
	return _wait


func is_ready() -> bool:
	return not _pending_code.is_empty()


func is_running() -> bool:
	return _env.is_running()


func run() -> void:
	_env.eval_async(_pending_code)
	_pending_code = ""
