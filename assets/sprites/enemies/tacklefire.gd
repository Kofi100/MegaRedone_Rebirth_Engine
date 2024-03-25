extends enemy


const SPEED = 6000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	$AnimatedSprite2D.play('tacklefire')
	$go_back_and_delete_timer.start()
	state='left'

func _physics_process(delta):
	match state:
		'left':
			if $go_back_and_delete_timer.time_left>$go_back_and_delete_timer.wait_time/2:
				velocity.x=-SPEED*delta
			elif $go_back_and_delete_timer.time_left<$go_back_and_delete_timer.wait_time/2:
				velocity.x=SPEED*delta
		'right':
			if $go_back_and_delete_timer.time_left>$go_back_and_delete_timer.wait_time/2:
				velocity.x=SPEED*delta
			elif $go_back_and_delete_timer.time_left<$go_back_and_delete_timer.wait_time/2:
				velocity.x=-SPEED*delta
	move_and_slide()


func _on_go_back_and_delete_timer_timeout():
	queue_free()
