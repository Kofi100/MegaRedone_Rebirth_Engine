extends enemy

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var new_proj=preload('res://enemy/new_shotman_bullet.tscn')
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var shoot_sides_timer=0
var proj=preload('res://enemy/new_shotman_bullet.tscn')

func _ready():
	playerdamagevalue=3;health=5


func _physics_process(delta):
	animated_sprite_2d.play("default")
	$index.text=str(index)
	spawn_collectables()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	shoot_sides_timer+=1
#	if shoot_sides_timer==60:
#		shoot_sides_timer=0
	if shoot_sides_timer%120==1 or shoot_sides_timer%120==30 or shoot_sides_timer%120==60 :
		var new_proj_lr:Object;var new_proj_right
		#StageFunctions.create_new_stuff(proj,new_proj_lr)
		new_proj_lr=proj.instantiate()
		get_parent().add_child(new_proj_lr)
		new_proj_lr.direction='left'
		new_proj_lr.global_position=$shoot_pos/left.global_position
		
		#StageFunctions.create_new_stuff(proj,new_proj_right)
		new_proj_right=proj.instantiate()
		get_parent().add_child(new_proj_right)
		new_proj_right.direction='right'
		new_proj_right.global_position=$shoot_pos/right.global_position
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)
