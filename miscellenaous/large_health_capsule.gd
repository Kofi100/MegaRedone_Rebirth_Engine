extends RigidBody2D
@onready var delete_spawnable_timer = $delete_spawnable_timer

@onready var animation_player = $AnimationPlayer
var blink_timer:float=0
const JUMP_VELOCITY = -400.0

func _ready():
	#animation_player.set_autoplay('active')
	pass
	
func _process(delta):
	if delete_spawnable_timer.time_left>0 and delete_spawnable_timer.time_left<delete_spawnable_timer.wait_time/2:
		blink_timer+=1*delta
		if fmod(blink_timer,0.2)>0.1:
			$Sprite2D.visible=true
		elif fmod(blink_timer,0.2)<0.1:
			$Sprite2D.visible=false

func _on_hitbox_body_entered(body):
	pass # Replace with function body.
	if body.is_in_group('player'):
		GlobalScript.health+=10
		queue_free()


func _on_delete_spawnable_timer_timeout():
	pass # Replace with function body.
	queue_free()
