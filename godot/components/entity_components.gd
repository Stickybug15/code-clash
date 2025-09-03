class_name EntityComponentManager
extends Node

@export var actor: Swordman

var components: Dictionary

func _ready() -> void:
	for child in get_children():
		if child is EntityComponent:
			components[child.name] = child
	enable_component("IdleComponent")
	start_component("IdleComponent")
	enable_component("FallComponent")
	start_component("FallComponent")

func start_component(component_name: String, data: Dictionary = {}):
	var component : EntityComponent = get_component(component_name)
	if component:
		print("start: ", component_name)
		component.start(actor, data)

func stop_component(component_name: String):
	var component : EntityComponent = get_component(component_name)
	if not component or component.is_active():
		return
	print("stop: ", component_name)
	component.stop(actor)

func enable_component(component_name: String) -> void:
	var component : EntityComponent = get_component(component_name)
	if not component or component.is_enabled():
		return
	print("enabled: ", component_name)
	component.enable()

func disable_component(component_name: String) -> void:
	var component : EntityComponent = get_component(component_name)
	if not component or not component.is_enabled():
		return
	print("disabled: ", component_name)
	component.disable()


func is_any_components_active(names: Array[String]) -> bool:
	for name in names:
		if get_component(name).is_active():
			return true
	return false


func get_component(component_name: String) -> EntityComponent:
	var component : EntityComponent = components.get(component_name)
	if not component:
		push_warning(component_name + " not found.")
		return null
	return component


func _process(delta: float) -> void:
	var velocity := Vector2.ZERO
	for child: String in components:
		var component: EntityComponent = components[child]
		if not component.is_enabled() or not component.is_active():
			continue
		component.update(actor, delta)
		velocity += component.velocity
	actor.velocity = velocity
