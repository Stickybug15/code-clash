class_name Entities
extends Node


func _ready() -> void:
	for entt: Entity in find_children("*", "Entity"):
		add_child(entt.input)


func is_ready() -> bool:
	return find_children("*", "Entity").all(
		func(c: Entity) -> bool:
			return c.is_pending())


func _process(delta: float) -> void:
	execute()


func execute() -> void:
	if not is_ready():
		return
	for c: Entity in find_children("*", "Entity"):
		c.as_running()


func play_player() -> void:
	for c: Entity in find_children("*", "Entity"):
		c.as_running()
func pause_player() -> void:
	for c: Entity in find_children("*", "Entity"):
		c.as_waiting()

func play_enemy() -> void:
	for c: Entity in find_children("*", "Entity"):
		c.as_running()
func pause_enemy() -> void:
	for c: Entity in find_children("*", "Entity"):
		c.as_waiting()
