class_name SimulateInput
extends CustomInput

# this epsilon is too big, but using 0.01 doesn't work.
var EPSILON: float = 0.1

var _env: JSEnvironment = JSEnvironment.new()

var _actions: Dictionary[String, bool] = {}
var _timers: Array[Timer] = []

# required variables.
var _sync: Syncronizer

var _is_action_active := false
signal action_activated
signal action_deactivated

var state_can_resume := true


var env: JSEnvironment:
  get: return _env


func _init(sync: Syncronizer) -> void:
  _sync = sync
  env.finished.connect(func() -> void:
    clear())
  var entry := new_action()

  entry = new_action()
  entry.type = entry.Type.WAIT
  entry.params_schema = [{
    "name": "duration",
    "type": "float",
    # "default": 1.0,
  }]
  entry.path = "hero.dev.wait"
  entry.pre_callable = func(info: MethodInput, args: Dictionary) -> bool:
    if not args.has("duration"):
      push_error("missing argument 'duration' for method {0}".format(info.path))
      return false
    state_can_resume = false
    print_rich("[color=green]wait[/color]")
    var duration: float = maxf(args.get("duration", 0.0) as float, EPSILON)
    get_tree().create_timer(duration).timeout.connect(func() -> void:
      _sync.resume()
      state_can_resume = true
    )
    return true
  _env.add_method_v2(entry)

  entry = new_action()
  entry.type = entry.Type.WAIT
  entry.path = "hero.dev.wait_for_action"
  entry.pre_callable = func(info: MethodInput, args: Dictionary) -> bool:
    print_rich("[color=green]wait_for_action[/color]: ", _is_action_active)
    if not _is_action_active:
      return false
    print_rich("[color=green]connect[/color]")
    action_deactivated.connect.call_deferred(func() -> void:
      _sync.resume(), ConnectFlags.CONNECT_ONE_SHOT)
    return true
  _env.add_method_v2(entry)

  entry = new_action()
  entry.type = entry.Type.ACTION
  entry.action_name = ActionNames.walk
  entry.path = "hero.dev.walk"
  entry.pre_callable = func(info: MethodInput, args: Dictionary) -> void:
    print_rich("[color=green]walk[/color]")
    action_pressed(ActionNames.walk)
  _env.add_method_v2(entry)

  entry = new_action()
  entry.type = entry.Type.ACTION
  entry.action_name = ActionNames.left
  entry.path = "hero.dev.face_left"
  entry.pre_callable = func(info: MethodInput, args: Dictionary) -> void:
    print_rich("[color=green]face_left[/color]")
    action_release(ActionNames.right)
    action_pressed(ActionNames.left)
  _env.add_method_v2(entry)

  entry = new_action()
  entry.type = entry.Type.ACTION
  entry.action_name = ActionNames.right
  entry.path = "hero.dev.face_right"
  entry.pre_callable = func(info: MethodInput, args: Dictionary) -> void:
    print_rich("[color=green]face_right[/color]")
    action_release(ActionNames.left)
    action_pressed(ActionNames.right)
  _env.add_method_v2(entry)

  entry = new_action()
  entry.type = entry.Type.MISC
  entry.path = "hero.dev.print"
  entry.params_schema = [{
    "name": "str",
    "type": "String",
    # "default": 1.0,
  }]
  entry.post_callable = func(info: MethodInput, args: Dictionary) -> void:
    print_rich("[color=green]USER[/color]: ", args["str"])
  _env.add_method_v2(entry)

  entry = new_action()
  entry.type = entry.Type.ACTION
  entry.action_name = ActionNames.run
  entry.path = "hero.dev.run"
  entry.pre_callable = func(info: MethodInput, args: Dictionary) -> void:
    print_rich("[color=green]run[/color]")
    action_pressed(ActionNames.run)
  _env.add_method_v2(entry)

  entry = new_action()
  entry.type = entry.Type.ACTION
  entry.action_name = ActionNames.jump
  entry.path = "hero.dev.jump"
  entry.pre_callable = func(info: MethodInput, args: Dictionary) -> void:
    print_rich("[color=green]jump[/color]")
    action_pressed(ActionNames.jump)
  _env.add_method_v2(entry)

  entry = new_action()
  entry.type = entry.Type.ACTION
  entry.action_name = ActionNames.dash
  entry.path = "hero.dev.dash"
  entry.pre_callable = func(info: MethodInput, args: Dictionary) -> void:
    print_rich("[color=green]dash[/color]")
    action_pressed(ActionNames.dash)
  _env.add_method_v2(entry)

  entry = new_action()
  entry.type = entry.Type.ACTION
  entry.action_name = ActionNames.idle
  entry.path = "hero.dev.idle"
  entry.pre_callable = func(info: MethodInput, args: Dictionary) -> void:
    print_rich("[color=green]idle[/color]")
    action_release(ActionNames.walk)
    action_release(ActionNames.run)
  _env.add_method_v2(entry)


func new_action() -> MethodInput:
  var action := MethodInput.new(_env)

  return action


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


func action_as_active() -> void:
  _is_action_active = true
  action_activated.emit()


func action_as_inactive() -> void:
  _is_action_active = false
  action_deactivated.emit()


func resume_if_waiting() -> void:
  if env.is_paused() and state_can_resume:
    env.poll()

# === Overrides ===

func action_pressed(action: StringName) -> void:
  print_rich("[color=cyan]action_pressed[/color](", action, ")")
  _actions[action] = true


func action_release(action: StringName) -> void:
  print_rich("[color=cyan]action_release[/color](", action, ")")
  _actions[action] = false


func all_action_release(actions: Array[StringName]) -> void:
  for action: StringName in actions:
    action_release(action)


func is_action_pressed(action: StringName) -> bool:
  return _actions.get(action, false)


func is_any_action_pressed(actions: Array[StringName]) -> bool:
  return actions.any(func(a: StringName) -> bool: return is_action_pressed(a))


func get_axis(negative_action: StringName, positive_action: StringName) -> float:
  return float(is_action_pressed(positive_action)) - float(is_action_pressed(negative_action))
