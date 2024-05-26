class_name VelocityComponent
extends Node

@export var actor : CharacterBody2D
@export var max_speed : float
@export var acceleration_coefficient : float

var velocity : Vector2
var velocity_override : Vector2
var speed_multiplier : float = 1

var calculated_max_speed : float :
	get: return max_speed * speed_multiplier
	
func override_velocity(override):
	velocity_override = override

func accelerate_to_velocity(new_velocity : Vector2):
	velocity = velocity.lerp( new_velocity, 1 - exp( -(acceleration_coefficient / 10) ) )

func accelerate_in_direction(direction : Vector2):
	accelerate_to_velocity(direction.normalized() * calculated_max_speed)

func decelerate():
	accelerate_to_velocity(Vector2.ZERO)

func halt():
	velocity = Vector2.ZERO

func freeze(seconds : float):
	override_velocity(Vector2.ZERO)
	get_tree().create_timer(seconds).timeout.connect(override_velocity(null))

func move():
	if velocity_override == null:
		actor.Velocity = velocity
	else:
		actor.Velocity = velocity_override
	actor.move_and_slide()
