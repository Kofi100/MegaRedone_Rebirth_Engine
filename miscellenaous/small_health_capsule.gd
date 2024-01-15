extends RigidBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_hitbox_body_entered(body):
	if body.is_in_group('player'):
		GlobalScript.health+=3
		queue_free()
