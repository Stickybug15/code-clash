extends Node


@export var code_edit: TextEdit
var entities: Array[Entity] = []


func _ready() -> void:
	for child in get_children():
		if child is Entity:
			entities.append(child)


func _process(delta: float) -> void:
	if entities.all(func(e: Entity): return e.invoker.is_valid()):
		for entity in entities:
			if entity is Entity:
				entity.invoker.call()
				entity.invoker = Callable()


func _on_run_pressed() -> void:
	for entity in entities:
		if entity is Entity:
			entity.wren_env.run_interpreter_async(code_edit.text)
