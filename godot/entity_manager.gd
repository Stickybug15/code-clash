extends Node


@export var code_edit: TextEdit
var entities: Array[Entity] = []


func _ready() -> void:
	for child in get_children():
		if child is Entity:
			entities.append(child)


func is_ready() -> bool:
	for entity in entities:
		if entity.action.is_null():
			return false
	return true


func _process(delta: float) -> void:
	if entities.all(func(e: Entity): return e.action.is_valid()):
		for entity in entities:
			entity.action.call()
			entity.action = Callable()


func _on_run_pressed() -> void:
	$Swordman.wren_env.run_interpreter_async(code_edit.text)
