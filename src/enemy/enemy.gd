class_name Enemy extends CharacterBody2D

# Public properties
@export var max_speed : float
@export var max_force : float
@export var mass : float

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
	_steering_manager.seek(get_global_mouse_position())
	_steering_manager.move(delta)
