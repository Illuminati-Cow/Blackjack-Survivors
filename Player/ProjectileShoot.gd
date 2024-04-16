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
	var bodyHealth : Health = body.find_child("Health")
	bodyHealth.modify_health(-10)
	queue_free()
