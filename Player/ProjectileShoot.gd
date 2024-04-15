extends Area2D





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position += transform.x * ProjectileVars.speed * delta
	if position > Vector2(GlobalVars.StageSizeX, GlobalVars.StageSizeY):
		print("projectile reached edge of stage, deleting")
		queue_free()

func _on_Projectile_body_entered(body):
		#body.queue_free()
	var bodyHealth = find_child("Health")
	if bodyHealth != null:
		bodyHealth.modify_health(-1*ProjectileVars.Damage)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
	
	
