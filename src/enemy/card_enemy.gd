class_name Card_Enemy extends Enemy

# Signals
signal death_draw(card : Blackjack.Card)

var card : Blackjack.Card

func _init(_card : Blackjack.Card):
	card = _card
	
	#TODO Set card sprite based on suit / rank

func _on_dead(damage : int):
	death_draw.emit(card)
	queue_free()
