class_name Player extends CharacterBody2D

# Signal
signal dead
signal health_changed(current_health : int)
signal stand


@onready var health := $Health as Health
@export var stats : PlayerStats
@export var ProjectileScene : PackedScene
@onready
var invinc_timer = $InvincibilityTimer
var spread = 0.6
var canShoot = true
var _invincible = false


func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * stats.playerSpeed


func _physics_process(delta):
	look_at(get_global_mouse_position())
	get_input()
	move_and_slide()
	
	
func _process(_delta):
	#print($ShootCooldown.time_left)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot()
	if Input.is_action_just_pressed("stand"):#Input.mouse_butt (MOUSE_BUTTON_RIGHT):
		stand.emit()


func shoot():
	if not canShoot:
		return
	#get_node("../Stats").speed += 100
	print("shooting projectile")
	canShoot = false
	$ShootCooldown.start()
	if get_node("../Stats").projectileCount >= 2.0:
		for i in floor(get_node("../Stats").projectileCount):
			var p1 = ProjectileScene.instantiate()
			owner.add_child(p1)
			p1.transform = $Emitter.global_transform
			p1.transform = (p1.transform).looking_at(get_global_mouse_position())
			var min = -spread#p1.transform.rotated(spread)#$Emitter.global_transform.origin - Vector2(0, floor(get_node("../Stats").projectileCount*20))
			var max = spread#p1.transform.rotated(-spread)#$Emitter.global_transform.origin + Vector2(0, floor(get_node("../Stats").projectileCount*40))
			#from pentadecagon at https://stackoverflow.com/questions/20925175/evenly-distribute-x-values-within-a-given-range:
			p1.transform = p1.transform.rotated_local(min + i*(max-min)/(floor(get_node("../Stats").projectileCount))) #+ Vector2(0, 50*i)
			#print(min + (i+1)*(max-min)/(floor(get_node("../Stats").projectileCount + 1)))
			print(p1.transform.get_rotation())
			
	else:
		var p2 = ProjectileScene.instantiate()
		owner.add_child(p2)
		p2.transform = $Emitter.global_transform


func _on_shoot_cooldown_timeout():
	canShoot = true


func _on_hurtbox_body_entered(body):
	if not _invincible:
		health.modify_health(-1)
		invinc_timer.start()
		modulate = Color.CRIMSON
		_invincible = true
		health_changed.emit(1)


func _on_invincibility_timer_timeout():
	_invincible = false
	modulate = Color.WHITE


func _on_health_dead(damage):
	dead.emit()
