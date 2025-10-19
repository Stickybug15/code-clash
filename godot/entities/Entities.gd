class_name Entities
extends Node

var is_running := false

@onready var camera: PhantomCamera2D = $PhantomCamera
var engines: Array[ScriptEngine] = []


func _ready() -> void:
	for p: EntityPlayer in find_children("*", "EntityPlayer"):
		engines.append(p.engine)
		camera.append_follow_targets(p)


func all_ready() -> bool:
	return engines.all(func(s: ScriptEngine) -> bool: return s.is_ready())


func _physics_process(delta: float) -> void:
	pass


func _on_run_pressed() -> void:
	for engine: ScriptEngine in engines:
		engine.run_code_from_input()
		engine.run()
