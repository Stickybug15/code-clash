extends Node2D


var variable: String = ""


func get_variable(_variable: String = variable) -> String:
	return _variable


func _ready() -> void:
	variable = "text"
	print(get_variable())
