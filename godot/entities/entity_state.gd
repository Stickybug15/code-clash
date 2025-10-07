@tool
class_name EntityState
extends State

var agent: EntityPlayer


func _on_enter(_args) -> void:
	agent = self.target
