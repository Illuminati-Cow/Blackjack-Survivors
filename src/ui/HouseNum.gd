extends RichTextLabel
var rank = 0
var rankStr

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_blackjack_manager_house_hit(card):
	rank += card.rank
	rankStr = str(rank)
	print(card.rank)
	#var valueStr = str((get_node("../../../../BlackjackManager")).Hand.value())
	text = rankStr

func _on_blackjack_manager_hands_cleared():
	rank = 0
	rankStr = str(rank)
	text = rankStr



