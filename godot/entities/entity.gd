class_name Entity
extends CharacterBody2D


@export var stats: EntityStats


@onready
var air_hsm: LimboHSM = $Air
@onready
var ground_hsm: LimboHSM = $Ground


var events: Dictionary = {}


func _init_hsm() -> void:
	air_hsm.initialize(self)
	air_hsm.set_active(true)
	ground_hsm.initialize(self, air_hsm.blackboard)
	ground_hsm.set_active(true)


func add_invoker(info: Dictionary) -> void:
	pass


func get_total_velocity() -> Vector2:
	var total: Vector2 = Vector2.ZERO
	for state in air_hsm.get_children():
		if state is EntityState:
			total += state.velocity
	for state in ground_hsm.get_children():
		if state is EntityState:
			total += state.velocity
	return total


func is_pending() -> bool:
	push_error(name, ".pending not implemented.")
	return false


func activate() -> void:
	push_error(name, ".activate not implemented.")
