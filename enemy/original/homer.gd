extends enemy




@export var speed = 16#50.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	playerdamagevalue=5
	health=7

func _physics_process(delta):
	$AnimatedSprite2D.play("homer")
	var new_pos=move_toward(global_position.x,GlobalScript.playerposx,speed*delta)
	var new_pos2=move_toward(global_position.y,GlobalScript.playerposy,speed*delta)
	move_and_slide()
	spawn_collectables()
	global_position.x=new_pos
	global_position.y=new_pos2
	#not so good code
#	if $shoot_timer.time_left<=0:
#		print('homer:shooting projs')
#		var signal_proj=preload('res://enemy/original/original_projs/signal_proj.tscn')
#		var signal_proj_ins=signal_proj.instantiate();var signal_proj_ins2=signal_proj.instantiate();
#		signal_proj_ins.state='down';signal_proj_ins2.state='down';	get_parent().add_child(signal_proj_ins);get_parent().add_child(signal_proj_ins2);
#		signal_proj_ins.global_position=$shoot_positions/down/Marker2D.global_position;
#		signal_proj_ins2.global_position=$shoot_positions/down/Marker2D2.global_position;
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	#get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)


func _on_shoot_timer_timeout():
	pass # Replace with function body.
	print('homer:shooting projs')
	##shooting projectile codes:might use them later
	#var signal_proj=preload('res://enemy/original/original_projs/signal_proj.tscn')
	#var signal_proj_ins=signal_proj.instantiate();var signal_proj_ins2=signal_proj.instantiate();
	#signal_proj_ins.state='down';signal_proj_ins2.state='down';	get_parent().add_child(signal_proj_ins);get_parent().add_child(signal_proj_ins2);
	#signal_proj_ins.global_position=$shoot_positions/down/Marker2D.global_position;
	#signal_proj_ins2.global_position=$shoot_positions/down/Marker2D2.global_position;
