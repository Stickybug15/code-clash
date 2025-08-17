@tool
extends BaseError
class_name SupabaseAuthError

func _init(dictionary : Dictionary = {}) -> void:
	_error = dictionary
	if not _error.is_empty():
		type = _error.get("error", "(undefined)")
		hint = _error.get("error_description", "(undefined)")
		if _error.has("code"):
			code = str(_error.get("code", -1))
			error_code = str(_error.get("error_code", "(undefined)"))
			message = _error.get("msg", "(undefined)")
	# different body for same api source ???
