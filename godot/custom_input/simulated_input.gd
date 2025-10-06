class_name SimulateInput
extends CustomInput

# this epsilon is too big, but using 0.01 doesn't work.
var EPSILON: float = 0.1

var _env: ScriptEnvironment = ScriptEnvironment.new()

var _actions: Dictionary[String, bool] = {}
var _timers: Array[Timer] = []

# required variables.
var _sync: SyncronizerV2


var env: ScriptEnvironment:
	get: return _env


func _init(sync: SyncronizerV2) -> void:
	_sync = sync
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
		"run": 0.5,
		"left": 0.5,
	}
	action.callable = func(info: MethodInput, args: Dictionary) -> void:
		_actions_press(info.actions)
	_add_method(action)


	action = MethodInput.new()
	action.object_name = "hero"
	action.method_name = "run_right"
	action.actions = {
		"run": 0.5,
		"right": 0.5,
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

	_init_v2()


func _init_v2() -> void:
	var entry := MethodInput.new()

	entry = MethodInput.new()
	entry.params_schema = [{
		"name": "duration",
		"type": "float",
		# "default": 1.0,
	}]
	entry.path = "hero.dev.wait"
	entry.callable = func(info: MethodInput, args: Dictionary) -> String:
		if not args.has("duration"):
			push_error("missing argument 'duration' for method {0}".format(info.path))
			return ""
		print_rich("[color=green]wait[/color]")
		var duration: float = maxf(args.get("duration", 0.0) as float, EPSILON)
		get_tree().create_timer(duration).timeout.connect(func() -> void:
			_sync.resume()
		)
		return "wait"
	_env.add_method_v2(entry)

	entry = MethodInput.new()
	entry.path = "hero.dev.walk"
	entry.callable = func(info: MethodInput, args: Dictionary) -> void:
		print_rich("[color=green]walk[/color]")
		action_pressed(StateNames.walk)
	_env.add_method_v2(entry)

	entry = MethodInput.new()
	entry.path = "hero.dev.face_left"
	entry.callable = func(info: MethodInput, args: Dictionary) -> void:
		print_rich("[color=green]face_left[/color]")
		action_pressed(StateNames.left)
	_env.add_method_v2(entry)

	entry = MethodInput.new()
	entry.path = "hero.dev.face_right"
	entry.callable = func(info: MethodInput, args: Dictionary) -> void:
		print_rich("[color=green]face_right[/color]")
		action_pressed(StateNames.right)
	_env.add_method_v2(entry)

	entry = MethodInput.new()
	entry.path = "hero.dev.print"
	entry.params_schema = [{
		"name": "str",
		"type": "String",
		# "default": 1.0,
	}]
	entry.callable = func(info: MethodInput, args: Dictionary) -> void:
		print_rich("[color=green]USER[/color]: ", args["str"])
	_env.add_method_v2(entry)

	#info.path = "hero.dev.run"
	#info.callable = func(info: MethodInput, args: Dictionary) -> void:
		#print_rich("[color=green]run[/color]")
		#action_pressed(StateNames.run)
	#_env.add_method_v2(info)


var methods: Array[MethodInput] = []
func _add_method(action: MethodInput) -> void:
	methods.append(action)
	_env.add_method(action)

var prev: String = ""
func _debug() -> void:
	var lines_out: Array[String] = []
	for action in methods:
		var line := ""
		line += "{0}.[color=cyan]{1}[/color]:".format([action.object_name, action.method_name])
		for action_name: String in action.actions.keys():
			var pressed: String = "[color=green]true" if is_action_pressed(action_name) else "[color=red]false"
			line += " {0}={1}[/color]".format([action_name, pressed])
		lines_out.append(line)

	var out := "\n".join(lines_out)
	if prev != out:
		prev = out
		print_rich("methods: \n",  out)
#func _physics_process(delta: float) -> void:
	#_debug()


func _actions_press(actions: Dictionary[String, float]) -> void:
	var tasks: Array[Callable] = []
	#_sync.as_pending()
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
	_timers.append(timer)
	add_child(timer)
	await timer.timeout
	_actions[action_name] = false
	timer.queue_free()


func clear() -> void:
	# TODO: how about the timers?
	_actions.clear()

# === Overrides ===

func action_pressed(action: StringName) -> void:
	_actions[action] = true


func action_release(action: StringName) -> void:
	_actions[action] = false


func all_action_release(actions: Array[StringName]) -> void:
	for action: StringName in actions:
		action_release(action)


func is_action_pressed(action: StringName) -> bool:
	return _actions.get(action, false)


func is_any_action_pressed(actions: Array[StringName]) -> bool:
	return actions.any(func(a: StringName) -> bool: return _actions.get(a, false))


func get_axis(negative_action: StringName, positive_action: StringName) -> float:
	return float(is_action_pressed(positive_action)) - float(is_action_pressed(negative_action))
