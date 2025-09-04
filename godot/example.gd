extends Node2D

var action: Callable = func(): print()
@onready
var state_chart: StateChart = $StateChart

func _ready() -> void:
	print(action)
	print(action.is_null())
	print(action.is_valid())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_first_pressed() -> void:
	state_chart.send_event("second")


func _on_second_pressed() -> void:
	state_chart.send_event("first")


func _on_third_pressed() -> void:
	state_chart.send_event("first")


func _on_add_third_state_pressed() -> void:
	var third_state: AtomicState = preload("res://godot/third_state.tscn").instantiate()
	third_state.name = "Third"
	var transition: Transition = third_state.get_node("Transition")
	transition.to = ^"StateChart/CompoundState/First"
	$StateChart/CompoundState.add_child(third_state)
	state_chart.
