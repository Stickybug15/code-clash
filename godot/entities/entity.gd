class_name Entity
extends CharacterBody2D

@export var stats: EntityStats
@export var code_edit: TextEdit
@export var wren_env: WrenEnvironment

var invoker: Callable
var invoker_params: Dictionary = {}
var invoker_name: String

var wait_semaphore: Semaphore = Semaphore.new()
var wait_mutex: Mutex = Mutex.new()
var invokers: Array[Dictionary] = []


@onready
var air_hsm: LimboHSM = $Air
@onready
var ground_hsm: LimboHSM = $Ground

var _velocity_accumulator: Vector2 = Vector2.ZERO


func _ready() -> void:
	air_hsm.initialize(self)
	air_hsm.set_active(true)
	ground_hsm.initialize(self)
	ground_hsm.set_active(true)
	stats.update_properties()
	wren_env.initialize()


func _physics_process(delta: float) -> void:
	velocity = _velocity_accumulator
	move_and_slide()
	_velocity_accumulator = Vector2.ZERO


func add_velocity(vec: Vector2) -> void:
	_velocity_accumulator += vec


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
	self.invoker_name = invoker_name
	self.invoker_params = params
	match fsm_name:
		"Air":
			invoker = air_hsm.dispatch.bind(dispatch_name)
		"Ground":
			invoker = ground_hsm.dispatch.bind(dispatch_name)
