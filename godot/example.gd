extends Node2D

var action: Callable = func(): print()

func _ready() -> void:
	print(action)
	print(action.is_null())
	print(action.is_valid())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
