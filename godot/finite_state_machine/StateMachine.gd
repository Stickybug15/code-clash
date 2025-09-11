class_name StateMachine
extends Node


## The initial state of the state machine. If not set, the first child node is used.
@export
var initial_state: State = null

@onready
var states: Dictionary

## The current state of the state machine.
@onready
var state: State

@export
var actor: Node = null
@onready
var ctx: Context = Context.new()


func _ready() -> void:
	if actor == null:
		actor = owner

	for state_node: State in find_children("*", "State"):
		if state_node.state_name.is_empty():
			state_node.state_name = name
		states[state_node.state_name] = state_node
		state_node.ctx = ctx
		state_node.finished.connect(_transition_to_next_state)
		state_node._setup(actor)

	if initial_state == null:
		if get_child_count() == 0:
			push_error(name, " must have States.")
			return
		if get_child(0) is State:
			state = get_child(0)
		else:
			push_error(name, ".get_child(0) must be type State.")
			return
	else:
		state = initial_state

	state._enter(actor, null)
	state.entered.emit()


func _transition_to_next_state(event_name: String) -> void:
	if not states.has(event_name):
		printerr(actor.name + ": Trying to transition to state '" + event_name + "' but it does not exist.")
		return

	var previous_state := state

	state._exit(actor)
	state.exited.emit()

	state = states.get(event_name)

	state._enter(actor, previous_state)
	state.entered.emit()


func _process(delta: float) -> void:
	state._update(actor, delta)


func _physics_process(delta: float) -> void:
	state._physics_update(actor, delta)


func _unhandled_input(event: InputEvent) -> void:
	state._handle_input(actor, event)


func _unhandled_key_input(event: InputEvent) -> void:
	state._handle_key_input(actor, event)
