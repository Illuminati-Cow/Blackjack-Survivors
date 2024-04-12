extends CharacterBody2D

const GRAVITY = 200.0
const WALK_SPEED = 200
@export var ProjectileScene : PackedScene
@export var fireCooldown = 0.25
var canShoot = true

func _ready():
	start()

func start():
	$ShootCooldown.wait_time = fireCooldown

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
	print($ShootCooldown.time_left)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print("shooting projectile")
		shoot()

func shoot():
	if not canShoot:
		return
	ProjectileVars.speed += 100
	canShoot = false
	$ShootCooldown.start()
	var b = ProjectileScene.instantiate()
	owner.add_child(b)
	b.transform = $Emitter.global_transform

func _on_shoot_cooldown_timeout():
	canShoot = true
