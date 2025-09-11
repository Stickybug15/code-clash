## Virtual base class for all states.
## Extend this class and override its methods to implement custom behavior.
class_name State
extends Node


## The name used by the StateMachine to identify this state
## and transition to it. Defaults to the node's name if empty.
@export
var event_name: StringName = ""

## Shared context object provided by the StateMachine for storing
## and accessing data across states.
var ctx: Context


## Emitted when this state requests a transition to another state.
## Pass the target state's event_name as argument.
signal finished(event_name: StringName)

## Emitted when this state has been entered.
signal entered

## Emitted when this state has been exited.
signal exited


## Requests a transition to another state by emitting the `finished` signal.
func transition_to(event_name: StringName):
	finished.emit(event_name)


## Called once when the StateMachine is initialized.
## Override to set up references or perform one-time setup logic.
func _setup(actor) -> void:
	pass

## Called when this state becomes active.
## `previous_state` is the state that was active before this one.
func _enter(actor, previous_state: State) -> void:
	pass

## Called right before this state is deactivated.
## Override to clean up or reset values before transitioning out.
func _exit(actor) -> void:
	pass

## Called every frame while this state is active.
## Use for logic that depends on frame updates (non-physics).
func _update(actor, _delta: float) -> void:
	pass

## Called every physics frame while this state is active.
## Use for physics-based logic and movement updates.
func _physics_update(actor, _delta: float) -> void:
	pass

## Called when the state machine receives unhandled input events.
## Override to handle general input.
func _handle_input(actor, _event: InputEvent) -> void:
	pass

## Called when the state machine receives unhandled key input events.
## Override to handle key-specific input.
func _handle_key_input(actor, _event: InputEvent) -> void:
	pass
