extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var rad
func _physics_process(delta):
	playerdamagevalue=2
	if get_parent() is enemy:
		rad= 0.1#deg_to_rad(get_parent().dynamic_distance)
	if rad!=null and rad is float:
		#rotate(rad)
		pass
