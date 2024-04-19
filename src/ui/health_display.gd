class_name HealthDisplay extends TextureRect

@export var _tx_size : Vector2i

func _on_health_change(new_health : int):
	assert(new_health >= 0 and new_health <= 13)
	_update_health_card(new_health)


#func _update_health_card(health : int):
	#var txr := texture as AtlasTexture
	#if health == 0:
		#txr.region.size = Vector2i.ZERO
		#return
	#else:
		#txr.region.size = _tx_size
		#
	#var x = txr.region.size.x * (health - 1)
	#var y = txr.region.size.y
	#txr.region = Rect2i(Vector2i(x, y), txr.region.size)


func _update_health_card(health : int):
	var txr := texture as AtlasTexture
	if health == 0:
		txr.region = Rect2i(Vector2i.ZERO, Vector2i.ZERO)
		return
	else:
		var x = _tx_size.x * (health - 1)
		var y = 0  # Assuming y starts at 0, adjust if necessary
		txr.region = Rect2i(Vector2i(x, y), _tx_size)
