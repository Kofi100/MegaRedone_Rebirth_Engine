extends CharacterBody2D


const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var direction:int=1
##This sets the original direction of the first instance of the bullet
@export var initial_direction="left"

func _physics_process(delta):
	match initial_direction:
		"left":
			match direction:
				1:
					velocity=Vector2(-SPEED,0)
				2:
					velocity=Vector2(-SPEED,-SPEED)
				3:
					velocity=Vector2(-SPEED,SPEED)
		"right":
			match direction:
				1:
					velocity=Vector2(SPEED,0)
				2:
					velocity=Vector2(SPEED,-SPEED)
				3:
					velocity=Vector2(SPEED,SPEED)
	move_and_slide()
