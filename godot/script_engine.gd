class_name ScriptEngine
extends Resource

var _entity: EntityPlayer
var _code_edit: TextEdit
var _run: Button

var _input: SimulateInput
var input: SimulateInput:
	get: return _input


var _pending_code: String = ""


func _init(entity: EntityPlayer, code_edit: TextEdit, run_btn: Button) -> void:
	_entity = entity
	_code_edit = code_edit
	_run = run_btn

	_input = SimulateInput.new(_entity, self)
	_input.env.finished.connect(func() -> void:
		_pending_code = "")


func ready(code: String) -> void:
	_pending_code = code


func run_code_from_input() -> void:
	ready(_code_edit.text)


func is_ready() -> bool:
	return not _pending_code.is_empty()


func run() -> void:
	if not is_ready():
		return
	_input.env.eval_async(_pending_code)
