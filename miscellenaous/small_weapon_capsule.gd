extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func _on_hitbox_body_entered(body):
	if body.is_in_group('player'):
		match GlobalScript.weapon_number:
			1:
				MegamanAndItems.weapon1energy+=3
			2:
				MegamanAndItems.weapon2energy+=3
		queue_free()
