class_name Entities
extends Node

var is_running := false
var next := false

@onready var camera: PhantomCamera2D = $PhantomCamera
var players: Array[EntityPlayer]


func _ready() -> void:
	for p: EntityPlayer in find_children("*", "EntityPlayer"):
		players.append(p)
		camera.append_follow_targets(p)


func all_ready() -> bool:
	return players.all(func(p: EntityPlayer) -> bool: return p.input.is_ready())


func all_idle() -> bool:
	return players.all(func(p: EntityPlayer) -> bool: return p.is_idle())


func run_all() -> void:
	if not all_ready():
		return
	for p in players:
		p.input.run()
	is_running = true


func _physics_process(delta: float) -> void:
	if not is_running:
		run_all()
		return

	next = true
	execute(players.filter(func(p: EntityPlayer) -> bool: return not p.is_idle()))

	if all_idle():
		is_running = false


func execute(entities: Array[EntityPlayer]) -> void:
	# Debug status
	var msg := ", ".join(entities.map(
		func(e: EntityPlayer) -> String: return "%s: %s" % [e.name, str(e._status)]
	))
	print("status: ", msg)

	if entities.all(func(p: EntityPlayer) -> bool: return p.is_pending()):
		for p in entities: p.as_running()
		return

	if entities.all(func(p: EntityPlayer) -> bool: return p.is_waiting()) and next:
		for p in entities:
			p.as_running()
			p.input.post()
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
			c.input._on_run_pressed()


func _on_next_pressed() -> void:
	next = true
