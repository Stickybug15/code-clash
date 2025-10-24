extends Node

var SESSION_FILE := "user://auth_session.json"

var user: SupabaseUser:
	get:
		return Supabase.auth.client

var email: String:
	get:
		return user.email

var is_anonymous: bool:
	get:
		return user.is_anonymous

var username: String = ""
var avatar_name: String = ""


func load_session() -> bool:
	if FileAccess.file_exists(SESSION_FILE):
		var file := FileAccess.open(SESSION_FILE, FileAccess.READ)
		var login_session: Dictionary = JSON.parse_string(file.get_as_text())
		var access_token: String = login_session["access_token"]
		var refresh_token: String = login_session["refresh_token"]
		print("Access Token : ", access_token)
		print("Refresh Token: ", refresh_token)

		var task: AuthTask
		print("before")
		task = await Supabase.auth.set_session(access_token, refresh_token).completed
		print("after: ", task)
		if task.error:
			push_error(task.error.message)
			return false

		return true
	else:
		var task: AuthTask
		task = await Supabase.auth.sign_in("example@email.com", "password").completed
		if task.error:
			push_error(task.error.message)
			return false

		var login_session: Dictionary = task.data
		var session_data: Dictionary = {
			"access_token": login_session.get("access_token", ""),
			"refresh_token": login_session.get("refresh_token", ""),
		}

		print(Supabase.auth.user())
		var file := FileAccess.open(SESSION_FILE, FileAccess.WRITE)
		file.store_string(JSON.stringify(session_data, "\t"))
		return true


func login(p_email: String, password: String) -> String:
	var task: AuthTask = Supabase.auth.sign_in(p_email, password)
	task = await task.completed
	await fetch_profile()
	if task.error:
		return task.error.message
	else:
		return "Success"


func register(p_email: String, password: String) -> String:
	if p_email.is_empty():
		return "Enter your email"
	if password.is_empty():
		return "Enter your password"
	var task: AuthTask = Supabase.auth.sign_up(p_email, password)
	task = await task.completed
	if task.error:
		return task.error.message
	else:
		return "Success"


func login_anon() -> String:
	var task: AuthTask = Supabase.auth.sign_in_anonymous()
	task = await task.completed
	if task.error:
		return task.error.message
	else:
		if user.is_anonymous:
			user.email = "anonymous@email.com"
		return "Success"


func new_profile(p_username: String, p_avatar_name: String) -> String:
	var task: DatabaseTask = await Supabase.database.Rpc("new_profile", {
		"p_username": p_username,
		"p_avatar_name": p_avatar_name,
	}).completed

	if task.error:
		return task.error.message

	match task.data as String:
		"username-already-exist":
			return "Username already exist!"
		"username-is-empty":
			return "Enter your username!"
		"username-is-less-than-3":
			return "Username length must be greater or equal to 3"
		"success":
			username = p_username
			avatar_name = p_avatar_name
			fetch_profile()
			#Supabase.auth.update_data({
				#"username": p_username,
				#"avatar_name": p_avatar_name,
			#})
			return "Success"

	return "Unreachable"


func fetch_profile() -> void:
	var profile: DatabaseTask = await Supabase.database.Rpc("get_profile").completed
	if profile:
		pass

	var dict: Dictionary = profile.data[0]
	username = dict.get("username")
	avatar_name = dict.get("avatar_name")


#func start_offline() -> String:
	#_user = SupabaseUser.new({"email": "Offline"})
	#await get_tree().create_timer(0).timeout
	#return "Success"
