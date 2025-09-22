class_name Entity
extends CharacterBody2D


enum Status {
	Idle, # not active
	Pending, # an action was emited
	Running, # when the action is running
	Waiting, # after the action is finished
}

@onready
var _state_chart: StateChart = $StateChart

var _pending: bool = false
var _status: Status = Status.Running
var _first_run: bool = true

# === Required Variables ===
var input: CustomInput


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
	_toggle_processing(false)
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
		process_mode = PROCESS_MODE_INHERIT
	else:
		process_mode = PROCESS_MODE_DISABLED

	set_process(enable_processing)
	set_physics_process(enable_processing)
	set_process_input(enable_processing)
	set_process_unhandled_input(enable_processing)
