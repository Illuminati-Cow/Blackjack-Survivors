extends Node

@onready
var root = get_tree().current_scene
@onready
var blackjack_manager = root.get_node("BlackjackManager") as Blackjack
# WARNING: This is temporary, it likely needs to be refactored so that types are
# obvious and scripts are easily accesible. Also needs to use weighted random.
@onready
var card_enemy = load("res://src/enemy/card_enemy.res")
var big_enemy = load("res://src/big_enemy/big_enemy.res")
@onready
var enemies = [
	card_enemy
]
var bigEnemies = [
	big_enemy
]
@onready var player = root.get_node("Player")

var waveNum := 1 as int

#/func _ready():
	#print("spawning enemies (start of game)")
	#var enemy := enemies.pick_random().instantiate() as CardEnemy
	#enemy.set_card(blackjack_manager.draw())
	#enemy.death_draw.connect(blackjack_manager._on_death_draw)
	# WARNING: Change this to spawn around player
	#enemy.position = Vector2(randi_range(-100, 1300), randi_range(-100, 1300))
	#enemy.target = player
	#root.add_child(enemy)

# Spawn a random enemy
func _on_spawn_timer_timeout():
	for i in waveNum:
		print("spawning enemies")
		var enemy := enemies.pick_random().instantiate() as CardEnemy
		enemy.set_card(blackjack_manager.draw())
		enemy.death_draw.connect(blackjack_manager._on_death_draw)
		# WARNING: Change this to spawn around player
		enemy.position = Vector2(randi_range(-100, 1300), randi_range(-100, 1300))
		enemy.target = player
		root.add_child(enemy)
	waveNum += 1

func _spawn_big_enemy(hand):
	var bigEnemy := big_enemy.instantiate() as Enemy #enemies.pick_random().instantiate() as CardEnemy
	bigEnemy.position = Vector2(randi_range(100, 1000), randi_range(100, 1000))
	bigEnemy.target = player
	root.add_child(bigEnemy)
	print("spawned big enemy")
	print(bigEnemy.position)
