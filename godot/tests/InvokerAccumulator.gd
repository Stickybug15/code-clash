extends Node


@export
var script_controller: ScriptedController

var running: bool = false


func _ready() -> void:
  print(_parse_schema(_get_schema()))


func _physics_process(delta: float) -> void:
  if not running and Input.is_action_pressed("jump"):
    script_controller.invoke("jump")
    script_controller.invoke_done.connect(func(): running = false, ConnectFlags.CONNECT_ONE_SHOT)


func _get_schema() -> Dictionary:
  return script_controller.get_schemas().duplicate(true)


func _parse_schema(schema: Dictionary) -> String:
  var code: String = ""
  for c_name in schema:
    code += _invoker_to_class(c_name, schema[c_name]) + "\n"
  return code.strip_edges(false)


func _invoker_to_class(c_name: String, info: Array) -> String:
  var code: String = ""
  for e in info:
    code += _invoker_to_documentation(e)
    code += "\n"
    code += _invoker_to_declaration(e)
    code += "\n"
  code = code.indent("\t")
  code = "class [] {[]}".format([c_name, code], "[]")
  return code


func _invoker_to_declaration(info: Dictionary) -> String:
  var code: String = ""
  var params: Array = info["params"]
  for idx in range(len(params) - 1):
    var param: Dictionary = params[idx]
    code += param["name"] + ", "
  if len(params) > 1:
    code += params.back()["name"]
  code = "foreign static {}({})".format([info["name"], code], "{}")
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
