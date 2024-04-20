class_name StatsDisplay extends Control


enum BulletStat {
	COUNT,
	DAMAGE,
	SPEED,
	SPREAD,
}

const format_string = "%3.1f%%"


@onready
var _stats = {
	BulletStat.COUNT : $BulletCount,
	BulletStat.SPEED : $BulletSpeed,
	BulletStat.SPREAD : $BulletSpread,
	BulletStat.DAMAGE : $BulletDamage,
}


func _on_stat_change(stat : BulletStat, new_value : float):
	_stats[stat].text = format_string % new_value
	print("_stats[stat] is:")
	print (_stats[stat])
