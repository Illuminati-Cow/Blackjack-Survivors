class_name PlayerStats extends Node

@export var projectileSpeed = 1400
@export var damage = 15
@export var projectileCount = 1
@export var playerSpeed = 500
@export var rateOfFire = 0.2
#@export var spread = 0

signal stat_change(int, float)

func _minorIncrease(hand):
	match (randi() % 4): #should be 0 through 4 (inclusive)
		0:
			_modifyShotSpeed(randi() % 5)
		1:
			_modifyDamage(randi() % 5)
		3:
			_modifyShotCount(randi() % 5)
		4:
			_modifyPlayerSpeed(randi() % 5)
		5:
			_modifyRateOfFire(randi() % 5)

func _minorDecrease(hand):
	match (randi() % 4): #should be 0 through 4 (inclusive)
		0:
			_modifyShotSpeed(-1*(randi() % 5))
		1:
			_modifyDamage(-1*(randi() % 5))
		3:
			_modifyShotCount(-1*(randi() % 5))
		4:
			_modifyPlayerSpeed(-1*(randi() % 5))
		5:
			_modifyRateOfFire(-1*(randi() % 5))
	print(projectileSpeed)
	print(damage)
	print(projectileCount)
	print(playerSpeed)
	print(rateOfFire)

func _modifyShotSpeed(mod):
	projectileSpeed += (0.04*projectileSpeed)*mod
	stat_change.emit(1, 100 + (100 * ((0.04*projectileSpeed)*mod)/1000))
	
func _modifyDamage(mod):
	if damage > 1:
		damage += 2*mod
		stat_change.emit(3, (100 + (100 * (2*mod)/damage)/10))

func _modifyShotCount(mod):
	projectileCount += (0.04*projectileCount)*mod
	stat_change.emit(0, 100 + (100 * ((0.04*projectileCount)*mod)/projectileCount)/2)

func _modifyPlayerSpeed(mod):
	playerSpeed += (0.04*playerSpeed)*mod
	
func _modifyRateOfFire(mod):
	if (rateOfFire - (0.08*rateOfFire)*mod) > 0:
		rateOfFire -= (0.08*rateOfFire)*mod
