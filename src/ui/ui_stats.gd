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
	BulletStat.COUNT : $BulletCount.text,
	BulletStat.SPEED : $BulletSpeed.text,
	BulletStat.SPREAD : $BulletSpread.text,
	BulletStat.DAMAGE : $BulletDamage.text,
}


func _on_stat_change(stat : BulletStat, new_value : float):
	_stats[stat] = format_string % new_value
	print("_stats[stat] is:")
	print (_stats[stat])
