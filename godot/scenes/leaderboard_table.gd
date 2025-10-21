class_name LeaderboardTable
extends VBoxContainer

@export
var entry_scene: PackedScene

@onready
var entries_container: Container = $NinePatchRect/VBoxContainer

var user_mail : String = "pantuaryan15@gmail.com"
var user_pwd : String = "ryanpantua123"


func _ready()->void:
	fetch_leaderboard_async()
func fetch_leaderboard_async() -> void:
	print("======================================")
	print("DEBUG: _fetch_leaderboard_async started")
	var result : AuthTask = await Supabase.auth.sign_in(user_mail, user_pwd).completed
	print("DEBUG: after login await")
	if result.user != null:
		print("failed!")
		return
	print("login success!")
	var query := SupabaseQuery.new().from("player_level_scores").select(["speed_seconds", "accuracy_score","levels!player_level_scores_level_id_fkey(name)"])
	var task2: DatabaseTask = await Supabase.database.query(query).completed
	if task2.error == null:
		print("Task2: ",task2.data)

		for row_variant in task2.data:
			var row : Dictionary = row_variant as Dictionary
			var level_name := ""
			if row.has("levels"):
				var level_variant = row["levels"]
				if typeof(level_variant) == TYPE_DICTIONARY:
					var levels: Dictionary = level_variant as Dictionary
					level_name = str(levels.get("name", ""))

			var speed_val: float = row.get("speed_seconds", 0)
			var accuracy_val: float = row.get("accuracy_score", 0)

			var speed := (float(speed_val)
			if typeof(speed_val) in [TYPE_FLOAT, TYPE_INT] else 0.0)

			var accuracy := (float(speed_val)
			if typeof(accuracy_val) in [TYPE_FLOAT, TYPE_INT] else 0.0)

			print("Entry:", level_name, row["speed_seconds"], row["accuracy_score"])
			add_entry(level_name, row["speed_seconds"], row["accuracy_score"])

	else:
		print("Error: ", task2.error)

func add_entry(player_name: String, speed: float, accuracy: float) -> void:
	var entry: LeaderboardEntry = entry_scene.instantiate()
	entry.player_name = player_name
	entry.speed = speed
	entry.accuracy = accuracy
	entries_container.add_child(entry)
