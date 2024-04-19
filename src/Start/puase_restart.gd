extends Control

@onready var main = $"../../"


func _on_resume_pressed():
	main.pasueMenu


func _on_quit_pressed():
	get_tree().quit()


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/MainScene.tscn") # Replace with function body.
