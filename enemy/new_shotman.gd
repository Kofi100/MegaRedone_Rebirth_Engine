extends enemy

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var new_proj=preload('res://enemy/new_shotman_bullet.tscn')
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var shoot_sides_timer=0
var proj=preload('res://enemy/new_shotman_bullet.tscn')
var bullet_target_index=1
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
#codes for shooting side bullets
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
	
	if shoot_sides_timer%120==30 or shoot_sides_timer%120==60:
#		var target=preload('res://enemy/new_shotman_target.tscn')
#		new_target=target.instantiate()
#		bullet_target_index+=1
#		add_child(new_target)
		
#		new_target.index_bullet_target=bullet_target_index
		
#		new_target.global_position=Vector2(GlobalScript.playerposx,GlobalScript.playerposy)
		var projectile_throw=preload('res://enemy/new_shotman_bullet.tscn')
		proj_throw_new=projectile_throw.instantiate()
		proj_throw_new.direction='gravity'
		#proj_throw_new.velocity.y=JUMP_VELOCITY
		proj_throw_new.global_position=$shoot_pos/up.global_position
		
#		proj_throw_new.index_bullet=bullet_target_index
		
		get_parent().add_child(proj_throw_new)
		
		
#	if proj_throw_new!=null:
#		if proj_throw_new.index_bullet==new_target.index_bullet_target:
#			var newposx=move_toward(proj_throw_new.global_position.x,new_target.global_position.x,300*delta)
#			#var newposy=move_toward(proj_throw_new.global_position.y,GlobalScript.playerposy,300*delta)
#			proj_throw_new.global_position.x=newposx
	move_and_slide()

var proj_throw_new;var new_target
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	#get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)
