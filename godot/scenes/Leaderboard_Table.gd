class_name Leaderboard_Table
extends VBoxContainer

@export var Leaderboard_Entries: PackedScene
@onready var EntriesContainer = $"NinePatchRect/EntriesContainer"


func _ready():
	Leaderboard_list("alice", 12.0, 15.0)
	Leaderboard_list("ryan", 12.0, 15.0)
	Leaderboard_list("goku", 12.0, 15.0)
	
	
func Leaderboard_list(Name: String, Speed: float, Accuracy: float):
	var entry = Leaderboard_Entries.instantiate()
	entry.get_node("Name").text = (Name)
	entry.get_node("Speed").text = str(Speed)
	entry.get_node("Accuracy").text = str(Accuracy)
	EntriesContainer.add_child(entry)
