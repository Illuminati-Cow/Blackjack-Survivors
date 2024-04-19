class_name HealthDisplay extends TextureRect

var _tx_size : Vector2i

func _on_health_change(new_health : int):
	assert(new_health >= 0 and new_health <= 13)
	_update_health_card(new_health)


func _update_health_card(health : int):
	if health == 0:
		texture.region.size = Vector2i.ZERO
		return
	else:
		texture.region.size = _tx_size
		
	var txr := texture as AtlasTexture
	var x = txr.region.size.x * (health - 1)
	var y = txr.region.size.y
	txr.region = Rect2i(Vector2i(x, y), txr.region.size)
