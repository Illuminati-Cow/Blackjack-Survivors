class_name Health extends Node

# Signals
signal dead(damage : int)
signal healed(amount : int)
signal damaged(amount : int)

# Public properties
@export_range(1, 10000, 1)
var max_health : int = 100
var health : int = max_health

func set_health(new_health : int):
	health = max(0, min(max_health, new_health))
	check_health_status()

func modify_health(amount : int):
	health += amount
	# Healed or Damaged?
	if amount < 0:
		damaged.emit(abs(amount))
	elif amount > 0:
		healed.emit(abs(amount))
		
	check_health_status()

func check_health_status():
	if health < 0:
		health = 0
		emit_signal("dead", health)
		game_end()
	elif health > max_health:
		health = max_health

func game_end():
	var game_end_scene_path = "res://scenes/GameEnd.tscn"
	get_tree().change_scene_to_file(game_end_scene_path)
