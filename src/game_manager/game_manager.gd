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
@onready var player = root.get_node("Player") as Player

var waveNum := 1 as int

func _ready():
	# Connect UI to BlackjackManager
	var p_h = root.find_child("PlayerHand") as HandDisplay
	assert(p_h != null)
	var h_h = root.find_child("HouseHand") as HandDisplay
	var hlth_d = root.find_child("HealthDisplay") as HealthDisplay
	var stats = root.find_child("Stats") as StatsDisplay
	blackjack_manager.player_hit.connect(p_h._on_blackjack_manager_player_hit)
	blackjack_manager.house_hit.connect(h_h._on_blackjack_manager_house_hit)
	player.dead.connect(_on_player_dead)
	player.health_changed.connect(hlth_d._on_health_change)

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


func on_ui_done():
	blackjack_manager.hands_locked = false


func _on_player_dead():
	get_tree().paused = true
	print_debug("Player Dead : Game Over!")
