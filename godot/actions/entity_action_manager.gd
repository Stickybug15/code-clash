class_name EntityActionManager
extends Node2D

@export var actor: Swordman
@export var components: EntityComponentManager

var actions: Array[Dictionary] = []

func _ready() -> void:
	get_actions()


func get_actions() -> void:
	for action in get_children():
		if action is EntityAction:
			actions.append(action.action_info)


func _process(delta: float) -> void:
	for action in get_children():
		if action is EntityAction:
			continue
			action._update(actor, components, delta)
