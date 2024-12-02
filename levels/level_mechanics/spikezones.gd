extends enemy
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#node for spike pits
func _physics_process(delta):
	playerdamagevalue=5
