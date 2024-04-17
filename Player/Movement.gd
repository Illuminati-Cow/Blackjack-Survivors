extends CharacterBody2D

@export var ProjectileScene : PackedScene
@export var fireCooldown = 0.25
var canShoot = true
@export var speed = 500

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	
func _process(_delta):
	#print($ShootCooldown.time_left)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot()	

func shoot():
	if not canShoot:
		return
	#ProjectileVars.speed += 100
	print("shooting projectile")
	canShoot = false
	$ShootCooldown.start()
	if ProjectileVars.projectileCount > 1.0:
		for i in floor(ProjectileVars.projectileCount):
			var p1 = ProjectileScene.instantiate()
			owner.add_child(p1)
			p1.transform = $Emitter.global_transform
			var min = $Emitter.global_transform.origin - Vector2(0, floor(ProjectileVars.projectileCount*20))
			var max = $Emitter.global_transform.origin + Vector2(0, floor(ProjectileVars.projectileCount*40))
			#from pentadecagon at https://stackoverflow.com/questions/20925175/evenly-distribute-x-values-within-a-given-range:
			p1.transform.origin = min + i*(max-min)/(floor(ProjectileVars.projectileCount)) #+ Vector2(0, 50*i)
			
	else:
		var p2 = ProjectileScene.instantiate()
		owner.add_child(p2)
		p2.transform = $Emitter.global_transform

func _on_shoot_cooldown_timeout():
	canShoot = true
