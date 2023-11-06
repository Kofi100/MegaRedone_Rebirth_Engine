extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	health=5
	playerdamagevalue=4
	#enemyreceivedamagevalue=3

func _physics_process(delta):
	spawn_collectables()
	if health<=0:
		get_parent().queue_free()
	#move_and_slide()
