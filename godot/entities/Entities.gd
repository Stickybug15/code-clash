class_name Entities
extends Node

var is_running := false

@onready var camera: PhantomCamera2D = $PhantomCamera
var syncs: Array[SyncronizerV2] = []


func _ready() -> void:
	for p: EntityPlayer in find_children("*", "EntityPlayer"):
		syncs.append(p.sync)
		camera.append_follow_targets(p)


func all_ready() -> bool:
	return syncs.all(func(s: SyncronizerV2) -> bool: return s.is_ready())


func _physics_process(delta: float) -> void:
	pass


func _on_run_pressed() -> void:
	for sync: SyncronizerV2 in syncs:
		sync.run_code_from_input()
		sync.run()
