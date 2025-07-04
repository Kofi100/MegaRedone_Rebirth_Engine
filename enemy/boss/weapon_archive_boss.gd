extends enemy
@onready var animation_player = $Sprite2D/AnimationPlayer


@export var SPEED = 300.0
@export var speedx_robot_masters={
	'crash_man':1000,
}
@export var JUMP_VELOCITY = -400.0
var distance:int
var disabled_hitbox=false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var state_to_start=''
var isAlive:bool=true
func _ready():
	active=false
	#match state:
	health=15
	playerdamagevalue=5
	state=state_to_start
	match state:
#		'ice_man':
#			$timers/ice_man/go_up_timer.start()
#			$timers/ice_man/shoot_timer.start()
		'crash_man':
			$timers/crash_man/crash_man_move_timer.start()
var hit_by_projectile=false;var hit_cooldown=0
var active=true;var active_iceman=false;var play_anim_once=false
func _physics_process(delta):
	#debug
	#print(state,',,',velocity.y,'...',$timers/crash_man/crash_man_move_timer.time_left)
	$text.text=str(health)
	#essential codes
	distance=GlobalScript.playerposx-global_position.x
	if health<=0 and isAlive:
		if $explosion and $explosion_audio_effect:
			$explosion.set_emitting(true)
			$explosion_audio_effect.play()
			#$explosion.reparent(get_tree().current_scene)
			#$explosion_audio_effect.reparent(get_tree().current_scene)
		isAlive=false
	if hit_by_projectile:
		hit_cooldown+=1*delta
	if hit_cooldown>=1:
		hit_cooldown=0
		hit_by_projectile=false
		$hurt_animation/AnimationPlayer.play("not_hurt")
	
	if hit_by_projectile:
		$hitbox/CollisionShape2D.disabled=true
		$hurtbox/CollisionShape2D.disabled=true
	elif  not hit_by_projectile:
		$hitbox/CollisionShape2D.disabled=false
		$hurtbox/CollisionShape2D.disabled=false
	
	if isAlive:
		match active:
			true:

				play_retract_once=false
				if play_anim_once==false:
					#$Sprite2D.frame=0
					play_anim_once=true
					if disabled_hitbox:
						$hitbox/CollisionShape2D.disabled=false
						disabled_hitbox=false
						
				match state:
					
					'ice_man':
						if not $RayCast2D.is_colliding():
							velocity.x=0
							position.x+=0
						if active_iceman==false:
							$timers/ice_man/go_up_timer.start()
							$timers/ice_man/shoot_timer.start()
							active_iceman=true
						if $timers/ice_man/go_up_timer.time_left>0.5:
							velocity.y=-SPEED*delta
							$timers/ice_man/shoot_timer.set_one_shot(false)
							
						if $timers/ice_man/go_up_timer.time_left>0.9:
							pass
						
						if $timers/ice_man/go_up_timer.time_left<0.5:
							velocity.y=0
						if $timers/ice_man/go_down_timer.time_left>0:
							velocity.y=SPEED*delta
						if $RayCast2D.is_colliding() and $timers/ice_man/go_down_timer.time_left>0:
							#print('true')
							$timers/ice_man/go_down_timer.stop()
							$timers/ice_man/shoot_timer.set_one_shot(true)
							$timers/ice_man/ice_man_wait_for_movement_cooldown_timer.start()
						if $timers/ice_man/ice_man_move_timer.time_left>0 and is_on_floor():
							animation_player.stop();$Sprite2D.frame=0
							if distance<0:
								velocity.x=-speedx_robot_masters['ice_man']*delta
							elif distance>=0:
								velocity.x=speedx_robot_masters['ice_man']*delta
						else:
							velocity.x=0
					'crash_man':
						#debug
						#print(velocity.y)
						if not is_on_floor():
							velocity.y+=gravity*delta
							
						if $timers/crash_man/crash_man_move_timer.time_left>0:
							check_megaman_cooldown+=1
							if check_megaman_cooldown%40==1:
								if is_on_floor():
									if distance<0:
										velocity.x=-speedx_robot_masters['crash_man']*delta
									elif distance>=0:
										velocity.x=speedx_robot_masters['crash_man']*delta
	#					else:
	#						velocity.x=0 
						
						if not is_on_floor() and velocity.y>0 and not crash_bomb_released:#and abs(distance)>=50 
							animation_player.play("shoot")
							crash_bomb_released=true
							#print(global_position.y-700)
							crash_target_index+=1
							#crash_bomb=preload('res://enemy/boss/weapons/weapon_archive/crash_bomb.tscn')
							crash_bomb_instance=crash_bomb.instantiate();crash_target_instance=crash_target.instantiate()
							crash_target_instance.global_position=Vector2(GlobalScript.playerposx,GlobalScript.playerposy)
							crash_target_instance.target_index=crash_target_index
							crash_bomb_instance.target_index=crash_target_index
							var dis_x=GlobalScript.playerposx-global_position.x
							var dis_y=GlobalScript.playerposy-global_position.y
							var angle_to_shoot=atan2(dis_y,dis_x)
							crash_bomb_instance.angle_to_go_in=angle_to_shoot
			#				var tracker=Node2D.new()
			#				tracker.global_position.x=
							#print('yh')

							get_parent().add_child(crash_bomb_instance)
							crash_bomb_instance.global_position=global_position
			#				crash_bomb_instance.velocity.x=distance *delta
			#				crash_bomb_instance.velocity.y= 1000*delta
							#crash_bomb_instance.global_position.x-=GlobalScript.playerposx
						
						if is_on_floor():
							animation_player.stop()
							if $timers/crash_man/crash_man_move_timer.time_left==0 and not already_started:
								already_started=true
								crash_bomb_released=false
								$timers/crash_man/crash_man_move_timer.start()
						
			#			if not is_on_floor():
			#				if crash_target_instance!=null and crash_bomb_instance!=null:
			#					if crash_bomb_instance.target_index==crash_target_instance.target_index:
			#						var newposition_x=move_toward(crash_bomb_instance.global_position.x,crash_target_instance.global_position.x,200*delta)
			#						var newposition_y=move_toward(crash_bomb_instance.global_position.y,crash_target_instance.global_position.y,200*delta)
			#						crash_bomb_instance.global_position.x=newposition_x
			#						crash_bomb_instance.global_position.y=newposition_y
					'shadow_man':
						#print('jump_value:',jump_value_randomizer,'is_on_floor:',is_on_floor(),'has_jumped:',has_jumped)
						if not is_on_floor():
							velocity.y+=1000*delta
							has_jumped=false
						var jump_low=(-950/3)
						var jump_high=(-1200/3)#-700
						if  $timers/shadow_man/shadow_man_jump_state_timer.time_left>0:
							$Sprite2D.frame=0
							if is_on_floor() and not has_jumped :
								has_jumped=true
								jump_value_randomizer=randi_range(1,2)
								if jump_value_randomizer==1:velocity.y=jump_low
								elif jump_value_randomizer==2:velocity.y=jump_high
							if distance<0:
								velocity.x=-speedx_robot_masters['shadow_man']*delta
							elif distance>0:
								velocity.x=speedx_robot_masters['shadow_man']*delta
						elif $timers/shadow_man/shadow_man_jump_state_timer.time_left<=0:
							velocity.x=0
						if $timers/shadow_man/shadow_man_attack_timer.time_left>0 and is_on_floor():
							if not shadow_attack:
								animation_player.play("shoot")
								shadow_attack=true
								var shadow_blade=preload('res://enemy/boss/weapons/weapon_archive/shadow_blade_weapon_archive.tscn')
								var shadow_blade_instance=shadow_blade.instantiate()
								#var shadow_blade_instance2=shadow_blade.instantiate()
								if distance<0:
									shadow_blade_instance.direction='move_left'
									#shadow_blade_instance2.direction='diagonal_left'
								elif distance>=0:
									shadow_blade_instance.direction='move_right'
									#shadow_blade_instance2.direction='diagonal_right'
								get_parent().add_child(shadow_blade_instance);#get_parent().add_child(shadow_blade_instance2)
								shadow_blade_instance.global_position=global_position
								#shadow_blade_instance2.global_position=global_position
				move_and_slide()
			false:
				$hitbox/CollisionShape2D.disabled=true
				disabled_hitbox=true
				play_anim_once=true
	#			for i in get_children():
	#				if i.is_class('Timer'):
	#					i.stop()
				$timers/ice_man/shoot_timer.stop()
				if $Sprite2D/AnimationPlayer.current_animation!='retract':
					if play_retract_once==false:
						$Sprite2D/AnimationPlayer.play("retract")
						play_retract_once=true
	else:
		velocity=Vector2.ZERO
		$hitbox/CollisionShape2D.disabled=true
		$hurtbox/CollisionShape2D.disabled=true
		$CollisionShape2D.set_deferred("disabled",true)
		for i in get_children():
			if i is Timer:
				i.stop()
		$timers/ice_man/shoot_timer.stop()
		$timers/ice_man/go_up_timer.stop()
		$timers/ice_man/go_down_timer.stop()
		$timers/ice_man/ice_man_move_timer.stop()
		$timers/ice_man/ice_man_wait_for_movement_cooldown_timer.stop()
		#print(i.get_children is Timer)
