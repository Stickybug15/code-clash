class_name EntityAction
extends Node2D


var action_info: Dictionary = {}


func execute(actor: Swordman, components: EntityComponentManager, data: Dictionary) -> void:
	pass


func is_active(actor: Swordman, components: EntityComponentManager) -> bool:
	return false


func _update(actor: Swordman, components: EntityComponentManager, delta: float) -> void:
	pass
