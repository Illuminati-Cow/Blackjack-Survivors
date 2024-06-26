class_name Blackjack extends Node

# Cole Falxa-Sturken 4/15/2024

#region Signals
signal house_hit(card : Card, hand_value : int)
signal house_blackjack
signal house_busted
#signal house_stand
signal player_busted
signal player_nat_blackjack
signal player_blackjack
signal player_hit(card : Card, hand_value : int)
signal player_won(hand_value : int)
signal player_lost(hand_value : int)
signal tied
signal hands_cleared()
#endregion

enum HandState {
	PLAYING,
	STANDING,
	BUST,
	BLACKJACK,
	NATURAL_BLACKJACK,
}

const ACE_HIGH := 11
const ACE_LOW := 1
const FACE_VALUE := 10
const bj_number_increment := 10
const nat_bj_card_count_increment := 1
const house_stand_num_increment := 10

static var blackjack_number := 21
static var nat_bj_card_count := 2
static var house_stand_num := 17

var deck : Deck
var house_hand : Hand
var player_hand : Hand
var hands_locked : bool = false


class Card:
	enum Suit {
		Spades,
		Hearts,
		Clubs,
		Diamonds
	}
	var suit : Suit
	var rank : int
	
	func _init(_suit : Suit, _rank : int):
		suit = _suit
		rank = _rank
		
	func _to_string() -> String:
		return str(rank) + " " + str(Suit.keys()[suit])

		
class Hand:
	var _cards : Array[Card] = []
	
	func clear() -> void:
		_cards.clear()
	
	
	func add(card : Card) -> void:
		_cards.append(card)
	
	
	func count() -> int:
		return _cards.size()
	
	
	func get_cards() -> Array[Card]:
		return _cards.duplicate()
	
	
	func value() -> int:
		if _cards.size() == 0:
			return 0
		# If no ace then simple sum
		if _filter_aces(_cards).size() == 0:
			return _basic_sum_hand(_cards)
		else:
			var aces := _filter_aces(_cards)
			# Sum all cards but aces
			var sum := _basic_sum_hand(_filter_aces(_cards, true))
			# Sum Aces optimally to check for Blackjack
			var bj_number = Blackjack.blackjack_number
			for i in range(aces.size()):
				var low_sum := sum + Blackjack.ACE_LOW
				var high_sum := sum + Blackjack.ACE_HIGH
				if low_sum < bj_number or i == aces.size() - 1 and high_sum == bj_number:
					sum = high_sum
				else:
					sum = low_sum
			return sum
	
	
	func _to_string() -> String:
		var out : String = ""
		for card in _cards:
			out += card._to_string() + "  "
		return out
	
	
	func _filter_aces(hand : Array[Card], inverted : bool = false) -> Array[Card]:
		if hand.size() == 0:
			return []
		return hand.filter(func(e : Card): return e.rank == 1 if not inverted else e.rank != 1)
	

	func _basic_sum_hand(hand : Array[Card]) -> int:
		var out := 0
		if hand.size() == 0:
			return out
		for card : Card in hand:
			out += min(card.rank, FACE_VALUE)
		return out


class Deck:
	var cards : Array[Card] = []
	
	func _init():
		cards = _create_deck()
		shuffle()
		
	func count() -> int:
		return cards.size()
	
	func shuffle(shuffle_count : int = 3) -> void:
		for i in range(shuffle_count):
			cards.shuffle()
	
	func shuffle_in(deck : Array[Card]) -> void:
		cards.append_array(deck)
		shuffle()
	
	func draw_card() -> Card:
		if count() == 0:
			shuffle_in(_create_deck())
		return cards.pop_at(randi_range(0, count() - 1))
		
	func _create_deck() -> Array[Card]:
		var deck : Array[Card] = []
		for suit in Card.Suit.values():
			for rank in range(1, 14):
				deck.append(Card.new(suit, rank))
		return deck


func _ready():
	deck = Deck.new()
	player_hand = Hand.new()
	house_hand = Hand.new()
	new_hands()

# Empties both hands and draws the house's hand
# NOTE: Also unlocks both hands
func new_hands() -> void:
	hands_locked = false
	player_hand.clear()
	house_hand.clear()
	hands_cleared.emit()
	# Draw house's hand
	var hand_vals := _draw_house_hand()
	# Prevent house from getting a Natural Blackjack
	var eval = _eval_hand(house_hand)
	while eval == HandState.NATURAL_BLACKJACK:
		house_hand.clear()
		hand_vals = _draw_house_hand()
		eval = _eval_hand(house_hand)
	var house_cards : Array[Card] = house_hand.get_cards()
	if eval == HandState.BUST:
		print(house_hand)
		hands_locked = true
		house_busted.emit()
	if eval == HandState.BLACKJACK:
		print(house_hand)
		hands_locked = true
		house_blackjack.emit()
	for card : Card in house_cards:
		house_hit.emit(card, hand_vals.pop_front())


func draw() -> Card:
	return deck.draw_card()


static func increment_bj_number():
	blackjack_number += bj_number_increment
	nat_bj_card_count += nat_bj_card_count_increment
	house_stand_num += house_stand_num_increment


#region Signal Receivers
func _on_death_draw(card : Card):
	if hands_locked:
		return
		
	player_hand.add(card)
	player_hit.emit(card, player_hand.value())
	match _eval_hand(player_hand):
		HandState.NATURAL_BLACKJACK:
			hands_locked = true
			player_nat_blackjack.emit()
		HandState.BLACKJACK:
			hands_locked = true
			player_blackjack.emit()
		HandState.BUST:
			hands_locked = true
			player_busted.emit()
	# Check for marginal victory if obvious victory not present
	# NOTE: Assumes that house draws full hand before player


func _on_player_stand():
	if hands_locked:
		return
		
	match _compare_hands(player_hand, house_hand):
		1:
			print("won!")
			player_won.emit(player_hand.value())
		0:
			print("tie")
			tied.emit()
		-1:
			print("lost")
			player_lost.emit(player_hand.value())
	hands_locked = true
#endregion


func _eval_hand(hand : Hand) -> HandState:
	var val = hand.value()
	match val:
		blackjack_number when hand.count() == nat_bj_card_count:
			return HandState.NATURAL_BLACKJACK
		blackjack_number:
			return HandState.BLACKJACK
		_ when val > blackjack_number:
			return HandState.BUST
		_ when val >= house_stand_num:
			return HandState.STANDING
		_:
			return HandState.PLAYING


# Returns 1 if hand A won, 0 for tie, and -1 if hand B won
func _compare_hands(hand_a : Hand, hand_b : Hand):
	var a_val = hand_a.value()
	var b_val = hand_b.value()
	return 1 if a_val > b_val else 0 if a_val == b_val else -1


# NOTE: Assumes that house draws until stand or win/loss
# Returns an array of hand values where each index is the value after each draw
func _draw_house_hand() -> Array[int]:
	var hand_values : Array[int] = []
	while _eval_hand(house_hand) == HandState.PLAYING:
		house_hand.add(deck.draw_card())
		hand_values.append(house_hand.value())
	return hand_values
