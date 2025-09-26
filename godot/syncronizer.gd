class_name Syncronizer
extends Node

enum Status {
	Idle, # not active
	Pending, # an action was emited
	Running, # when the action is running
	Waiting, # after the action is finished
}

var _status: Status = Status.Idle
var _wait: bool = false

var _agent: Node
var _input: SimulateInput

var _pending_code: String = ""
var _ready_to_run: bool = false
var _code_edit: TextEdit
var _run: Button

var _ready_to_resume: bool = false


var status: Status:
	get: return _status
var input: CustomInput:
	get: return _input


func _init(agent: Node, code_edit: TextEdit, run: Button) -> void:
	_agent = agent
	_input = SimulateInput.new(self)
	_code_edit = code_edit
	_run = run
	add_child(input)

	_run.pressed.connect(_on_run_pressed)
	_input.env.finished.connect(_on_env_finished)
	_input.env.function_invoked.connect(_on_function_invoked)


func is_idle():
	return _status == Status.Idle
func is_pending() -> bool:
	return _status == Status.Pending
func is_running() -> bool:
	return _status == Status.Running
func is_waiting() -> bool:
	return _status == Status.Waiting


func as_idle():
	_status = Status.Idle
	_toggle_processing(true)
func as_pending():
	_status = Status.Pending
	_toggle_processing(false)
func as_running():
	_status = Status.Running
	_toggle_processing(true)
func as_waiting():
	_status = Status.Waiting
	_toggle_processing(false)


func _toggle_processing(enable_processing: bool):
	if enable_processing:
		_agent.process_mode = _agent.PROCESS_MODE_INHERIT
	else:
		_agent.process_mode = _agent.PROCESS_MODE_DISABLED

	_agent.set_process(enable_processing)
	_agent.set_physics_process(enable_processing)
	_agent.set_process_input(enable_processing)
	_agent.set_process_unhandled_input(enable_processing)


var _queue_enabled := false
var _queue : int = -1
func queue() -> void:
	if _ready_to_resume or not _queue_enabled:
		return
	_queue = max(1, _queue + 1)


func dequeue() -> void:
	if _ready_to_resume or not _queue_enabled:
		return
	_queue = max(-1, _queue - 1)
	if _queue == 0:
		_ready_to_resume = true


func queue_reset() -> void:
	if _ready_to_resume or not _queue_enabled:
		return
	while _queue >= 0:
		dequeue()


func is_ready() -> bool:
	return _ready_to_run


func run() -> void:
	if is_ready():
		_input.env.eval_async(_pending_code)


func run_code(code: String) -> void:
	_pending_code = code
	_ready_to_run = true


func run_code_from_input() -> void:
	run_code(_code_edit.text)


func _on_run_pressed() -> void:
	run_code_from_input()


func _on_env_finished() -> void:
	_ready_to_run = false
	_queue_enabled = false
	as_idle()


func _on_function_invoked() -> void:
	_queue_enabled = true


func env_is_running() -> void:
	return _input.env.is_running()


func resume() -> void:
	_ready_to_resume = false
	_input.clear()
	_input.env.poll()


func can_resume() -> bool:
	return _ready_to_resume
