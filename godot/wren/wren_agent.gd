extends Node


var invokers: Array[Dictionary] = []
var wait_semaphore: Semaphore = Semaphore.new()


func invoke(fsm_name: String, dispatch_name: String, invoker_name: String, params: Dictionary) -> void:
	pass
