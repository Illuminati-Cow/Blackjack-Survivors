extends RichTextLabel

signal ui_done

# Called when the node enters the scene tree for the first time.
func _ready():
	$WinLoseTextBox.text = ""
	$WinLoseTextBox.add_theme_font_size_override("normal_font_size", 24)


func house_bust(arg):
	$WinLoseTextBox.text = "HOUSE BUST"
	ui_done.emit()
	await get_tree().create_timer(1).timeout
	$WinLoseTextBox.text =""

func house_blackjack(arg):
	$WinLoseTextBox.text = "HOUSE WIN"
	ui_done.emit()
	await get_tree().create_timer(1).timeout
	$WinLoseTextBox.text =""
	
func player_bust(arg):
	$WinLoseTextBox.text = "YOU BUST"
	ui_done.emit()
	await get_tree().create_timer(1).timeout
	$WinLoseTextBox.text =""

func player_win(arg):
	$WinLoseTextBox.text = "YOU WIN"
	ui_done.emit()
	await get_tree().create_timer(1).timeout
	$WinLoseTextBox.text =""

func player_lost(arg):
	$WinLoseTextBox.text = "YOU LOSE"
	await get_tree().create_timer(1).timeout
	$WinLoseTextBox.text =""

func tied(arg):
	$WinLoseTextBox.text = "TIE"
	await get_tree().create_timer(1).timeout
	$WinLoseTextBox.text =""

func player_nat_blackjack(arg):
	$WinLoseTextBox.text = "BLACKJACK!"
	await get_tree().create_timer(1).timeout
	$WinLoseTextBox.text =""
