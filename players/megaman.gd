extends CharacterBody2D
##This value keeps the path of the AnimatedSprite2D used for Megaman.
@onready var anim = $anim
##This value keeps the path of the dash node used for Megaman to deterimine his speed.
@onready var dash = $dash

##This is the default speed which can be adjusted by dashing.
@export var SPEED = 0
##This value deterimines how high a person can jump.
@export var JUMP_VELOCITY = -600.0
##This value defines how much gravity is applied by the engine to the player.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var gravity=3000
var dashspeed=30000;var dashduration=0.3
@export var normalspeed=17500.0
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
var rush_coil=preload("res://players/weapons/rush_coil.tscn");var rush_coil_instance
var stop=false;var timer=0
var weapon_number:int=0;var max_weapon_number=2
func _ready():
	GlobalScript.health=GlobalScript.max_health
	$weapon_display.visible=false
var onrush=false
var switch_state=0
func _physics_process(delta):
	GlobalScript.playerposx=global_position.x
	$charge_timer.text=str(MegamanAndItems.charge_timer)
	$speed.text=str(SPEED)
	GlobalScript.playerposy=global_position.y
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
		switch_state=0
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
	elif trans_right==false:
		switch_state+=1
		#print('trans_right state:off')
		if switch_state==1:
			stop=false
		
		#tween.stop()
		
	if GlobalScript.weapon_number<0:
		GlobalScript.weapon_number=max_weapon_number
	elif GlobalScript.weapon_number>max_weapon_number:
		GlobalScript.weapon_number=0
	delete_weapons()
	#print(weapon_number)
	#print(move_an_inch_checker)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !is_dead:
		if GlobalScript.playerhasbeenhit:
			$hitbox/CollisionShape2D.disabled=true
		elif not GlobalScript.playerhasbeenhit:
			$hitbox/CollisionShape2D.disabled=false
		#change_collisions()
		if Input.is_action_just_pressed("switch_weapon_left"):
			GlobalScript.weapon_number-=1
			$weapon_display.visible=true
			$weapon_display/display_timer.start()
		elif Input.is_action_just_pressed("switch_weapon_right"):
			$weapon_display.visible=true
			GlobalScript.weapon_number+=1
			$weapon_display/display_timer.start()
		
		$weapon_display.frame=GlobalScript.weapon_number
		#weapon_number=Input.get_axis("switch_weapon_left","switch_weapon_right")
		
		if stop==false:
			if GlobalScript.playerhitcooldowntimer%5==1:
				anim.visible=false
			elif GlobalScript.playerhitcooldowntimer%5==3:
				anim.visible=true
			# Handle Jump.
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
			if Input.is_action_just_released("jump") and velocity.y<0:
				velocity.y=0
			if onrush==false:
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
									velocity.x=direction *1000 *delta
								else:
									velocity.x=direction*SPEED *delta
						else:
							move_an_inch_checker=0
							velocity.x = move_toward(velocity.x, 0, SPEED)
						play_animations()
						dash_function(delta)
						#if anim.animation!="idle":
						if GlobalScript.weapon_number==0:
							shoot_and_charge()
							chargeeffect()
						else:
							MegamanAndItems.change_palette($anim)
							create_weapons()
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
			elif onrush==true:
				shoot_and_charge()
				chargeeffect()
				if $anim.animation=="shoot_idle":
					if $anim.flip_h==false:
						$anim.offset.x=-6
					elif $anim.flip_h==true:
						$anim.offset.x=6
				else:
					$anim.offset.x=0
				#if is_on_floor():
					if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
						if anim.animation!="shoot_idle" :#or anim.animation!="stun"
							$anim.play("idle")
					elif Input.is_action_just_released("shoot"):
						$anim.play("shoot_idle")
				if Input.is_action_pressed("move_left"):
					anim.flip_h=false
				elif Input.is_action_pressed("move_right"):
					anim.flip_h=true
				if Input.is_action_just_pressed("jump"):
					onrush=false
				#velocity.y+=gravity*delta
				#move_and_slide()
		elif stop==true:
			velocity=Vector2.ZERO
	elif is_dead:
		anim.visible=false
		$hitbox/CollisionShape2D.disabled=true
		$CollisionShape2D.disabled=true

var dead_effect_timer=0
var stun_timer=0;var stun_speed=30000
func stun(delta):
	if is_on_floor():
		anim.play("stun")
	elif not is_on_floor():
		anim.play("stun_air")
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
						#MegamanAndItems.charge_timer=0
		
		elif Input.is_action_just_released("shoot"):
			if move_an_inch_checker>=10:
				if $anim.animation!="shoot_run":
						$anim.play("shoot_run")
			if move_an_inch_checker<10:
				anim.play("shoot_idle")
				#MegamanAndItems.charge_timer=0

	
	elif not is_on_floor():
		if not Input.is_action_pressed("shoot"):
			if $anim.animation!="shoot_in_air" or anim.animation!="stun_air":
				$anim.play("jump")
				#print("jump!")
		elif Input.is_action_pressed("shoot"):
			$anim.play("shoot_in_air")
			#print("shoot")
	

