class_name LeaderboardEntry
extends HBoxContainer

@onready var player_name_label: Label = $Name
@onready var level_name_label: Label = $Level
@onready var speed_label: Label = $Speed
@onready var accuracy_label: Label = $Accuracy

var player_name: String = ""
var level_name: String = ""
var speed: float = 0.0
var accuracy: float = 0.0

func _ready() -> void:
	label_update()
func set_data(name_val: String, level_val: String, speed_val: float, accuracy_val: float)->void:
	player_name = name_val
	level_name = level_val
	speed = speed_val
	accuracy = accuracy_val
	label_update()

func label_update() -> void:
	player_name_label.text = player_name
	level_name_label.text = level_name
	speed_label.text = str(speed)
	accuracy_label.text = str(accuracy)
