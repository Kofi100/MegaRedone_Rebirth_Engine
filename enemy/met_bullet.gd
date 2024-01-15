extends enemy


@export var SPEED = 15000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
##This value sets the case of the direction is going to fire at.
@export var direction:int=1
##This sets the original direction of the first instance of the bullet
@export var initial_direction="left"

func _ready():
	playerdamagevalue=3

func _physics_process(delta):
	match initial_direction:
		"left":
			match direction:
				1:
					velocity=Vector2(-SPEED,0)*delta
				2:
					velocity=Vector2(-SPEED,-SPEED)*delta
				3:
					velocity=Vector2(-SPEED,SPEED)*delta
		"right":
			match direction:
				1:
					velocity=Vector2(SPEED,0)*delta
				2:
					velocity=Vector2(SPEED,-SPEED)*delta
				3:
					velocity=Vector2(SPEED,SPEED)*delta
	move_and_slide()


func _on_hitbox_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("tilemaps"):
		queue_free()
