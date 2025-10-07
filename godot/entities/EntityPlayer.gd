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
var anim_tree_fsm: AnimationNodeStateMachinePlayback
@onready
var sprite: AnimatedSprite2D = $Sprite

@onready
var idle_state: State = $State/Region/Locomotion/Idle
@onready
var walk_state: State = $State/Region/Locomotion/Walk
@onready
var run_state: State = $State/Region/Locomotion/Run
@onready
var dash_state: State = $State/Region/Locomotion/Dash

@onready
var grounded_state: State = $State/Region/AirBorne/Ground
@onready
var falling_state: State = $State/Region/AirBorne/Fall
@onready
var jump_state: State = $State/Region/AirBorne/Jump

@onready
var locomotion_state: State = $State/Region/Locomotion
@onready
var air_borne_state: State = $State/Region/AirBorne

@onready
var _hit_box: HitBox = $Sprite/HitBox
@onready
var _status_label: Label = $Status

@onready
var _states: State = $State

var jump_cmd: ImpulseCommand
var dash_cmd: ImpulseCommand
var fall_cmd: FallCommand
var move_cmd: MoveInputCommand

var _mouse_entered := false
@onready
var sync := Syncronizer.new(code_edit, run_button)
var input: SimulateInput:
	get: return sync.input


var _face_direction := 1.0
var _jumping := false
var _return_state := ""


func _ready() -> void:
	anim_tree.active = true
	anim_tree_fsm = anim_tree["parameters/playback"]
	add_child(sync)

	jump_cmd = ImpulseCommand.new()
	dash_cmd = ImpulseCommand.new()
	fall_cmd = FallCommand.new()
	move_cmd = MoveInputCommand.new(sprite)

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


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if _hit_box == area:
		return

	if area is HitBox:
		take_damage(area.damage)


func _update_face_direction() -> void:
	if not input.is_any_action_pressed([StateNames.left, StateNames.right]):
		return

	var new_direction := input.get_axis(StateNames.left, StateNames.right)
	if is_equal_approx(_face_direction, new_direction):
		return

	_face_direction = new_direction
	input.all_action_release([StateNames.left, StateNames.right])

	sprite.scale.x = _face_direction
	move_cmd.change_direction(_face_direction)
