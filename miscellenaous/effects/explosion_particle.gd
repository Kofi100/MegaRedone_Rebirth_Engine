extends CharacterBody2D

@export_category('values')
@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export_category('states')
@export var state= 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D


func _physics_process(delta):
	animated_sprite_2d.play('explosion')
	# Add the gravity.
	match state:
		1:
			velocity.x=SPEED*delta
		2:
			velocity.x=-SPEED*delta
		3:
			velocity.y=SPEED*delta
		4:
			velocity.y=-SPEED*delta
		5:
			velocity.x=SPEED*delta
			velocity.y=SPEED*delta
		6:
			velocity.x=-SPEED*delta
			velocity.y=SPEED*delta
		7:
			velocity.x=SPEED*delta
			velocity.y=-SPEED*delta
		8:
			velocity.x=-SPEED*delta
			velocity.y=-SPEED*delta

	move_and_slide()
