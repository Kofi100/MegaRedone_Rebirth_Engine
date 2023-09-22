extends enemy


const SPEED = 14000.0
const JUMP_VELOCITY = -400.0
var direction="left"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	playerdamagevalue=2

func _physics_process(delta):
	match direction:
		"left":
			velocity.x=-SPEED*delta
		"right":
			velocity.x=SPEED*delta
			
	move_and_slide()


func _on_hitbox_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("tilemaps"):
		queue_free()
