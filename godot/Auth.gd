extends Node


var _user: SupabaseUser

var email: String:
	get:
		return _user.email


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
