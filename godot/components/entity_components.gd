class_name EntityComponents
extends Node

@onready var actor: Swordman = get_parent()

var components: Dictionary

func _ready() -> void:
	for child in get_children():
		if child is EntityComponent:
			components[child.name] = child

func set_active_component(name: String, active: bool) -> void:
	if !components.has(name):
		return

	var component : EntityComponent = components[name]
	component.active = active


func _process(delta: float) -> void:
	var velocity := Vector2.ZERO
	for child: String in components:
		var component: EntityComponent = components[child]
		if not component.active:
			continue
		component._update(actor, delta)
		velocity += component.velocity
	actor.velocity = velocity
