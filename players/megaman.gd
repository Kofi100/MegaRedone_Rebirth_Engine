extends CharacterBody2D
##This value keeps the path of the AnimatedSprite2D used for Megaman.
@onready var anim = $anim
##This value keeps the path of the dash node used for Megaman to deterimine his speed.
@onready var dash = $dash

##This is the default speed which can be adjusted by dashing.
var SPEED = 0
##This value deterimines how high a person can jump.
const JUMP_VELOCITY = -600.0
##This value defines how much gravity is applied by the engine to the player.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dashspeed=30000;var dashduration=0.3
var normalspeed=17500.0
var climb=false
var move_an_inch_checker=0
var charge_timer=0
var jump_play_effect_timer=0
var is_dead:bool=false
##This boolean checks if a player has been stunned or not
##and triggers the stun effect
var stun_effect:bool=false
var trans_left=false;var trans_right=false
var trans_up=false;var trans_down=false
var lemon=preload("res://players/projectiles/lemon.tscn")
var lemon_ins
var chargeshot_lv1=preload("res://players/projectiles/chargeshot_lv_1.tscn");var chargeshot_lv1_ins
var chargeshot_lv2=preload("res://players/projectiles/chargeshot_lv_2.tscn");var chargeshot_lv2_ins
var stop=false;var timer=0
func _ready():
	GlobalScript.health=GlobalScript.max_health



func _physics_process(delta):
	GlobalScript.playerposx=global_position.x
	$charge_timer.text=str(charge_timer)
	$speed.text=str(SPEED)
	SPEED=dashspeed if dash.is_dashing() else normalspeed
	# Add the gravity.
	if is_on_floor():
	
		if jump_play_effect_timer<5:
			jump_play_effect_timer+=1
			if jump_play_effect_timer==1:
				$all_sounds/land.play()
	elif not is_on_floor():
		jump_play_effect_timer=0
	#var tween=create_tween()
	if trans_right:
		#timer+=1
		stop=true
		velocity=Vector2(7000,0)*delta
		#tween.tween_property(self,"velocity",Vector2(400,0),1)
#		if tween.finished:print('dig')
#		if !tween.is_running():
#			print('tween_finished')
#			trans_right=false
#			stop=false
		#print(velocity)
		
		move_and_slide()
#		if timer==150:
#			timer=0
#			trans_right=false
#			stop=false
	else:
		stop=false
		
		#tween.stop()
		
	#print(move_an_inch_checker)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !is_dead:
		if !stop:
			if GlobalScript.playerhitcooldowntimer%5==1:
				anim.visible=false
			elif GlobalScript.playerhitcooldowntimer%5==3:
				anim.visible=true
			# Handle Jump.
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			if climb==false:
				if not stun_effect:
					if near_ladder:
						if Input.is_action_pressed("move_up"):
							climb=true
					if not is_on_floor():
						velocity.y += gravity * delta
					var direction = Input.get_axis("move_left", "move_right")
					if direction:
						move_an_inch_checker+=1
						if not is_on_floor():
							velocity.x = direction * SPEED *delta
						else:
							if move_an_inch_checker<10:
								velocity.x=direction *200 *delta
							else:
								velocity.x=direction*SPEED *delta
					else:
						move_an_inch_checker=0
						velocity.x = move_toward(velocity.x, 0, SPEED)
					play_animations()
					dash_function()
					#if anim.animation!="idle":
					shoot_and_charge()
					if $anim.animation=="shoot_idle":
						if $anim.flip_h==false:
							$anim.offset.x=-6
						elif $anim.flip_h==true:
							$anim.offset.x=6
					else:
						$anim.offset.x=0
				else:
					if stun_timer>1 and stun_timer<5:
						#print(stun_timer)
						stun(delta)
						
					stun_timer+=1;#print(stun_timer,' ',GlobalScript.playerhitcooldowntimer)
					if stun_timer==5:
						stun_timer=0
						stun_effect=false
				#This code uses a modulus of 5 to produce a blinking effect
				chargeeffect()
			elif climb==true:
				if Input.is_action_pressed("jump"):
					climb=false
				velocity.x=0
				global_position.x=ladder_collider.global_position.x
				#print("clim:true")
				play_animation_ladder()
				shoot_and_charge_ladder()
				chargeeffect()

			#these codes are for playing animations
				var direction=Input.get_axis("move_up","move_down")
				if direction and anim.animation!="shoot_on_ladder":
					velocity.y=direction*7000*delta
		#			if Input.is_action_pressed("move_up"):
		#				velocity.y=-100
		#			elif Input.is_action_pressed("move_down"):
		#				velocity.y=100
		#			elif not (Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")):
		#				$anim.pause()
		#				velocity.y=0
				else:
					velocity.y=0
			move_and_slide()
			if GlobalScript.health<=0:
				$restart_timer.start(5)
				is_dead=true
				$all_sounds/dead.play()
	elif is_dead:
		anim.visible=false
		$hitbox/CollisionShape2D.disabled=true
		$CollisionShape2D.disabled=true

