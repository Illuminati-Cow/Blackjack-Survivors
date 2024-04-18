extends Control

@onready var spawn_location = $SpawnLocation.position

@onready
var card_spritesheet : Texture2D = preload("res://assets/cards_spritesheet.png")
@export_range(0, 30)
var card_spread_angle : float = 15
@export_range(0.5, 3)
var card_scale : float = 1.5
@export_category("Animation Values")
@export_group("Card Fall Tween")
@export var fall_time : float = 0.5
@export var fall_drift : Vector2
@export var fall_scale : float = 1.5
@export_group("Card Shift Tween")
@export var shift_time : float = 0.25
var tween_lock := false

var _card_queue := []
var _cards := []

func _process(delta):
	if not _card_queue.is_empty():
		if not tween_lock:
			var card := _card_queue.pop_front() as Control
			_play_card_fall_tween(card)
			tween_lock = true
			if not _cards.is_empty():
				var tween = _cards.front().create_tween().set_parallel()
				for c in _cards:
					var s = min(shift_time + 0.05 * _cards.find(c), fall_time)
					c.z_index -= 1
					var end_rot = c.rotation - deg_to_rad(card_spread_angle)
					tween.tween_property(c, "rotation", end_rot, s)\
						.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			_cards.append(card)
	
	# Fix for new hand signal spam permanently locking tween_lock
	if _cards.is_empty() and tween_lock:
		tween_lock = false


func _play_card_fall_tween(card : Control):
	card.scale = Vector2(fall_scale, fall_scale)
	card.visible = true
	card.position = spawn_location + fall_drift
	var tween = card.create_tween().set_parallel()
	tween.tween_property(card, "position", spawn_location, fall_time)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "scale", Vector2(card_scale, card_scale), fall_time)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(
			func(): 
				tween_lock = false
				print("Unlocked")
	)


func suit_to_int(suit : Blackjack.Card.Suit) -> int:
	return Blackjack.Card.Suit.values()[suit]


func get_card_sprite(card : Blackjack.Card) -> Sprite2D:
	var suit := suit_to_int(card.suit)
	var rank := card.rank
	var card_sprite := Sprite2D.new()
	card_sprite.texture = card_spritesheet
	card_sprite.hframes = 13
	card_sprite.vframes = 5
	card_sprite.frame = suit * 13 + rank - 1
	return card_sprite

func create_card(sprite : Sprite2D) -> Control:
	var control = Control.new()
	add_child(control)
	control.add_child(sprite)
	control.pivot_offset = card_scale * Vector2(0, 80)
	control.visible = false
	return control


func _on_blackjack_manager_house_hit(card):
	print(card.rank)
	_card_queue.append(create_card(get_card_sprite(card)))


func _on_blackjack_manager_hands_cleared():
	for card in _card_queue:
		card.queue_free()
	_card_queue.clear()
	for card in _cards:
		var tween := card.create_tween().set_parallel() as Tween
		tween.tween_property(card, "position", card.position - Vector2(100, -500), 0.4)
		tween.tween_property(card, "rotation", rotation_degrees * 2, 0.4)
		tween.chain().tween_callback(card.queue_free)
	_cards.clear()
