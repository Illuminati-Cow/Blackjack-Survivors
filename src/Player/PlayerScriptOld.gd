extends CharacterBody2D


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
@export var Projectile : PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print("shooting projectile")
		shoot()

func shoot():
	var b = Projectile.instantiate()
	owner.add_child(b)
	b.transform = $Emitter.global_transform
