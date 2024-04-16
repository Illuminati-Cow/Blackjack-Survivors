extends Area2D


signal damaged_enemy(damage)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position += transform.x * ProjectileVars.speed * delta
	if position > Vector2(GlobalVars.StageSizeX, GlobalVars.StageSizeY):
		print("projectile reached edge of stage, deleting")
		queue_free()

func _on_Projectile_body_entered(body):
	#print(body)
	var bodyHealth = find_child("Health")#get_node("root/CardEnemy/Health")
	#print(bodyHealth)
	if body.has_meta("Player") != true: #bodyHealth != null && 
		#emit_signal("damaged_enemy", -1*ProjectileVars.damage)
		bodyHealth.modify_health()
		#print(bodyHealth)
		if bodyHealth <=0:
			body.queue_free()
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
	
	
