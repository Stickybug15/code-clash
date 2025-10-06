class_name SyncronizerV2
extends Node

var _code_edit: TextEdit
var _run: Button

var _input: SimulateInput
var input: SimulateInput:
	get: return _input


var _pending_code: String = ""


func _init(code_edit: TextEdit, run: Button) -> void:
	_code_edit = code_edit
	_run = run

	_input = SimulateInput.new(self)
	_input.env.finished.connect(func() -> void:
		_pending_code = "")

	add_child(_input)


func resume() -> void:
	_input.clear()
	_input.env.poll()


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
