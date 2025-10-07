@tool
extends MarginContainer


func _process(_delta: float) -> void:
	# We want to print the axctive states history below the house
	var lh = get_node("%LightsHistory")
	var text_to_add := ""
	for i in get_node("%XSMRoot").active_states_history.size():
		for k in get_node("%XSMRoot").active_states_history[i].keys():
			text_to_add += str(k, "   ")
		text_to_add += "\n"
	lh.text = text_to_add


func _on_button_1_pressed() -> void:
	if get_node("%XSMRoot").is_active("Room1Light"):
		get_node("%XSMRoot").change_state("HallwayLight")
	else:
		get_node("%XSMRoot").change_state("Room1Light")

	
func _on_button_2_main_pressed() -> void:
	if get_node("%XSMRoot").is_active("Room2LightMain"):
		get_node("%XSMRoot").change_state("HallwayLight")
	else:
		get_node("%XSMRoot").change_state("Room2LightMain")


func _on_button_2_corner_pressed() -> void:
	if get_node("%XSMRoot").is_active("Room2LightCornerOn"):
		get_node("%XSMRoot").change_state("Room2LightCornerOff")
	elif get_node("%XSMRoot").is_active("Room2LightCornerOff"):
		get_node("%XSMRoot").change_state("Room2LightCornerOn")
	else:
		get_node("%XSMRoot").change_state("Room2LightCornerOn")
