class_name EntityWrenPlayer
extends Entity


@export var code_edit: TextEdit
@export var wren_env: WrenEnvironment

var _invoke_pending: bool = false

var _invoker: Callable
var invoker_params: Dictionary = {}
var invoker_name: String

var wait_semaphore: Semaphore = Semaphore.new()
var wait_mutex: Mutex = Mutex.new()
var invokers: Array[Dictionary] = []


func _ready() -> void:
	air_hsm.initialize(self)
	air_hsm.set_active(true)
	ground_hsm.initialize(self)
	ground_hsm.set_active(true)
	stats.update_properties()
	wren_env.initialize()


func _physics_process(delta: float) -> void:
	velocity = get_total_velocity()
	move_and_slide()


func validate_schema_dictionary(schema: Dictionary, input: Dictionary, schema_name = "schema", input_name = "input") -> void:
	for key in schema:
		assert(input.has(key), "'" + schema_name + "' doesn't have " + key + " key.")
		var input_type := type_string(typeof(input.get(key)))
		var schema_type := type_string(typeof(schema.get(key)))
		assert(input_type == schema_type,
			"incorrect " + schema_name + "['"+key+"'] with type " + input_type + ", " + schema_type + " is expected type.")

	var params: Array = input["parameters"]
	var params_schema: Dictionary = schema["parameters"][0]
	for idx in range(params.size()):
		var param: Dictionary = params[idx]
		for key: String in params_schema:
			assert(param.has(key), "'info.parameters["+str(idx)+"]' doesn't have " + key + " key.")
		var param_type_default := type_string(typeof(param["default"]))
		assert(param["type"] == param_type_default,
			"info.parameters[" + str(idx) + "].default must be a type of " + param_type_default)


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
		"fsm_name": Z.union([Z.literal(air_hsm.name), Z.literal(ground_hsm.name)]),
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
			hsm = air_hsm
		"Ground":
			hsm = ground_hsm
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
