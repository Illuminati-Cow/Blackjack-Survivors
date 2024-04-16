extends CharacterBody2D

const GRAVITY = 200.0
const WALK_SPEED = 200
@export var ProjectileScene : PackedScene
#@export var fireCooldown = 0.25
var canShoot = true

func _ready():
	start()

func start():
	$ShootCooldown.wait_time = ProjectileVars.rateOfFire

func _physics_process(delta):

	if Input.is_action_pressed("ui_up"):
		velocity.y -= WALK_SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y += WALK_SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0
		velocity.y = 0

	# "move_and_slide" already takes delta time into account.
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
