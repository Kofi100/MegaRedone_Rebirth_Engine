extends RigidBody2D
@onready var delete_spawnable_timer = $delete_spawnable_timer


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var blink_timer:float=0
func _process(delta):
	if delete_spawnable_timer.time_left<delete_spawnable_timer.wait_time/2:
		blink_timer+=1*delta
		#print(name,': [small_hcapsule:timer:]',timer)
		#print(name,': [small_hcapsule:fmod(timer,0.2):]',fmod(timer,0.2))
		if fmod(blink_timer,0.2)>0.1:
			$Sprite2D.visible=true
		elif fmod(blink_timer,0.2)<0.1:
			$Sprite2D.visible=false


func _on_hitbox_body_entered(body):
	if body.is_in_group('player'):
		GlobalScript.health+=3
		queue_free()


func _on_delete_spawnable_timer_timeout():
	pass # Replace with function body.
	queue_free()