var play_retract_once=false
var shadow_attack=false
var has_jumped=false;var jump_value_randomizer=0
var check_megaman_cooldown=1
var already_started=false
var crash_bomb_released=false;var crash_tracker_no=0
var crash_target=preload('res://enemy/boss/weapons/weapon_archive/crash_bomb_target.tscn');var crash_target_instance
var crash_target_index=0
var crash_bomb=preload('res://enemy/boss/weapons/weapon_archive/crash_bomb.tscn');var crash_bomb_instance
func _on_go_up_timer_timeout():
	$timers/ice_man/go_down_timer.start()

var ice_slasher=preload('res://enemy/boss/weapons/weapon_archive/ice_slasher.tscn')
var ice_slasher_instance
func _on_shoot_timer_timeout():
	animation_player.play("shoot")
	#StageFunctions.create_new_stuff(ice_slasher,ice_slasher_instance)
	match state:
		'ice_man':
			ice_slasher_instance=ice_slasher.instantiate()
			get_parent().add_child(ice_slasher_instance)
			#if ice_slasher_instance!=null:
			ice_slasher_instance.global_position=global_position
			if distance<0:
				ice_slasher_instance.direction='left'
			elif distance>0:
				ice_slasher_instance.direction='right'

func _on_ice_man_wait_for_movement_cooldown_timer_timeout():
	$timers/ice_man/ice_man_move_timer.start()