func shoot_and_charge():
	if Input.is_action_pressed("shoot"):
		
		MegamanAndItems.charge_timer+=1
		if MegamanAndItems.charge_timer==1:
			$all_sounds/charge.play()
	elif Input.is_action_just_released("shoot"):
		
		$all_sounds/charge.stop()
		if MegamanAndItems.charge_timer<30:
			$all_sounds/shoot.play()
			if is_on_floor():
				MegamanAndItems.charge_timer=0
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
				MegamanAndItems.charge_timer=0
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


		elif MegamanAndItems.charge_timer>=30 and MegamanAndItems.charge_timer<45:
			$all_sounds/halfcharge.play()
			if is_on_floor():
				MegamanAndItems.charge_timer=0
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
				MegamanAndItems.charge_timer=0
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


		elif MegamanAndItems.charge_timer>=45:
			$all_sounds/fullcharge.play()
			if is_on_floor():
				MegamanAndItems.charge_timer=0
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
				MegamanAndItems.charge_timer=0
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
		if MegamanAndItems.charge_timer==1:
			$all_sounds/charge.play()
		MegamanAndItems.charge_timer+=1
	if Input.is_action_just_released("shoot"):
		pass
		$all_sounds/charge.stop()
		
		if MegamanAndItems.charge_timer<30:
			$all_sounds/shoot.play()
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
			
		elif MegamanAndItems.charge_timer>=30 and MegamanAndItems.charge_timer<45:
			$all_sounds/halfcharge.play()
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
		elif MegamanAndItems.charge_timer>=45:
			$all_sounds/fullcharge.play()
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
		MegamanAndItems.charge_timer=0
		
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

func dash_function(delta):
	if is_on_floor():
		if Input.is_action_just_pressed("dash"):
			dash.start_dash(dashduration)
			if anim.flip_h==false:
				var direction=-1
				velocity.x=-30000*delta
				move_and_slide()
			elif anim.flip_h==true:
				var direction=1
				velocity.x=30000*delta
				move_and_slide()
		if Input.is_action_pressed("dash"):
			if $dash/Timer.time_left>0:
				anim.play("dash")
			elif $dash/Timer.time_left<=0:
				velocity.x=0
				anim.play("idle")

func chargeeffect():
	if MegamanAndItems.charge_timer==0:
		$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		$anim.material.set_shader_parameter("bodycolori",(Vector4(136.0,232.0,255.0,255.0))/255)
		$anim.material.set_shader_parameter("bodycolorii",(Vector4(0.0,98.0,247.0,255.0))/255)
	elif MegamanAndItems.charge_timer>0 and MegamanAndItems.charge_timer<30:
		if MegamanAndItems.charge_timer%10==1:
			#print('mega chargeeffect:active1')
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif MegamanAndItems.charge_timer%10==5:
			#print('mega chargeeffect:active1:2')
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif MegamanAndItems.charge_timer>=30 and MegamanAndItems.charge_timer<45:
		if MegamanAndItems.charge_timer%10==1:
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif MegamanAndItems.charge_timer%10==5:
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif MegamanAndItems.charge_timer>=45:
		#$animated_sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		if MegamanAndItems.charge_timer%10==1:
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
			$anim.material.set_shader_parameter("bodycolori",(Vector4(0.0,0.0,0.0,255.0))/255)
			$anim.material.set_shader_parameter("bodycolorii",(Vector4(0.0,98.0,247.0,255.0))/255)
		elif MegamanAndItems.charge_timer%10==5:
			$anim.material.set_shader_parameter("bodycolori",(Vector4(136.0,232.0,255.0,255.0))/255)
			$anim.material.set_shader_parameter("bodycolorii",(Vector4(0.0,0.0,0.0,255.0))/255)
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,98.0,247.0,255.0))/255)

var rush_jet=preload("res://players/weapons/rush_jet.tscn");var rush_jet_instance
func create_weapons():
	if Input.is_action_just_pressed("shoot"):
		match GlobalScript.weapon_number:
			1:
				rush_coil_instance=rush_coil.instantiate()
				get_parent().add_child(rush_coil_instance)
				if anim.flip_h==true:
					rush_coil_instance.global_position=Vector2(global_position.x+50,global_position.y-100)
				elif anim.flip_h==false:
					rush_coil_instance.global_position=Vector2(global_position.x-50,global_position.y-100)
			2:
				rush_jet_instance=rush_jet.instantiate()
				get_parent().add_child(rush_jet_instance)
				if anim.flip_h==true:
					rush_jet_instance.global_position=Vector2(global_position.x+50,global_position.y-100)
				elif anim.flip_h==false:
					rush_jet_instance.global_position=Vector2(global_position.x-50,global_position.y-100)

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
		anim.pause()

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
			GlobalScript.previous_health=GlobalScript.health #previous health used to check increasign health,collects the health of the player
			GlobalScript.health-=area.get_parent().playerdamagevalue#this transfers a value of damage from the enemy to the player  #2,before,the player's health actually gets reduced
			$all_sounds/stun.play()
			stun_effect=true
			climb=false
	if area.is_in_group("ladders"):
		near_ladder=true
	if area.is_in_group("rushjet"):
		#$anim.play("idle")
		onrush=true
func _on_hitbox_area_exited(area):
	if area.is_in_group("ladders"):
		near_ladder=false
		climb=false
		#print("Megaman:about to leave ladder")

#var 
var ladder_collider:Object
func _on_hitbox_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
	#if area.is_in_group("ladders"):
		ladder_collider=area.shape_owner_get_owner(area_shape_index)
		#print(ladder_collider,'of Area:',area)


func _on_hitbox_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	pass





func _on_restart_timer_timeout():
	get_tree().reload_current_scene()


func _on_zone_body_entered(body):
	pass
func change_collisions():
	if anim.animation==("jump"):
		if anim.flip_h==true:
			$CollisionShape2D.position=Vector2(10.333,-2.667)
		elif anim.flip_h==false:
			$CollisionShape2D.position=Vector2(-8.333,-2.667)
	else:
		$CollisionShape2D.position=Vector2(2.667,3.333)


func _on_display_timer_timeout():
	$weapon_display.visible=false
func delete_weapons():
	if GlobalScript.weapon_number!=1:
		get_tree().call_group('rush_coil','delete')
	elif GlobalScript.weapon_number!=2:
		get_tree().call_group('rush_jet','delete')