var dead_effect_timer=0
var stun_timer=0;var stun_speed=2000
func stun(delta):
	if is_on_floor():
		anim.play("stun")
		if anim.flip_h==false:
			velocity=Vector2(stun_speed,0)*delta
		elif anim.flip_h==true:
			velocity=Vector2(-stun_speed,0)*delta

func play_animations():
	if velocity.x<0:
		$anim.flip_h=false
	elif velocity.x>0:
		$anim.flip_h=true
	if is_on_floor():
		if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
			if move_an_inch_checker>=10:
				if anim.animation!="shoot_run" :
						anim.play("run")
			elif move_an_inch_checker<10:
				if velocity.x!=0:
					$anim.play("move_by_inch")
				elif velocity.x==0:
					if $anim.animation!="shoot_idle":
						$anim.play("idle")
						#charge_timer=0
		
		elif Input.is_action_just_released("shoot"):
			if move_an_inch_checker>=10:
				if $anim.animation!="shoot_run":
						$anim.play("shoot_run")
			if move_an_inch_checker<10:
				anim.play("shoot_idle")
				#charge_timer=0

	
	elif not is_on_floor():
		if not Input.is_action_pressed("shoot"):
			if $anim.animation!="shoot_in_air":
				$anim.play("jump")
				#print("jump!")
		elif Input.is_action_pressed("shoot"):
			$anim.play("shoot_in_air")
			#print("shoot")
	

