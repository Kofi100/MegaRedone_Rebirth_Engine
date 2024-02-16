extends CharacterBody2D


@export var SPEED = 30000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	velocity.y=SPEED*delta
	move_and_slide()


func _on_detect_player_area_entered(area):
	pass # Replace with function body.
	if area.is_in_group('player_constants_checker_area2d'):
		pass
		area.get_parent().anim.play('spawn')
		area.get_parent().anim.visible=true
		queue_free()
