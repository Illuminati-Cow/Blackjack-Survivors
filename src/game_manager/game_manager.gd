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
@onready var win_text = root.find_child("WinLoseText") as WinLoseText
@onready var stats = root.find_child("Stats") as StatsDisplay
var waveNum := 1 as int

# Pause menu variables
@onready var pause_menu = root.get_node("PauseMenu") as PauseMenu
var paused = false


# Function to toggle pause state and display the pause menu
func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()


func toggle_pause():
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		show_pause_menu()
	else:
		hide_pause_menu()

		
func show_pause_menu():
	pause_menu.visible = true

	
func hide_pause_menu():
	pause_menu.visible = false


func _ready():
	# Connect UI to BlackjackManager
	var ui_root = root.find_child("UIRoot")
	var p_h = ui_root.get_node("%PlayerHand") as HandDisplay
	assert(p_h != null)
	var h_h = ui_root.get_node("%HouseHand") as HandDisplay
	assert(h_h != null)
	var hlth_d = ui_root.get_node("%HealthDisplay") as HealthDisplay
	assert(hlth_d != null)
	var stats = ui_root.get_node("%StatsText") as StatsDisplay
	assert(stats != null)
	var projectile_stats = root.find_child("Stats") as PlayerStats
	
	#region Signal Connections
	blackjack_manager.player_hit.connect(p_h._on_blackjack_manager_player_hit)
	assert(blackjack_manager.player_hit.is_connected(p_h._on_blackjack_manager_player_hit))
	
	blackjack_manager.house_hit.connect(h_h._on_blackjack_manager_house_hit)
	assert(blackjack_manager.house_hit.is_connected(h_h._on_blackjack_manager_house_hit))
	
	blackjack_manager.hands_cleared.connect(h_h._on_blackjack_manager_hands_cleared)
	assert(blackjack_manager.hands_cleared.is_connected(h_h._on_blackjack_manager_hands_cleared))
	
	blackjack_manager.hands_cleared.connect(p_h._on_blackjack_manager_hands_cleared)
	assert(blackjack_manager.hands_cleared.is_connected(p_h._on_blackjack_manager_hands_cleared))
	
	blackjack_manager.player_nat_blackjack.connect(win_text.player_nat_blackjack)
	assert(blackjack_manager.player_nat_blackjack.is_connected(win_text.player_nat_blackjack))
	
	blackjack_manager.player_blackjack.connect(win_text.player_blackjack)
	assert(blackjack_manager.player_blackjack.is_connected(win_text.player_blackjack))
	
	blackjack_manager.house_blackjack.connect(win_text.house_blackjack)
	assert(blackjack_manager.house_blackjack.is_connected(win_text.house_blackjack))
	
	blackjack_manager.player_busted.connect(win_text.player_bust)
	assert(blackjack_manager.player_busted.is_connected(win_text.player_bust))
	
	blackjack_manager.house_busted.connect(win_text.house_bust)
	assert(blackjack_manager.house_busted.is_connected(win_text.house_bust))
	
	blackjack_manager.player_won.connect(win_text.player_win)
	assert(blackjack_manager.house_busted.is_connected(win_text.house_bust))
	
	blackjack_manager.player_lost.connect(win_text.player_lost)
	assert(blackjack_manager.house_busted.is_connected(win_text.house_bust))
	
	blackjack_manager.tied.connect(win_text.tied)
	assert(blackjack_manager.house_busted.is_connected(win_text.house_bust))
	
	p_h.ui_done.connect(_on_ui_done)
	assert(p_h.ui_done.is_connected(_on_ui_done))
	
	h_h.ui_done.connect(_on_ui_done)
	assert(h_h.ui_done.is_connected(_on_ui_done))
	
	player.dead.connect(_on_player_dead)
	assert(player.dead.is_connected(_on_player_dead))
	
	player.health_changed.connect(hlth_d._on_health_change)
	assert(player.health_changed.is_connected(hlth_d._on_health_change))
	
	player.stand.connect(blackjack_manager._on_player_stand)
	assert(player.stand.is_connected(blackjack_manager._on_player_stand))
	
	pause_menu.resumed.connect(_on_resumed)
	assert(pause_menu.resumed.is_connected(_on_resumed))
	
	pause_menu.visible = false
	
	win_text.ui_done.connect(_on_ui_done)
	assert(win_text.ui_done.is_connected(_on_ui_done))
	#endregion
	await get_tree().create_timer(1).timeout 
	blackjack_manager.new_hands()
	#win_text.ui_done.connect(_on_ui_done)
	
	projectile_stats.stat_change.connect(stats._on_stat_change)
	_on_spawn_timer_timeout()
	


# Spawn a random enemy
func _on_spawn_timer_timeout():
	print(win_text)
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


func _spawn_big_enemy():
	var bigEnemy := big_enemy.instantiate() as Enemy #enemies.pick_random().instantiate() as CardEnemy
	bigEnemy.position = Vector2(randi_range(100, 1000), randi_range(100, 1000))
	bigEnemy.target = player
	root.add_child(bigEnemy)
	print("spawned big enemy")
	print(bigEnemy.position)


func _on_ui_done():
	print("ui done")
	if blackjack_manager.hands_locked:
		blackjack_manager.new_hands()


func _on_player_dead():
	get_tree().change_scene_to_file("res://scenes/GameEnd.tscn")
	
	
func _on_resumed():
	toggle_pause()
  
 