func _on_ice_man_move_timer_timeout():
	$timers/ice_man/go_up_timer.start()
	$timers/ice_man/shoot_timer.start()

func _on_go_down_timer_timeout():
	pass # Replace with function body.


func _on_hitbox_area_entered(area):
	if area.is_in_group('player_projectiles'):
		if not hit_by_projectile:
			hit_by_projectile=true
			$hurt_animation/AnimationPlayer.play("hurt_blink")


func _on_crash_man_move_timer_timeout():
	velocity.y=JUMP_VELOCITY
	already_started=false


func _on_crash_man_detect_player_projectile_area_entered(area):
	if area.is_in_group('player_projectile'):
		pass
		velocity.y=JUMP_VELOCITY


func _on_shadow_man_jump_state_timer_timeout():
	$timers/shadow_man/shadow_man_attack_timer.start()


func _on_shadow_man_attack_timer_timeout():
	$timers/shadow_man/shadow_man_jump_state_timer.start()
	shadow_attack=false

func go_back():
	if $timers/active_timer.time_left>0:
		pass

@export var position_to_rest_in:Node2D
func _on_state_active_timer_timeout():
	if position_to_rest_in!=null:
		animation_player.play("retract")
		var tween=create_tween()
		tween.tween_property(self,'global_position',position_to_rest_in.global_position,.5)
		tween.connect('finished',tween_done)

func tween_done():
	animation_player.play("idle")


func _on_animation_player_animation_finished(anim_name):
	if anim_name=='retract':
		$Sprite2D/AnimationPlayer.play("idle")
		if active==true:
			$Sprite2D.frame=0
