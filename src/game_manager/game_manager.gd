extends Node

@onready
var root = get_tree().current_scene
@onready
var blackjack_manager = root.get_node("BlackjackManager") as Blackjack
# WARNING: This is temporary, it likely needs to be refactored so that types are
# obvious and scripts are easily accesible. Also needs to use weighted random.
@onready
var card_enemy = load("res://src/enemy/card_enemy.res")
@onready
var enemies = [
	card_enemy
]
@onready var player = root.get_node("Player")

# Spawn a random enemy
func _on_spawn_timer_timeout():
	var enemy := enemies.pick_random().instantiate() as CardEnemy
	enemy.set_card(blackjack_manager.draw())
	enemy.death_draw.connect(blackjack_manager._on_death_draw)
	# WARNING: Change this to spawn around player
	enemy.position = Vector2(randi_range(-5000, 5000), randi_range(-5000, 5000))
	enemy.target = player
	root.add_child(enemy)
