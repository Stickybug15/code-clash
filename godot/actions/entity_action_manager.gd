class_name EntityActionManager
extends Node2D

@export var actor: Swordman

var actions: Array[Dictionary] = []


func _ready() -> void:
	get_actions()


func get_actions() -> void:
	for action in get_children():
		if action is EntityAction:
			actions.append(action.action_info)


func _process(delta: float) -> void:
	for action in get_children():
		if action is not EntityAction:
			continue
		if not action.is_running(actor):
			continue
		action.update(actor, delta)