func shoot_and_charge():
	if Input.is_action_pressed("shoot"):
		charge_timer+=1
		if charge_timer==1:
			$all_sounds/charge.play()
	elif Input.is_action_just_released("shoot"):
		$all_sounds/shoot.play()
		$all_sounds/charge.stop()
		if charge_timer<30:
			if is_on_floor():
				charge_timer=0
				if $anim.flip_h==false:
					lemon_ins=lemon.instantiate()
					get_parent().add_child(lemon_ins)
					lemon_ins.direction="left"
					lemon_ins.global_position=$all_proj_spawn_points/ground_left.global_position
				elif $anim.flip_h==true:
					lemon_ins=lemon.instantiate()
					get_parent().add_child(lemon_ins)
					lemon_ins.direction="right"
					lemon_ins.global_position=$all_proj_spawn_points/ground_right.global_position
			elif not is_on_floor():
				charge_timer=0
				if $anim.flip_h==false:
					lemon_ins=lemon.instantiate()
					get_parent().add_child(lemon_ins)
					lemon_ins.direction="left"
					lemon_ins.global_position=$all_proj_spawn_points/air_left.global_position
				elif $anim.flip_h==true:
					lemon_ins=lemon.instantiate()
					get_parent().add_child(lemon_ins)
					lemon_ins.direction="right"
					lemon_ins.global_position=$all_proj_spawn_points/air_right.global_position


		elif charge_timer>=30 and charge_timer<60:
			if is_on_floor():
				charge_timer=0
				if $anim.flip_h==false:
					chargeshot_lv1_ins=chargeshot_lv1.instantiate()
					get_parent().add_child(chargeshot_lv1_ins)
					chargeshot_lv1_ins.direction="left"
					chargeshot_lv1_ins.global_position=$all_proj_spawn_points/ground_left.global_position
				elif $anim.flip_h==true:
					chargeshot_lv1_ins=chargeshot_lv1.instantiate()
					get_parent().add_child(chargeshot_lv1_ins)
					chargeshot_lv1_ins.direction="right"
					chargeshot_lv1_ins.global_position=$all_proj_spawn_points/ground_right.global_position
			elif not is_on_floor():
				charge_timer=0
				if $anim.flip_h==false:
					chargeshot_lv1_ins=chargeshot_lv1.instantiate()
					get_parent().add_child(chargeshot_lv1_ins)
					chargeshot_lv1_ins.direction="left"
					chargeshot_lv1_ins.global_position=$all_proj_spawn_points/air_left.global_position
				elif $anim.flip_h==true:
					chargeshot_lv1_ins=chargeshot_lv1.instantiate()
					get_parent().add_child(chargeshot_lv1_ins)
					chargeshot_lv1_ins.direction="right"
					chargeshot_lv1_ins.global_position=$all_proj_spawn_points/air_right.global_position


		elif charge_timer>60:
			if is_on_floor():
				charge_timer=0
				if $anim.flip_h==false:
					chargeshot_lv2_ins=chargeshot_lv2.instantiate()
					get_parent().add_child(chargeshot_lv2_ins)
					chargeshot_lv2_ins.direction="left"
					chargeshot_lv2_ins.global_position=$all_proj_spawn_points/ground_left.global_position
				elif $anim.flip_h==true:
					chargeshot_lv2_ins=chargeshot_lv2.instantiate()
					get_parent().add_child(chargeshot_lv2_ins)
					chargeshot_lv2_ins.direction="right"
					chargeshot_lv2_ins.global_position=$all_proj_spawn_points/ground_right.global_position
			elif not is_on_floor():
				charge_timer=0
				if $anim.flip_h==false:
					chargeshot_lv2_ins=chargeshot_lv2.instantiate()
					get_parent().add_child(chargeshot_lv2_ins)
					chargeshot_lv2_ins.direction="left"
					chargeshot_lv2_ins.global_position=$all_proj_spawn_points/air_left.global_position
				elif $anim.flip_h==true:
					chargeshot_lv2_ins=chargeshot_lv2.instantiate()
					get_parent().add_child(chargeshot_lv2_ins)
					chargeshot_lv2_ins.direction="right"
					chargeshot_lv2_ins.global_position=$all_proj_spawn_points/air_right.global_position

var switch_to=0
func shoot_and_charge_ladder():
	pass
	if Input.is_action_pressed("shoot"):
		if charge_timer==1:
			$all_sounds/charge.play()
		charge_timer+=1
	if Input.is_action_just_released("shoot"):
		pass
		$all_sounds/charge.stop()
		$all_sounds/shoot.play()
		if charge_timer<30:
			#print("chrge over")
			if $anim.flip_h==false:
				lemon_ins=lemon.instantiate()
				get_parent().add_child(lemon_ins)
				lemon_ins.direction="left"
				lemon_ins.global_position=$all_proj_spawn_points/air_left.global_position
			elif $anim.flip_h==true:
				lemon_ins=lemon.instantiate()
				get_parent().add_child(lemon_ins)
				lemon_ins.direction="right"
				lemon_ins.global_position=$all_proj_spawn_points/air_right.global_position
			
		elif charge_timer>=30 and charge_timer<60:
			if $anim.flip_h==false:
				chargeshot_lv1_ins=chargeshot_lv1.instantiate()
				get_parent().add_child(chargeshot_lv1_ins)
				chargeshot_lv1_ins.direction="left"
				chargeshot_lv1_ins.global_position=$all_proj_spawn_points/air_left.global_position
			elif $anim.flip_h==true:
				chargeshot_lv1_ins=chargeshot_lv1.instantiate()
				get_parent().add_child(chargeshot_lv1_ins)
				chargeshot_lv1_ins.direction="right"
				chargeshot_lv1_ins.global_position=$all_proj_spawn_points/air_right.global_position
		elif charge_timer>=60:
			if $anim.flip_h==false:
				chargeshot_lv2_ins=chargeshot_lv2.instantiate()
				get_parent().add_child(chargeshot_lv2_ins)
				chargeshot_lv2_ins.direction="left"
				chargeshot_lv2_ins.global_position=$all_proj_spawn_points/air_left.global_position
			elif $anim.flip_h==true:
				chargeshot_lv2_ins=chargeshot_lv2.instantiate()
				get_parent().add_child(chargeshot_lv2_ins)
				chargeshot_lv2_ins.direction="right"
				chargeshot_lv2_ins.global_position=$all_proj_spawn_points/air_right.global_position
		charge_timer=0
		
