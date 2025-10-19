class_name LeaderboardEntry
extends HBoxContainer

@onready var player_name_label: Label = $Player/Name
@onready var proficiency_label: Label = $Proficiency

var player_name: String = ""
var proficiency: float = 0.0


func _ready() -> void:
	#label_update()
	pass


func set_columns(name_val: String, proficiency_val: float) -> void:
	player_name = name_val
	proficiency = proficiency_val
	label_update()


func label_update() -> void:
	player_name_label.text = player_name
	proficiency_label.text = str(proficiency)
