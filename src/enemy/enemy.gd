class_name Enemy extends CharacterBody2D

# Public properties
@export_category("Movement")
@export var max_speed : float
@export var max_force : float
@export var mass : float
@export_category("Debug")
@export var debug_mode : bool = false
# TESTING: REMOVE THIS
@export var target : CharacterBody2D = null
var default_font : Font = ThemeDB.fallback_font;
# Components
@onready
var _health_component : Health = $Health
@onready
var _steering_manager : Steering_Manager = Steering_Manager.new(
	self, 
	max_speed, 
	max_force, 
	mass
)

func _physics_process(delta):
	if target != null:
		_steering_manager.pursue(target)
	var collisions = _steering_manager.move(delta)
	if debug_mode:
		queue_redraw()

func _draw():
	if not debug_mode:
		return
	var speed = str(floor(velocity.length()))
	draw_string(default_font, Vector2(20, -10), speed,
				HORIZONTAL_ALIGNMENT_CENTER, 40, 18)
	if target != null:
		draw_string(default_font, Vector2(20, -10), speed,
				HORIZONTAL_ALIGNMENT_CENTER, 40, 18)
