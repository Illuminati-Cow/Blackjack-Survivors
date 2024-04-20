class_name PlayerStats extends Node

@export var projectileSpeed = 1000
@export var damage = 10
@export var projectileCount = 2
@export var playerSpeed = 500
@export var rateOfFire = 0.25
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
	projectileSpeed += (0.02*projectileSpeed)*mod
	stat_change.emit(1, (0.02*projectileSpeed)*mod)
	
func _modifyDamage(mod):
	if damage > 1:
		damage += 1*mod
		stat_change.emit(3, 1*mod)

func _modifyShotCount(mod):
	projectileCount += (0.02*projectileCount)*mod
	stat_change.emit(0, (0.02*projectileCount)*mod)

func _modifyPlayerSpeed(mod):
	playerSpeed += (0.02*playerSpeed)*mod
	
func _modifyRateOfFire(mod):
	rateOfFire -= (0.04*rateOfFire)*mod
