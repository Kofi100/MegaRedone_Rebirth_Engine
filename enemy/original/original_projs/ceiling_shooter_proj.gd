extends enemy


@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var angle_to_go

func _physics_process(delta):
	playerdamagevalue=3
	velocity.y=sin(angle_to_go)*SPEED*delta
	velocity.x=cos(angle_to_go)*SPEED*delta
	move_and_slide()
#	if $VisibleOnScreenNotifier2D.is_on_screen()==false:
#		pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	pass # Replace with function body.
	queue_free()
