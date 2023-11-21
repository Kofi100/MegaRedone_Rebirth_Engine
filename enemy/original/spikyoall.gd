extends enemy

@export_category('variables')
@export var SPEED = 300.0
@export var speed_up=5000
const JUMP_VELOCITY = -400.0
@export var normalspeed=3000
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	playerdamagevalue=2
	health=5
	SPEED=normalspeed
var distance;var timer=0
func _physics_process(delta):
	distance=GlobalScript.playerposx-global_position.x
	velocity.x=SPEED*delta
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#check for hole and move away from it
	if not $check_for_hole_left.is_colliding() and not is_on_wall():
		SPEED=abs(SPEED)
	if not $check_for_hole_right.is_colliding() and not is_on_wall():
		SPEED=-abs(SPEED)
	#print(timer)
	#check if you're on the wall,and move away from it
	if is_on_wall():
		timer+=1*delta
		if timer>0.1:
			if SPEED==-abs(SPEED):
				SPEED=abs(SPEED)
			elif SPEED==abs(SPEED):
				SPEED=-abs(SPEED)
			timer=0
#			pass
	if $detect_player_timer.time_left>0:
		$detect_player/CollisionShape2D.disabled=true
		#SPEED=SPEED*2
	else:
		$detect_player/CollisionShape2D.disabled=false
		#SPEED=SPEED
#	var collision=move_and_collide(velocity*delta)
#
#	if collision!=null:
#		collision.clamp((Vector2(-999999,0)),(Vector2(99999,0)))
#		velocity=velocity.bounce(collision.get_normal())
	move_and_slide()
	#move_and_collide(velocity*delta)

func _on_detect_player_body_entered(body):
	if body.is_in_group('player'):
		$detect_player_timer.start()
		SPEED=speed_up
		if distance<0:
			SPEED=-abs(SPEED)
		if distance>0:
			SPEED=abs(SPEED)


func _on_detect_player_timer_timeout():
	pass # Replace with function body.
	SPEED=normalspeed
