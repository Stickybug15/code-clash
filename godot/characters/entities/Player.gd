class_name EntityPlayer
extends Entity

@export
var code_edit: TextEdit
@export
var run_button: Button
@export
var stats: EntityStats

@onready
var anim_tree: AnimationTree = $AnimationTree
@onready
var anim_tree_fsm: AnimationNodeStateMachinePlayback = anim_tree["parameters/playback"]
@onready
var sprite: AnimatedSprite2D = $Sprite

@onready
var idle_state: State = $XSM/Locomotion/Idle
@onready
var walk_state: State = $XSM/Locomotion/Walk
@onready
var run_state: State = $XSM/Locomotion/Run
@onready
var dash_state: State = $XSM/Locomotion/Dash
@onready
var face_direction_state: State = $XSM/Locomotion/FaceDirection

@onready
var grounded_state: State = $XSM/AirBorne/Ground
@onready
var falling_state: State = $XSM/AirBorne/Fall
@onready
var jump_state: State = $XSM/AirBorne/Jump

@onready
var locomotion_state: State = $XSM/Locomotion
@onready
var air_borne_state: State = $XSM/AirBorne

@onready
var _hit_box: HitBox = $Sprite/HitBox
@onready
var _status_label: Label = $Status

@onready
var _xsm: State = $XSM

@onready
var jump_cmd := ImpulseCommand.new()
@onready
var dash_cmd := ImpulseCommand.new()
@onready
var fall_cmd := FallCommand.new()
@onready
var move_cmd := MoveInputCommand.new(sprite)

var _mouse_entered := false
@onready
var engine := ScriptEngine.new(self, code_edit, run_button)
var input: SimulateInput:
	get: return engine.input


var _face_direction := 1.0


func _ready() -> void:
	anim_tree.active = true

	input.env.started.connect(func() -> void:
		_status_label.text = "Env is Started")
	input.env.finished.connect(func() -> void:
		_status_label.text = "Env is Finished")


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left_mouse_button") and _mouse_entered:
		position = get_global_mouse_position()
		return
	move_and_slide()


func _on_mouse_entered() -> void:
	_mouse_entered = true


func _on_mouse_exited() -> void:
	_mouse_entered = false


func take_damage(damage: float) -> void:
	if idle_state.active or walk_state.active or run_state.active:
		health -= damage
		locomotion_state.change_state(&"Hurt")
		air_borne_state.change_state(&"Ground")


func _on_hurt_box_area_entered(area: HitBox) -> void:
	if area == null:
		return

	if _hit_box == area:
		return

	if area is HitBox:
		take_damage(area.damage)


func change_face_direction() -> bool:
	if not input.is_any_action_pressed([ActionNames.left, ActionNames.right]):
		return false

	var new_direction := input.get_axis(ActionNames.left, ActionNames.right)
	if is_equal_approx(_face_direction, new_direction):
		return false
	var current_state: State = (locomotion_state.get_active_substate() as State)
	_xsm.get_state(&"FaceDirection").next_state = current_state.get_path()
	_xsm.change_state(&"FaceDirection", new_direction)
	return true
