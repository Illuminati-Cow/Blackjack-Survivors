class_name Enemy extends CharacterBody2D

# Public properties
@export_category("Movement")
@export var max_speed : float
@export var max_force : float
@export var mass : float
@export_category("Combat")
@export_range(0, 5) var hit_stun_s : float
@export_color_no_alpha var hit_color : Color
var _hit_stun_timer : Timer = Timer.new()
@export_category("Debug")
@export var debug_mode : bool = false
# TESTING: REMOVE THIS
@export var target : CharacterBody2D = null
var default_font : Font = ThemeDB.fallback_font;
# Components
@onready
var _health_component : Health = $Health
@onready
var _animation_player : AnimationPlayer = $AnimationPlayer
@onready
var _hitbox = $Hitbox
#const MIN_PLAYBACK_SPEED = 0.3
#const MAX_PLAYBACK_SPEED = 1
@onready
var _steering_manager : Steering_Manager = Steering_Manager.new(
	self, 
	max_speed, 
	max_force, 
	mass
)

func _ready():
	_animation_player.play("walk")
	add_child(_hit_stun_timer)
	_hit_stun_timer.one_shot = true
	_hit_stun_timer.wait_time = hit_stun_s
	_hit_stun_timer.timeout.connect(_on_hit_stun_timer_timeout)
	
func _physics_process(delta):
	if target != null and _hit_stun_timer.is_stopped():
		_steering_manager.pursue(target)
	_steering_manager.move(delta)
	if debug_mode:
		queue_redraw()
	interpolate_walk_animation()

func interpolate_walk_animation():
	_animation_player.speed_scale = lerpf(0, 0.7, velocity.length() / max_speed)

func _draw():
	if not debug_mode:
		return
	var speed = str(floor(velocity.length()))
	if target != null:
		draw_string(default_font, Vector2(50, -10), speed,
				HORIZONTAL_ALIGNMENT_CENTER, 40, 18)

# Signal Receivers
func _on_hit_stun_timer_timeout():
	modulate = Color.WHITE
	_hitbox.set_deferred("monitoring", true)

func _on_dead(damage : int):
	queue_free()

func _on_healed(amount : int):
	print_debug("Healed: ", amount)
	pass

func _on_damaged(amount : int):
	print_debug("Damaged: ", amount)
	pass


func _on_hitbox_body_entered(body):
	if body == target and _hit_stun_timer.is_stopped():
		_hit_stun_timer.start()
		modulate = hit_color
		_hitbox.set_deferred("monitoring", false)