func play_animation_ladder():
	if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
		if anim.animation!="shoot_on_ladder":
			if was_leaving==false:
				#if anim.animation!="shoot_on_ladder":
				if Input.is_action_pressed("move_up"):
					$anim.play("climb")
					
				elif Input.is_action_pressed("move_down"):
					#velocity.y=100
					$anim.play_backwards("climb")
	#		if $change_climb_detector/CollisionShape2D
			elif was_leaving==true:
				#print("about to leave ladder")
				$anim.play("climb_transition")
	elif Input.is_action_just_released("shoot"):
		if anim.animation!="shoot_on_ladder":
			anim.play("shoot_on_ladder")
			#print('still playing')
			if Input.is_action_pressed("move_left"):
				anim.flip_h=false
			elif Input.is_action_pressed("move_right"):
				anim.flip_h=true

func dash_function():
	if is_on_floor():
		if Input.is_action_just_pressed("dash"):
			dash.start_dash(dashduration)
		if Input.is_action_pressed("dash"):
			if $dash/Timer.time_left>0:
				anim.play("dash")
			elif $dash/Timer.time_left<=0:
				velocity.x=0
				anim.play("idle")

func chargeeffect():
	if charge_timer==0:
		$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		$anim.material.set_shader_parameter("bodycolori",(Vector4(136.0,232.0,255.0,255.0))/255)
		$anim.material.set_shader_parameter("bodycolorii",(Vector4(0.0,98.0,247.0,255.0))/255)
	elif charge_timer>0 and charge_timer<60:
		if charge_timer%10==1:
			#print('mega chargeeffect:active1')
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif charge_timer%10==5:
			#print('mega chargeeffect:active1:2')
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif charge_timer>60 and charge_timer<120:
		if charge_timer%10==1:
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif charge_timer%10==5:
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif charge_timer>120:
		#$animated_sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		if charge_timer%10==1:
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
			$anim.material.set_shader_parameter("bodycolori",(Vector4(0.0,0.0,0.0,255.0))/255)
			$anim.material.set_shader_parameter("bodycolorii",(Vector4(0.0,98.0,247.0,255.0))/255)
		elif charge_timer%10==5:
			$anim.material.set_shader_parameter("bodycolori",(Vector4(0.0,98.0,247.0,255.0))/255)
			$anim.material.set_shader_parameter("bodycolorii",(Vector4(0.0,0.0,0.0,255.0))/255)
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(135.0,0.0,142.0,255.0))/255)

func _on_anim_animation_finished():
	if $anim.animation=="shoot_run":
		$anim.play("run")
	
	if $anim.animation=="shoot_idle":
		$anim.play("idle")
		
	if $anim.animation=="shoot_in_air":
		$anim.play("jump")
	if anim.animation=="shoot_on_ladder":
		print("done")
		anim.play("climb")

var was_leaving=false


func _on_change_climb_detector_area_entered(area):
	if area.is_in_group("ladders"):
		was_leaving=false


func _on_change_climb_detector_area_exited(area):
	if area.is_in_group("ladders"):
		was_leaving=true

var near_ladder=false
func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy"):
		if GlobalScript.playerhasbeenhit==false:
			GlobalScript.playerhasbeenhit=true
			GlobalScript.health-=area.get_parent().playerdamagevalue#this transfers a value of damage from the enemy to the player
			$all_sounds/stun.play()
			stun_effect=true
	if area.is_in_group("ladders"):
		near_ladder=true
func _on_hitbox_area_exited(area):
	if area.is_in_group("ladders"):
		near_ladder=false
		climb=false
		#print("Megaman:about to leave ladder")


var ladder_collider:Object
func _on_hitbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	#if area.is_in_group("ladders"):
		ladder_collider=area.shape_owner_get_owner(area_shape_index)
		#print(ladder_collider,'of Area:',area)


func _on_hitbox_area_shape_exited(area_rid, area, area_shape_index, _local_shape_index):
	pass





func _on_restart_timer_timeout():
	get_tree().reload_current_scene()
