extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var upspeed=-5000
@export var downspeed=3000
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	state='up'
	health=3
	playerdamagevalue=2

func _physics_process(delta):
	spawn_collectables()
	$AnimatedSprite2D.play("default")
	var distancex=GlobalScript.playerposx-global_position.x
	if distancex<0:
		$AnimatedSprite2D.flip_h=false
	elif distancex>0:
		$AnimatedSprite2D.flip_h=true
	match state:
		"up":
			pass
			velocity.y=upspeed*delta
			if GlobalScript.playerposy-20>global_position.y:
				state='down'
				$left_right_timer.start()
		"down":
			velocity.y=downspeed*delta
			if $left_right_timer.time_left>$left_right_timer.wait_time/2:
				velocity.x=-3000*delta
			else:
				velocity.x=3000*delta

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	if state=='down':
		queue_free()
		#print(name,"[enemy:upndown]-> deleted")
