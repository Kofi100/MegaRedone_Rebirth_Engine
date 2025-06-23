extends enemy

@onready var animation_player = $AnimationPlayer

var SPEED = 4000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	state='fall_normal'
	playerdamagevalue=5
	health=5

func _physics_process(delta):
	#print(SPEED)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	spawn_collectables()
	match state:
		'fall_normal':
			animation_player.play("fall")
			gravity=  500
		'para_open':
			if animation_player.current_animation!='parcheute _open':
				animation_player.play("parcheute _open")
				velocity.y=0
				gravity=0
		'fall_slow':
			gravity=10
			velocity.x=SPEED*delta
			animation_player.play("slow_fall")
			#velocity.y=-10*delta
	move_and_slide()


func _on_fall_to_open_timer_timeout():
	state='para_open'


func _on_animation_player_animation_finished(anim_name):
	if anim_name=='parcheute _open':
		#print('duh')
		state='fall_slow'
		$change_X_direction_start.start(1)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	#get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)


func _on_change_x_direction_start_timeout():
	#print('donw')
	if SPEED==abs(SPEED):
		SPEED=-abs(SPEED)
	elif SPEED==-abs(SPEED):
		SPEED=abs(SPEED)
