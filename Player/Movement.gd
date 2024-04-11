extends CharacterBody2D

const GRAVITY = 200.0
const WALK_SPEED = 200

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
