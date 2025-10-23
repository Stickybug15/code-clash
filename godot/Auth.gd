extends Node

var SESSION_FILE := "user://auth_session.json"
var _user: SupabaseUser

var email: String:
	get:
		return _user.email


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

		_user = task.user
		return true
	else:
		var task: AuthTask
		task = await Supabase.auth.sign_in("example@email.com", "password").completed
		if task.error:
			push_error(task.error.message)
			return false

		_user = task.user
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
	if task.error:
		return task.error.message
	else:
		_user = task.user
		return "Success"


func register(p_email: String, password: String) -> String:
	var task: AuthTask = Supabase.auth.sign_up(p_email, password)
	task = await task.completed
	if task.error:
		return task.error.message
	else:
		_user = task.user
		return "Success"


func login_anon() -> String:
	var task: AuthTask = Supabase.auth.sign_in_anonymous()
	task = await task.completed
	if task.error:
		return task.error.message
	else:
		_user = task.user
		if "is_anonimous" in _user:
			_user.email = "anonymous@email.com"
		return "Success"


func start_offline() -> String:
	_user = SupabaseUser.new({
		"email": "Offline"
	})
	await get_tree().create_timer(0).timeout
	return "Success"
