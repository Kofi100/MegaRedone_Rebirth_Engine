extends enemy

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 980

func _ready():
	state='drop_down'
	playerdamagevalue=5
	health=3
	

func _physics_process(delta):
	# Add the gravity.
	var distance_x=GlobalScript.playerposx-global_position.x
	match state:
		'drop_down':
			velocity.y=gravity*delta
			if global_position.y>=GlobalScript.playerposy:
				state='move_toward_player'
				#print('works')
				if distance_x<0:
					SPEED=-abs(SPEED)
					animated_sprite_2d.flip_h=false
				elif distance_x>0:
					SPEED=abs(SPEED)
					animated_sprite_2d.flip_h=true
		'move_toward_player':
			velocity.x=SPEED*delta
			velocity.y=0
			animated_sprite_2d.play("default")
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	#get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)
