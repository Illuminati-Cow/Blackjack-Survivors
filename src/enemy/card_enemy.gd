class_name CardEnemy extends Enemy

# Signals
signal death_draw(card : Blackjack.Card)

var card : Blackjack.Card

func set_card(new_card : Blackjack.Card):
	card = new_card	
	_set_card_texture(new_card)
	#TODO Set card sprite based on suit / rank

func suit_to_int(suit : Blackjack.Card.Suit) -> int:
	return Blackjack.Card.Suit.values()[suit]


func _set_card_texture(card : Blackjack.Card):
	var suit := suit_to_int(card.suit)
	var rank := card.rank
	var sprite = $Sprite2D as Sprite2D
	sprite.frame = suit * 13 + rank - 1
	
	
func _on_dead(damage : int):
	death_draw.emit(card)
	queue_free()

func _draw():
	if not card:
		return
	if debug_mode:
		super._draw()
		var suit = Blackjack.Card.Suit.keys()[card.suit]
		var rank := card.rank as int
		draw_string(default_font, Vector2(35, -40), suit + ", " + str(rank),
					HORIZONTAL_ALIGNMENT_CENTER, 80, 12)
