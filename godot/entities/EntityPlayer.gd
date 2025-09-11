class_name EntityPlayer
extends Entity

@export
var code_edit: TextEdit
@export
var js_env: JSEnvironment


var _method_db: Dictionary = {}


func _ready() -> void:
	print(type_string(TYPE_NIL))
	print(type_string(TYPE_INT))
	print(type_string(TYPE_FLOAT))
	print(type_string(TYPE_BOOL))
	print(type_string(TYPE_ARRAY))
	print(type_string(TYPE_DICTIONARY))
	print(type_string(TYPE_STRING))

func _method(v: int) -> void:
	pass


func add_new_method(object_name: String, method_name: String, end_state: State, dispatch_name: String, param_schema: Array) -> void:
	var signature: String = "{0}.{1}".format([object_name, method_name])
	# TODO: add 'description'
	_method_db[signature] = {
		"object_name": object_name,
		"method_name": method_name,
		"dispatch_name": dispatch_name,
		"end_state": end_state,
		"params": param_schema,
	}
	js_env.add_method(_method_db[signature])


func parse_methods(db: Dictionary) -> String:
	var schemas: Dictionary = {}
	for signature in db:
		var info = db[signature]
		var methods: Array = schemas.get_or_add(info["object_name"], [])
		methods.append(info)

	var code: String = ""
	for c_name in schemas:
		code += _method_to_class(c_name, schemas[c_name]) + "\n"
	return code.strip_edges(false)


func _method_to_class(c_name: String, methods: Array) -> String:
	var code: String = ""
	for e in methods:
		var docs: String = _method_to_documentation(e)
		if not docs.is_empty():
			code += docs + "\n"
		code += _method_to_declaration(e) + "\n"
	code = code.indent("\t")
	code = "class [] {\n[]}".format([c_name, code], "[]")
	return code


func _method_to_documentation(info: Dictionary) -> String:
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


func _method_to_declaration(info: Dictionary) -> String:
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


func _on_run_pressed() -> void:
	js_env.eval_async(code_edit.text)
