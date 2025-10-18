class_name LeaderboardEntry
extends HBoxContainer

@onready var player_name_label: Label = $Name
@onready var speed_label: Label = $Speed
@onready var accuracy_label: Label = $Accuracy

var player_name: String = ""
var speed: float = 0.0
var accuracy: float = 0.0

func _ready():
	player_name_label.text = player_name
	speed_label.text = str(speed)
	accuracy_label.text = str(accuracy)
