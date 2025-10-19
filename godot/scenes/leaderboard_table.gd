class_name Leaderboard_Table
extends VBoxContainer

@export
var entry_scene: PackedScene
@onready
var entries_container: Container = $NinePatchRect/VBoxContainer

var user_mail : String = "pantuaryan15@gmail.com"
var user_pwd : String = "ryanpantua123"

func _ready()->void:
	print("Leaderboard ready!")
	var entry: LeaderboardEntry = entry_scene.instantiate()
	entries_container.add_child(entry)
	fetch_leaderboard()

func fetch_leaderboard() -> void:
	var result : AuthTask = await Supabase.auth.sign_in(user_mail, user_pwd).completed
	if result.user != null:
		var query := SupabaseQuery.new().from("player_level_scores").select(["levels(name)","speed_seconds", "accuracy_score"])
		var task2: DatabaseTask = await Supabase.database.query(query).completed
		if task2.error == null:
			print("Task2: ",task2.data)
			for row: Dictionary in task2.data:
				var row_dict: Dictionary = row

				var levels_data: Dictionary = {}
				if row_dict.has("levels"):
					levels_data = row_dict["levels"] as Dictionary
				print("Levels Data: ", levels_data)
				var player_name: String = "Unknown Level"
				if levels_data.has("name"):
					player_name = str(levels_data["name"])


				var speed := float(row_dict.get("speed_seconds", 0))
				var accuracy := float(row_dict.get("accuracy_score", 0))
				add_entry(player_name,speed,accuracy)

		else:
			print("Error: ",task2.error)

func add_entry(player_name: String, speed: float, accuracy: float) -> void:
	var entry: LeaderboardEntry = entry_scene.instantiate()
	entry.player_name = player_name
	entry.speed = speed
	entry.accuracy = accuracy
	entries_container.add_child(entry)
