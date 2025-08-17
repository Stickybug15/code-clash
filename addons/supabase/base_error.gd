@tool
extends RefCounted
class_name BaseError

var _error : Dictionary
var code : String = "empty"
var error_code : String = "empty"
var type : String = "empty"
var message : String = "empty"
var hint : String = "empty"
var details

func _init(dictionary : Dictionary = {}) -> void:
	pass

func _to_string() -> String:
	return "%s >> %s(%s): %s (%s)" % [code, message, error_code, details, hint]
