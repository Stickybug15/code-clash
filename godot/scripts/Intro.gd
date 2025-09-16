extends Node2D

func _ready():

	$AnimationPlayer.play("Fade in")
	$IntroBg.play()
	await get_tree().create_timer(6.0).timeout
	$AnimationPlayer.play("Fade out")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://godot/scenes/age_limit.tscn")
