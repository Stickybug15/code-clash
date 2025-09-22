class_name Entity
extends CharacterBody2D


enum Status {
	Pending,
	Waiting,
	Running,
}

@onready
var _state_chart: StateChart = $StateChart

var input: CustomInput

var _pending: bool = false
var _status: Status = Status.Waiting


func is_pending() -> bool:
	return _status == Status.Pending
func is_waiting() -> bool:
	return _status == Status.Waiting
func is_running() -> bool:
	return _status == Status.Running

func as_pending():
	_status = Status.Pending
	_toggle_processing(false)
func as_waiting():
	_status = Status.Waiting
	_toggle_processing(false)
func as_running():
	_status = Status.Running
	_toggle_processing(true)



func execute() -> void:
	_state_chart.thaw()
	pass


func _toggle_processing(enable_processing: bool):
	if enable_processing:
		process_mode = PROCESS_MODE_INHERIT
	else:
		process_mode = PROCESS_MODE_DISABLED

	set_process(enable_processing)
	set_physics_process(enable_processing)
	set_process_input(enable_processing)
	set_process_unhandled_input(enable_processing)
