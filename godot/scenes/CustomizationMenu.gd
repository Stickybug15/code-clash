extends Control

@onready var input_name: LineEdit = $TouchScreenButton/VBoxContainer/input_name
@onready var name_label: Label = $TouchScreenButton/VBoxContainer/name

func _ready():
	input_name.text_submitted.connect(_on_LineEdit_text_entered)

func _on_LineEdit_text_entered(new_text: String):
	name_label.text =  new_text
