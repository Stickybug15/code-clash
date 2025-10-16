class_name Leaderboard_Table
extends VBoxContainer

@export
var entry_scene: PackedScene
@onready
var entries_container = $NinePatchRect/VBoxContainer

var user_mail : String = "pantuaryan15@gmail.com"
var user_pwd : String = "ryanpantua123"

func _ready() -> void:
	var result : AuthTask = await Supabase.auth.sign_in(user_mail, user_pwd).completed
	if result.user != null:
		var query := SupabaseQuery.new().from("public.player_level_scores").select(["speed_seconds", "accuracy_score"])
		var task2: DatabaseTask = await Supabase.database.query(query).completed
		if task2.error == null:
			print(task2.data)
		else:
			print(task2.error)

func add_entry(player_name: String, speed: float, accuracy: float):
	var entry: LeaderboardEntry = entry_scene.instantiate()
	entry.player_name = player_name
	entry.speed = speed
	entry.accuracy = accuracy
	entries_container.add_child(entry)
