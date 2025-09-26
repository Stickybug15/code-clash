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


var status: Status:
	get: return _status
var input: CustomInput:
	get: return _input


func _init(agent: Node, code_edit: TextEdit, run: Button) -> void:
	_agent = agent
	_input = SimulateInput.new(self, code_edit, run)
	add_child(input)


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


func try_wait() -> void:
	_input._try_wait()
	_wait = true


func try_post() -> void:
	if _wait:
		as_waiting()


func post() -> void:
	if _wait:
		_input.resume()
		_wait = false


func can_post() -> bool:
	return _wait


func is_ready() -> bool:
	return _input.is_ready()


func run() -> void:
	if is_ready():
		_input.run()
