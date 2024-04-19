class_name HandDisplay extends Control

signal ui_done

@onready var spawn_location = $SpawnLocation.position

@onready
var card_spritesheet : Texture2D = preload("res://assets/cards_spritesheet.png")
@export 
var is_player = false
@export
var texture_region_size : Vector2i = Vector2i(65, 80)
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

var _tween_lock := false
var _card_queue := []
var _cards := []
var _hand_over = false


func _process(delta):
	if not _card_queue.is_empty():
		if not _tween_lock:
			var card := _card_queue.pop_front() as TextureRect
			_play_card_fall_tween(card)
			_tween_lock = true
			if not _cards.is_empty():
				var tween = _cards.front().create_tween().set_parallel()
				for c : TextureRect in _cards:
					var s = min(shift_time + 0.05 * _cards.find(c), fall_time)
					c.z_index -= 1
					var end_rot = c.rotation_degrees - card_spread_angle
					tween.tween_property(c, "rotation_degrees", end_rot, s)\
						.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			_cards.append(card)
	
	# Fix for new hand signal spam permanently locking tween_lock
	if _cards.is_empty() and _tween_lock:
		_tween_lock = false
	
	if _hand_over and _card_queue.is_empty():
		await get_tree().create_timer(0.5).timeout
		ui_done.emit()


func _play_card_fall_tween(card : TextureRect):
	card.scale = Vector2(fall_scale, fall_scale)
	card.visible = true
	card.position = spawn_location + fall_drift
	var tween = card.create_tween().set_parallel()
	tween.tween_property(card, "position", spawn_location, fall_time)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "scale", Vector2(card_scale, card_scale), fall_time)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(func(): _tween_lock = false)


func suit_to_int(suit : Blackjack.Card.Suit) -> int:
	return Blackjack.Card.Suit.values()[suit]


func get_card_texture(card : Blackjack.Card) -> AtlasTexture:
	var suit := suit_to_int(card.suit)
	var rank := card.rank
	var texture := AtlasTexture.new()
	texture.atlas = card_spritesheet
	var x = texture_region_size.x * (rank - 1)
	var y = texture_region_size.y * suit
	texture.region = Rect2i(Vector2i(x,y), texture_region_size)
	return texture


func create_card(texture : Texture2D) -> TextureRect:
	var t_r = TextureRect.new()
	t_r.texture = texture
	add_child(t_r)
	t_r.pivot_offset = Vector2(0, card_scale * texture_region_size.y)
	t_r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	t_r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t_r.custom_minimum_size = texture_region_size
	t_r.visible = false
	return t_r


func _on_blackjack_manager_house_hit(card, hand_value):
	if not is_player:
		_card_queue.append(create_card(get_card_texture(card)))
		$ScoreText.text = str(hand_value as int)


func _on_blackjack_manager_player_hit(card, hand_value):
	if is_player:
		_card_queue.append(create_card(get_card_texture(card)))
		$ScoreText.text = str(hand_value as int)


func _on_hand_over():
	_hand_over = true


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
