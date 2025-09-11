## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
class_name State
extends Node


@export
var state_name: StringName = ""
var ctx: Context


## Emitted when the state finishes and wants to transition to another state.
signal finished(event_name: StringName)

signal entered
signal exited


func transition_to(event_name: StringName):
	finished.emit(event_name)


## Called when state machine is initialized.
func _setup(actor) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func _enter(actor, previous_state: State) -> void:
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func _exit(actor) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func _update(actor, _delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func _physics_update(actor, _delta: float) -> void:
	pass

## Called by the state machine when receiving unhandled input events.
func _handle_input(actor, _event: InputEvent) -> void:
	pass

## Called by the state machine when receiving unhandled key input events.
func _handle_key_input(actor, _event: InputEvent) -> void:
	pass
