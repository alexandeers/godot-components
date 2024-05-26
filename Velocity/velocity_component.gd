@tool 
@icon("res://assets/icons/icon_velocity.svg")
class_name VelocityComponent extends Node

# CONFIGURATION
@export var actor: CharacterBody2D = null
@export var max_speed: float = 100
@export var acceleration_coefficient: float = 2

# VARIABLES
var velocity : Vector2
var velocity_override : Vector2
var speed_multiplier : float = 1
var calculated_max_speed : float :
	get: return max_speed * speed_multiplier
	
# FUNCTIONS
func override_velocity(override):
	velocity_override = override
	
func accelerate_to_velocity(new_velocity : Vector2):
	var acceleration = 1 - exp(-acceleration_coefficient / 10)
	velocity = velocity.lerp(new_velocity * speed_multiplier, acceleration)
	
func accelerate_in_direction(direction : Vector2) -> VelocityComponent:
	accelerate_to_velocity(direction.normalized() * calculated_max_speed)
	return self
	
func decelerate():
	accelerate_to_velocity(Vector2.ZERO)
	
func halt():
	velocity = Vector2.ZERO
	
func freeze(seconds : float):
	override_velocity(Vector2.ZERO)
	get_tree().create_timer(seconds).timeout.connect(override_velocity(Vector2.INF))
	
func move():
	actor.velocity = velocity
	actor.move_and_slide()
	
# EDITOR
func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	if actor == null:
		warnings.append("Actor is not set. This component is non-functional without an actor set.")
	if max_speed == 0 or acceleration_coefficient == 0:
		warnings.append("Max_Speed or Acceleration_Coefficient is set to 0. Actor won't move.")
	return warnings
