extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var activate_boss=false
var intro_to_boss=false
func _physics_process(delta):
	health=40
	playerdamagevalue=3
	is_boss=true
	calculate_player_distance()
	if activate_boss==true:
		if intro_to_boss==false:
			$AnimatedSprite2D.play("intro")
			intro_to_boss=true
	if $Node2D/disappear_time.time_left>0:
		visible=false
	if cycleAttackNo==3:
		cycleAttackNo=0
		$Node2D/countdownToShootDown.start()
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	match $AnimatedSprite2D.animation:
		"intro":
			$AnimatedSprite2D.play("attacking")
			$Node2D/disappear_time.start()

var spawn_proj_positions=[Vector2(0,-30),Vector2(22,30),Vector2(-22,30)]
var cycleAttackNo=0
func _on_timer_timeout():
	cycleAttackNo+=1
	for i in spawn_proj_positions:
		var wily_proj=preload("res://enemy/boss/wily_capsule_7_projectiles.tscn").instantiate()
		get_parent().add_child(wily_proj)
		wily_proj.global_position=global_position+i
	$Node2D/disappear_time.start()
	$hitbox/CollisionShape2D.disabled=true;$hitbox_to_be_shot/CollisionShape2D.disabled=true


func _on_disappear_time_timeout():
	global_position.x=randi_range(100,240)
	global_position.y=randi_range(100,200)
	visible=true
	$hitbox/CollisionShape2D.disabled=false;$hitbox_to_be_shot/CollisionShape2D.disabled=false
	$Node2D/Timer.start()


func _on_countdown_to_shoot_down_timeout():
	var wily_proj_shootdown=preload("res://enemy/boss/wily_capsule_7_projectiles.tscn").instantiate()
	get_parent().add_child(wily_proj_shootdown)
	wily_proj_shootdown.state="gotoGround"
	wily_proj_shootdown.global_position=global_position
