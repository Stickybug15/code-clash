class_name LeaderboardTable
extends VBoxContainer

@export var entry_scene: PackedScene

@onready var entries_container: Container = $Entries

var user_mail: String = "pantuaryan15@gmail.com"
var user_pwd: String = "ryanpantua123"


func _ready() -> void:
	fetch_leaderboard_async()


func fetch_leaderboard_async() -> void:
	var result: AuthTask = await Supabase.auth.sign_in(user_mail, user_pwd).completed

	if result.user == null:
		print("Result: ", result.error)
		return

	print("login success!")
	var query := SupabaseQuery.new().from("player_level_scores").select(
		["speed_seconds", "accuracy_score", "...levels!inner(name)"]
	)
	var task2: DatabaseTask = await Supabase.database.query(query).completed

	if task2.data:
		print("Task2: ", task2.data)

		for row: Dictionary in task2.data:
			var speed_seconds: float = row.get("speed_seconds", -1)
			var accuracy_score: float = row.get("accuracy_score", -1)
			var level_name: String = row.get("name", "")

			print(
				"Entry: speed_seconds: {0}, accuracy_score: {1}, name: {2}".format(
					[speed_seconds, accuracy_score, level_name]
				)
			)
			add_entry(level_name, speed_seconds)

	else:
		print("Error: ", task2.error)


func add_entry(player_name: String, proficiency: float) -> void:
	var entry: LeaderboardEntry = entry_scene.instantiate()
	entry.player_name = player_name
	entry.proficiency = proficiency
	entries_container.add_child(entry)
