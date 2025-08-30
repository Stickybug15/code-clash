class_name EntityComponents
extends Node

@onready var actor: Swordman = get_parent()

var components: Dictionary

func _ready() -> void:
	for child in get_children():
		if child is EntityComponent:
			components[child.name] = child
	enable_component("IdleComponent")
	start_component("IdleComponent")
	enable_component("FallComponent")
	start_component("FallComponent")

func start_component(component_name: String):
	var component : EntityComponent = components.get(component_name)
	if component:
		component.start(actor)

func stop_component(component_name: String):
	var component : EntityComponent = components.get(component_name)
	if not component or component.is_active():
		return
	component.start(actor)

func enable_component(component_name: String) -> void:
	var component : EntityComponent = components.get(component_name)
	if not component or component.is_enabled():
		return
	component.enable()

func disable_component(component_name: String) -> void:
	var component : EntityComponent = components.get(component_name)
	if not component or not component.is_enabled():
		return
	component.disable()


func _process(delta: float) -> void:
	var velocity := Vector2.ZERO
	for child: String in components:
		var component: EntityComponent = components[child]
		if not component.is_enabled() or not component.is_active():
			continue
		component.update(actor, delta)
		velocity += component.velocity
	actor.velocity = velocity
