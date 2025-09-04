extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready
var air_hsm: LimboHSM = $Air
@onready
var ground_hsm: LimboHSM = $Ground

var _velocity_accumulator: Vector2 = Vector2.ZERO


func _ready() -> void:
	air_hsm.initialize(self)
	air_hsm.set_active(true)
	ground_hsm.initialize(self)
	ground_hsm.set_active(true)


func _physics_process(delta: float) -> void:
	velocity = _velocity_accumulator
	move_and_slide()
	_velocity_accumulator = Vector2.ZERO


func add_velocity(vec: Vector2) -> void:
	_velocity_accumulator += vec
