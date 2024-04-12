extends Area2D

@export var speed: int
@export var damage: int
@export var ROF: int
var lastShot: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position += transform.x * speed * delta
	#if position > 

func _on_Projectile_body_entered(body):
	if body.is_in_group("mobs"):
		#body.queue_free()
		body.hp -= $Projectile.Damage
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
	
	
