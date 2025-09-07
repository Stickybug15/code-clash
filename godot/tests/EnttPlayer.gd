extends Entt

@export
var wren: WrenEnvironment
@export
var code_edit: TextEdit
@export
var hsm: LimboHSM


var _invoker_db: Dictionary = {}
var _invoke_pending: bool = false

var _invoker: Callable
var invoker_params: Dictionary = {}
var invoker_name: String

var wait_semaphore: Semaphore = Semaphore.new()
var wait_mutex: Mutex = Mutex.new()
var invokers: Array[Dictionary] = []


func add_new_invoker(object_name: String, method_name: String, callable: Callable, param_schema: Array) -> void:
  var signature: String = "{0}.{1}".format([object_name, method_name])
  # TODO: add 'description'
  _invoker_db[signature] = {
    "object_name": object_name,
    "method_name": method_name,
    "callable": callable,
    "params": param_schema,
  }


func _ready() -> void:
  hsm.initialize(self)
  hsm.set_active(true)
  var code: String = parse_invokers(_invoker_db)
  var class_names: Array = []
  for method_info in _invoker_db.values():
    if not method_info["object_name"] in class_names:
      class_names.append(method_info["object_name"])
  print(class_names)
  wren.initialize(code, class_names)


func parse_invokers(db: Dictionary) -> String:
  var schemas: Dictionary = {}
  for signature in db:
    var info = db[signature]
    var methods: Array = schemas.get_or_add(info["object_name"], [])
    methods.append(info)

  var code: String = ""
  for c_name in schemas:
    code += _invoker_to_class(c_name, schemas[c_name]) + "\n"
  return code.strip_edges(false)


func _invoker_to_class(c_name: String, methods: Array) -> String:
  var code: String = ""
  for e in methods:
    var docs: String = _invoker_to_documentation(e)
    if not docs.is_empty():
      code += docs + "\n"
    code += _invoker_to_declaration(e) + "\n"
  code = code.indent("\t")
  code = "class [] {\n[]}".format([c_name, code], "[]")
  return code


func _invoker_to_documentation(info: Dictionary) -> String:
  var code: String = info.get("description", "")
  var params: Array = info["params"]
  for param: Dictionary in params:
    code += "/// @param {}: {}".format([param["name"], param["type"]], "{}")
    if param.has("default_value"):
      code += " = " + str(param["default_value"])
    if param.has("description"):
      code += "; " + param["description"]
    code += "\n"
  return code.strip_edges(false)


func _invoker_to_declaration(info: Dictionary) -> String:
  var code: String = ""
  var params: Array = info["params"]
  for idx in range(len(params) - 1):
    var param: Dictionary = params[idx]
    code += param["name"] + ", "
  if len(params) > 0:
    code += params.back()["name"]
  code = "foreign static {}({})".format([info["method_name"], code], "{}")
  return code.strip_edges(false)


func _physics_process(delta: float) -> void:
  move_and_slide()


func get_total_velocity() -> Vector2:
  return Vector2.ZERO


func add_invoker(info: Dictionary) -> void:
  var schema := Z.schema({
    "object_name": Z.string(),
    "method_name": Z.string(),
    "parameters": Z.array(
      Z.schema({
        "type": Z.union([
          Z.literal(type_string(TYPE_STRING)),
          Z.literal(type_string(TYPE_INT)),
          Z.literal(type_string(TYPE_FLOAT)),
          Z.literal(type_string(TYPE_ARRAY)),
          Z.literal(type_string(TYPE_BOOL)),
          Z.literal(type_string(TYPE_DICTIONARY)),
        ]),
        "name": Z.string(),
        "description": Z.string(),
        "default": Z.union([
          Z.string(),
          Z.integer(),
          Z.float(),
          Z.array(),
          Z.boolean(),
          Z.dictionary(),
        ]),
      })
    ),
    "description": Z.string(),
    "dispatch_name": Z.string(),
    #"fsm_name": Z.union([Z.literal(air_hsm.name), Z.literal(ground_hsm.name)]),
    "fsm_name": Z.string_name(),
  })

  var res := schema.parse(info)
  if not res.ok():
    assert(false, res.error)
  info["fsm_name"] = str(info["fsm_name"])
  invokers.append(info)


# TODO: allow a invoker to be not an entity state dispatch.
func invoke(fsm_name: String, dispatch_name: String, invoker_name: String, params: Dictionary) -> void:
  assert(fsm_name in ["Air", "Ground"], "the fsm_name '" + fsm_name + "' is not valid.")
  var hsm: LimboHSM
  match fsm_name:
    "Air":
      pass
    "Ground":
      pass
    _:
      printerr("Invalid '" + invoker_name + "' name.")
  hsm.blackboard.populate_from_dict(params)
  # TODO: handle invoker_name as reserved parameter name.
  hsm.blackboard.set_var("invoker_name", invoker_name)
  _invoker = hsm.dispatch.bind(dispatch_name)
  _invoke_pending = true


func is_pending() -> bool:
  return _invoke_pending


func activate() -> void:
  _invoker.call()
  _invoker = Callable()
  _invoke_pending = false


func _on_wren_on_execute(object_name: String, method_name: String, params: Dictionary) -> void:
  var signature: String = "{0}.{1}".format([object_name, method_name])
  assert(_invoker_db.has(signature), "{0} doesn't exist!".format([signature]))
  var info: Dictionary = _invoker_db["signature"]
  var fn: Callable = info["callable"]
  var schema: Dictionary = info["schema"]


func _on_run_pressed() -> void:
  wren.run_interpreter_async(code_edit.text)
