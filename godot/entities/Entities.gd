class_name Entities
extends Node

var is_running := false:
	set(v):
		print("is running" if v else "not running")
		is_running = v
	get: return is_running
var next := false
@onready
var camera: PhantomCamera2D = $PhantomCamera


func _ready() -> void:
	var entities: Array[Node2D] = []
	for entt: EntityPlayer in find_children("*", "EntityPlayer"):
		entities.append(entt)
	camera.follow_targets = entities


func is_ready() -> bool:
	return find_children("*", "EntityPlayer").all(
		func(c: EntityPlayer) -> bool:
			return c.input.is_ready()
	)

func run_all() -> void:
	if not is_ready():
		return
	for e: EntityPlayer in find_children("*", "EntityPlayer"):
		e.input.run()
	is_running = true


func _physics_process(delta: float) -> void:
	if not is_running:
		run_all()
		return

	next = true
	execute()

	if not find_children("*", "EntityPlayer").all(
		func(e: EntityPlayer):
			return e.input.is_running()
	):
		is_running = false


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
		for e: EntityPlayer in entities:
			e.as_running()
			e.input.post()
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
