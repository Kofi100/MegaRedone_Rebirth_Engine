extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var overall_speed:float=0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var activate_boss:bool=false
var ready_pose:bool=false
var available_toattack:bool=false
func _ready():
	health=27
func _physics_process(delta):
	is_boss=true
	calculate_player_distance()
	if $cooldown_timer.time_left>0:
		#$hitbox.set_monitoring(false)
		$hitbox/CollisionShape2D.disabled=true
	else:
		#$hitbox.set_monitoring(true)
		$hitbox/CollisionShape2D.disabled=false
	if activate_boss==true:
		if ready_pose==false:
			animated_sprite_2d.play("pose")
			ready_pose=true
		if available_toattack==true:
			spawn_collectables()
			#print("fireman(boss)->jump_timer:",$all_timers/jump_timer.time_left)
			#print(distance_x)
			#print($all_timers/idle_timer.time_left)
			if not is_on_floor():
				velocity.y += gravity * delta
			playerdamagevalue=5
			$Label.text=str(animated_sprite_2d.animation)
			if distance_x>0:
				animated_sprite_2d.flip_h=true
			elif distance_x<=0:
				animated_sprite_2d.flip_h=false
			match animated_sprite_2d.animation:
				"shoot":
					velocity.x=0
			if $all_timers/run_timer.time_left>0:
				animated_sprite_2d.play("run")
				if distance_x>0:
					velocity.x=3200*delta#3500
				elif distance_x<=0:
					velocity.x=-3200*delta
			if $all_timers/idle_timer.time_left>0:
				animated_sprite_2d.play("idle")
				velocity.x=0
			if $all_timers/jump_timer.time_left>0 and jump_times==0:
				var max_jump_times=3
				if is_on_floor():
					set_jump_direction=false;
					velocity.y=-20000*delta #-3000
					overall_speed=distance_x*(SPEED/3)#global_position.distance_to(GlobalScript.player.global_position)
					animated_sprite_2d.play("jump")
					$land.play()
				if not is_on_floor() and set_jump_direction==false:
					set_jump_direction=true
					#if distance_x<0:
						#velocity.x=-3000*delta
					#elif distance_x>=0:
						#velocity.x=3000*delta
					velocity.x=overall_speed*delta
					if velocity.y>0:
						jump_times+=1
				if is_on_floor() and jump_times==max_jump_times:
					jump_times=0
					set_jump_direction=false
					
					velocity.x=0
					$all_timers/idle_timer.start()
					$all_timers/jump_timer.stop()
			move_and_slide()
	elif activate_boss==false:
		$hitbox.set_monitorable(false)
		$hitbox.set_monitoring(false)

var jump_times=0;var set_jump_direction:bool=false
var set_new_state=0
func _on_animated_sprite_2d_animation_finished():
	match animated_sprite_2d.animation:
		"pose":
			#animated_sprite_2d.play("idle")
			$all_timers/idle_timer.start()
			available_toattack=true
			$hitbox.set_monitorable(true)
			$hitbox.set_monitoring(true)
		#"idle":
			#set_new_state+=1
			#if set_new_state%2==0:
				#$all_timers/run_timer.start()
			#elif set_new_state%2==1:
				#$all_timers/jump_timer.start()
		"shoot":
			$all_timers/idle_timer.start()
			animated_sprite_2d.play("idle")

func _on_run_timer_timeout():
	animated_sprite_2d.play("shoot")
	$fire_storm_1.play()
	var fire_storm_main=preload("res://enemy/boss/fireman_fire_storm_main.tscn").instantiate()
	var fsignal=preload("res://enemy/boss/firestorm_signal.tscn").instantiate()
	if distance_x<0:
		fire_storm_main.state="left"
		fire_storm_main.position=position
		get_parent().add_child(fire_storm_main)
		
	elif distance_x>=0:
		add_projectile(fire_storm_main,"right")
		#fire_storm_main.state="right"
		#fire_storm_main.position=position
		#get_parent().add_child(fire_storm_main)
	if health<health/2:
		print("Desperation mode loaded")
		fire_storm_main.SPEED=fire_storm_main.SPEED*3
	#add_projectile(fsignal,"up")

func add_projectile(object:Object,state_to_be:String):
	object.state=state_to_be
	object.position=position
	get_parent().add_child(object)
func _on_idle_timer_timeout():
	#$all_timers/jump_timer.start()
	set_new_state+=1
	if set_new_state%2==0:
		$all_timers/run_timer.start()
	elif set_new_state%2==1:
		$all_timers/jump_timer.start()


func _on_jump_timer_timeout():
	#if is_on_floor():
	$all_timers/idle_timer.start()
	pass


func _on_hitbox_area_entered(area):
	if area.is_in_group("player_projectiles"):
		$cooldown_timer.start()
		#print(name,"-> cooldown timer started")
