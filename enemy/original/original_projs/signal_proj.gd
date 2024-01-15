extends enemy


@export var SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	playerdamagevalue=2
	match state:
		'down':
			velocity=Vector2i(0,SPEED)*delta
		'up':
			velocity=Vector2i(0,-SPEED)*delta
	move_and_slide()
