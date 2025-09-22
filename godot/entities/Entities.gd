class_name Entities
extends Node


var next: bool = false
@onready
var camera: PhantomCamera2D = $PhantomCamera


func _ready() -> void:
	var entities: Array[Node2D] = []
	for entt: EntityPlayer in find_children("*", "EntityPlayer"):
		entities.append(entt)
		if entt.input is SimulateInput:
			var sim_input: SimulateInput = entt.input
	camera.follow_targets = entities


func _process(delta: float) -> void:
	next = true
	execute()


func execute() -> void:
	var pending_entities := {}
	var entities := find_children("*", "EntityPlayer")

	var is_pending := entities.all.bind(
		func(c: EntityPlayer) -> bool:
			return c.is_pending())
	var is_waiting := entities.all.bind(
		func(c: EntityPlayer) -> bool:
			return c.is_waiting())
	var is_idle := entities.all.bind(
		func(c: EntityPlayer) -> bool:
			return c.is_idle())

	if is_idle.call():
		return

	if is_pending.call():
		for c: Entity in find_children("*", "Entity"):
			c.as_running()
		return

	if is_waiting.call() and next:
		#var can_post := entities.all(func(e: EntityPlayer) -> bool:
			#return e.can_post())
		#if can_post:
		print_rich("[color=green]is_waiting[/color]")
		for e: EntityPlayer in entities:
			e.as_running()
			e.post()
		next = false
		return


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


func _on_next_pressed() -> void:
	next = true
