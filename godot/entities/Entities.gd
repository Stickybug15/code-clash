class_name Entities
extends Node

var is_running := false
var next := false

@onready var camera: PhantomCamera2D = $PhantomCamera
var players: Array[EntityPlayer]

var syncs: Array[Syncronizer] = []


func _ready() -> void:
	for p: EntityPlayer in find_children("*", "EntityPlayer"):
		syncs.append(p.sync)

	for p: EntityPlayer in find_children("*", "EntityPlayer"):
		players.append(p)
		camera.append_follow_targets(p)


func all_ready() -> bool:
	return syncs.all(func(s: Syncronizer) -> bool: return s.is_ready())


func all_idle() -> bool:
	return syncs.all(func(s: Syncronizer) -> bool: return s.is_idle())


func run_all() -> void:
	if not all_ready():
		return
	for p in players:
		if not p.input.is_running():
			p.input.run()
	is_running = true


func _physics_process(delta: float) -> void:
	if not is_running:
		run_all()
		return

	next = true
	execute(syncs.filter(func(s: Syncronizer) -> bool: return not s.is_idle()))

	if all_idle():
		is_running = false


# TODO: when an one entity is activated, it will paused in pending state.
func execute(_syncs: Array[Syncronizer]) -> void:
	if _syncs.is_empty():
		return
	# Debug status
	#var msg := ", ".join(entities.map(
		#func(e: EntityPlayer) -> String:
			#var status := ""
			#match e._status:
				#e.Status.Idle: status = "Idle"
				#e.Status.Pending: status = "Pending"
				#e.Status.Running: status = "Running"
				#e.Status.Waiting: status = "Waiting"
			#return "%s: %s" % [e.name, status]
	#))
	#print("status: ", msg)

	if _syncs.all(func(s: Syncronizer) -> bool: return s.is_pending()):
		for s in _syncs: s.as_running()
		return

	if _syncs.all(func(s: Syncronizer) -> bool: return s.is_waiting()) and next:
		for s in _syncs:
			s.as_running()
			s.post()
		next = false


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


func _on_run_pressed() -> void:
	for c: Entity in find_children("*", "Entity"):
		if c.input.has_method("_on_run_pressed"):
			c.input.run()


func _on_next_pressed() -> void:
	next = true
