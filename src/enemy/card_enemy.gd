class_name CardEnemy extends Enemy

# Signals
signal death_draw(card : Blackjack.Card)

var card : Blackjack.Card

func set_card(new_card : Blackjack.Card):
	card = new_card	
	#TODO Set card sprite based on suit / rank

func _on_dead(damage : int):
	death_draw.emit(card)
	queue_free()

func _draw():
	super._draw()
	if not card:
		return
	var suit = Blackjack.Card.Suit.keys()[card.suit]
	var rank := card.rank as int
	draw_string(default_font, Vector2(35, -40), suit + ", " + str(rank),
				HORIZONTAL_ALIGNMENT_CENTER, 80, 12)
