extends CharacterBody2D
##This value keeps the path of the AnimatedSprite2D used for Megaman.
@onready var anim = $anim
##This value keeps the path of the dash node used for Megaman to deterimine his speed.
@onready var dash = $dash
@onready var animation_player = $AnimationPlayer
@onready var animation_player_2 = $AnimationPlayer2

##This is the default speed which can be adjusted by dashing.
@export var SPEED = 0
##This value deterimines how high a person can jump.
@export var JUMP_VELOCITY = -300#-340#-4950#orig: -333*3 almost=1000
##This value defines how much gravity is applied by the engine to the player.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var gravity=900#1000#3000
@export var dashspeed=10080#10000#3000/3;
@export var max_gravity=25200
var dashduration=0.3
@export var normalspeed=4950#5800 #17500.0=5800/3
var climb=false
var move_an_inch_checker=0
@export var move_an_inch_speed=720#1000
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
var weapon_number:int=0;var max_weapon_number=3
var screen_transition_finished=false
var restart_scene=false
var conveyor_push=3000;var on_conveyor=false
var player_ready:bool=false
var in_teleporter=false
var key_dictionary:Array
var isInWater:bool=false
@onready var trigger_leave_timer = $trigger_leave_timer
@onready var leave_timer = $leave_timer

func _ready():
	#key_dictionary.resize(9)
	#GlobalScript.playerposx=0
	#GlobalScript.playerposy=0
	GlobalScript.lemons_on_screen_no=0
	GlobalScript.playerhasbeenhit=false
	GlobalScript.trigger_boss=false
	GlobalScript.previous_Level_Entered=get_tree().current_scene.get_scene_file_path()

	#GlobalScript.playerhitcooldowntimer=0
	player_ready=false
	anim.play("idle")
	anim.visible=false
#	if restart_scene==true:
#		get_tree().reload_current_scene()
#		restart_scene=false
	GlobalScreenTransitionTimer.stop()
	if GlobalScript.restarted_level==false:
		GlobalScript.score=0
		GlobalScript.reset_level_timer()
		GlobalScript.start_level_timer()
		GlobalScript.save_savepoint_data()
	elif GlobalScript.restarted_level==true:
		GlobalScript.start_level_timer()
		GlobalScript.load_savepoint_data()
		global_position.x=GlobalScript.playerposx
		global_position.y=GlobalScript.playerposy
	MegamanAndItems.charge_timer=0
	GlobalScript.weapon_number=0
	MegamanAndItems.weapon1energy=30
	MegamanAndItems.weapon2energy=30
	MegamanAndItems.weapon3energy=30
	GlobalScript.health=GlobalScript.max_health
	$weapon_display.visible=false
	$player_camera.position_smoothing_enabled=false
	$hitbox/CollisionShape2D.disabled=true
var onrush=false;var disable_input=false
var switch_state=0
var door_transition=false

func debug_print_custom(name_of_node,var_name_to_be_displayed,variable_name):
	print(name_of_node,':',str(var_name_to_be_displayed),': ',variable_name)

func leaving(delta):
	stop=true
	for i in get_tree().current_scene.get_children(true):
		if i.is_class('AudioStreamPlayer') or i.is_class('AudioStreamPlayer2D'):
			i.stop()
	if $leave_timer.time_left<=0:
		velocity.y=0
		if anim.animation!="spawn":
			anim.play("spawn")
		if anim.animation=="spawn" and anim.frame==2:
			velocity.y=-10000*delta
			
			$CollisionShape2D.disabled=true
			$hitbox/CollisionShape2D.disabled=true
			$player_constants_checker_area2d/CollisionShape2D.disabled=true
				
	else:
		velocity.y+=gravity*delta
		if not is_on_floor():anim.play("jump")
		else:
			anim.play("idle")
	move_and_slide()
var leave_bool=false;var has_played_victory_sound:bool=false
func _physics_process(delta):
#region reverse Gravity
	#code for reverse gravity
	#gravity=-980
	#self.scale.y=-1
#endregion
	#if in_teleporter==true:
		#GlobalSc
	if leave_bool==true:
		if has_played_victory_sound==false:
			has_played_victory_sound=true
			$all_sounds/level_cleared.play()
			
		velocity.x=0
		$hitbox/CollisionShape2D.disabled=true
		#leaving(delta)
	if $reset_cam_entry.time_left>0:
		$player_constants_checker_area2d/CollisionShape2D.disabled=true
	elif $reset_cam_entry.time_left<=0:
		$player_constants_checker_area2d/CollisionShape2D.disabled=false
	#print($player_constants_checker_area2d/CollisionShape2D.disabled)
#region Debug Zone
	##debug
	#print(name,':GScript:lemon_no:',GlobalScript.lemons_on_screen_no)
	#debug_print_custom(name,"GScript:lemon_no",GlobalScript.lemons_on_screen_no)
	#debug_print_custom(name,"cooldown_timer:time_left",$buster_cooldown_timer.time_left)
	#debug_print_custom(name,'stop,stun_effect,disable_input:',[stop,stun_effect,disable_input])
	#print(gravity)
	$charge_timer.text=str(MegamanAndItems.charge_timer)
	$speed.text=str(velocity*Vector2(pow(delta,1),pow(delta,1)))#*delta
	#print(JUMP_VELOCITY)
	#pow(delta,2)
	#print(ProjectSettings.get_setting("application/run/max_fps",0))
	##
#endregion
	#Limit gravity 
	velocity.y=clampf(velocity.y,-25200*delta,25200*delta) #since velocity is actually a value *delta
	
	#if velocity.y>25200*delta:
		#velocity.y=25200*delta
	
	if not player_ready:GlobalScreenTransitionTimer.stop()
	if GlobalScript.lemons_on_screen_no>=3 and $buster_cooldown_timer.time_left<=0:
		$buster_cooldown_timer.start()
	#conveyor_push=30000
	if door_transition:
		velocity.x=4950*delta
		velocity.y=0
		move_and_slide()
		stop=true
	if GlobalScreenTransitionTimer.time_left>0:
		$player_camera.position_smoothing_enabled=true
		stop=true
		screen_transition_finished=false
		if velocity.y>0:
			trans_down=true
		elif velocity.y<0:
			trans_up=true
		if velocity.x>0:
			trans_right=true
		elif velocity.x<0:
			trans_left=true

	elif GlobalScreenTransitionTimer.time_left<=0:
		if  not screen_transition_finished:
			$player_camera.position_smoothing_enabled=false
			stop=false
			trans_down=false;trans_up=false;
			trans_left=false;trans_right=false;
			
			screen_transition_finished=true
		

	if Input.is_action_just_pressed("die_debug"):
		GlobalScript.health=0
	GlobalScript.playerposx=global_position.x
	GlobalScript.playerposy=global_position.y

	
	if dash.is_dashing():
		SPEED=dashspeed 
	elif not on_conveyor :
		SPEED=normalspeed
	elif on_conveyor:
		SPEED=normalspeed-conveyor_push
	# Add the gravity.
	if is_on_floor():
	
		if jump_play_effect_timer<5:
			jump_play_effect_timer+=1
			if jump_play_effect_timer==1:
				
				$all_sounds/land.play()
				#animation_player_2.play('screen_shake') #for testing screen shake later
	elif not is_on_floor():
		jump_play_effect_timer=0
	#var tween=create_tween()
	if trans_right:
		#timer+=1
#		switch_state=0
#		stop=true
		velocity=Vector2(1000,0)*delta
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
#	elif trans_right==false:
#		switch_state+=1
#		#print('trans_right state:off')
#		if switch_state==1:
#			stop=false
	if trans_down:
		velocity=Vector2(0,1000)*delta
		move_and_slide()
		#tween.stop()
	if trans_up:
		velocity=Vector2(0,-1000)*delta
		move_and_slide()
	if trans_left:
		velocity=Vector2(-1000,0)*delta
		move_and_slide()
		
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

		#if $all_sounds/charge.get_playback_position()>2.04:
		##print("seek")
			#$all_sounds/charge.seek(1.90)
		if GlobalScript.playerhasbeenhit:
			$hitbox/CollisionShape2D.disabled=true
		elif not GlobalScript.playerhasbeenhit:
			$hitbox/CollisionShape2D.disabled=false
		change_collisions()
		
		if Input.is_action_just_pressed("switch_weapon_left"):
			GlobalScript.weapon_number-=1
			$weapon_display.visible=true
			$weapon_display/display_timer.start()
		elif Input.is_action_just_pressed("switch_weapon_right"):
			$weapon_display.visible=true
			GlobalScript.weapon_number+=1
			$weapon_display/display_timer.start()
		if isInWater:
			if $produce_Bubble_Timer.is_stopped():
				$produce_Bubble_Timer.start()
		else:$produce_Bubble_Timer.stop()
		$weapon_display.frame=GlobalScript.weapon_number
		#weapon_number=Input.get_axis("switch_weapon_left","switch_weapon_right")
		stun(delta)
		#plays stun blink effect
		if GlobalScript.playerhitcooldowntimer%5==1:
			anim.visible=false
		elif GlobalScript.playerhitcooldowntimer%5==3:
			anim.visible=true
		if player_ready and stop==false:

			# Handle Jump.
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				
			if Input.is_action_just_released("jump") and velocity.y<0:
				velocity.y=0
				
			if onrush==false:
				if GlobalScript.weapon_number==0:
					if $buster_cooldown_timer.time_left<=0:
						shoot_and_charge()
						MegamanAndItems.charge_effect(anim)
					#chargeeffect()
				else:
					MegamanAndItems.change_palette($anim)
					create_weapons()
					
				if climb==false:
					#if not stun_effect:
						if near_ladder:
							if Input.is_action_pressed("move_up"):
								climb=true
						if not is_on_floor():
							velocity.y += gravity * delta
						
						var direction = Input.get_axis("move_left", "move_right")
						if direction and not disable_input:
							move_an_inch_checker+=1
							if not is_on_floor():
								velocity.x = direction * SPEED *delta
							else:
								if move_an_inch_checker<10:
									velocity.x=direction *move_an_inch_speed*delta#1000 *delta
								elif on_conveyor:
									velocity.x=direction*(SPEED+conveyor_push) *delta
								elif not on_conveyor:
									velocity.x=direction*(SPEED) *delta
						else:
							move_an_inch_checker=0
							if not on_conveyor:
								velocity.x = move_toward(velocity.x, 0, SPEED)
							elif on_conveyor:
								velocity.x=conveyor_push*delta
						play_animations()
						dash_function(delta)
						#if anim.animation!="idle":

						if $anim.animation=="shoot_idle":
							if $anim.flip_h==false:
								$anim.offset.x=-3#-6
							elif $anim.flip_h==true:
								$anim.offset.x=3
						elif $anim.animation=="dash":
							$anim.offset.y=3
							
						else: 
							$anim.offset.x=0
							$anim.offset.y=0
					#else:
						#if stun_timer>1 and stun_timer<7:
							##print(stun_timer)
							#stun(delta)
							#disable_input=true
							#
						#stun_timer+=1;#print(stun_timer,' ',GlobalScript.playerhitcooldowntimer)
						#if stun_timer==7:
							#stun_timer=0
							#stun_effect=false
							#disable_input=false


					#This code uses a modulus of 5 to produce a blinking effect
					
				elif climb==true:
					if Input.is_action_pressed("jump"):
						climb=false
					
					if ladder_collider!=null:
						velocity.x=0
						global_position.x=ladder_collider.global_position.x
					#print("megaman:climb:true")
					play_animation_ladder()
					#shoot_and_charge_ladder()
					#MegamanAndItems.charge_effect(anim)
					#chargeeffect()

				#these codes are for playing animations
					var direction=Input.get_axis("move_up","move_down")
					if direction and anim.animation!="shoot_on_ladder" and not disable_input:
						velocity.y=direction*3500*delta
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
					$restart_timer.start(3.5)
					is_dead=true
					#anim.play('dead')
					var explosion_scene=preload('res://miscellenaous/effects/explosion_scene.tscn')
					var explosion_scene_instance_or_node=explosion_scene.instantiate()
					get_parent().add_child(explosion_scene_instance_or_node);explosion_scene_instance_or_node.global_position=global_position
					$all_sounds/dead.play()
			elif onrush==true:
				velocity.x=0
				MegamanAndItems.charge_timer=clampi(MegamanAndItems.charge_timer,0,5)
				if $buster_cooldown_timer.time_left<=0:
					shoot_and_charge()
				#chargeeffect()
				MegamanAndItems.charge_effect(anim)
				if $anim.animation=="shoot_idle":
					if $anim.flip_h==false:
						$anim.offset.x=-6
					elif $anim.flip_h==true:
						$anim.offset.x=6
				else:
					$anim.offset.x=0
				#if is_on_floor():
					if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
						if anim.animation!="shoot_idle" and anim.animation!="whistle_idle" :#or anim.animation!="stun"
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
#region debug whistle code by reposition it, i guess would work on it soon
			#if velocity.x==0 and $whistle_idle_trigger_timer.time_left<=0 and not Input.is_action_pressed("shoot") and not Input.is_action_pressed("jump")and MegamanAndItems.charge_timer<30:
				#$whistle_idle_trigger_timer.start()
				#print("megaman: whistle_timer cdn fulfilled")
#endregion
		elif stop==true:
			velocity=Vector2.ZERO
	elif is_dead:
		anim.visible=false
		GlobalScript.restarted_level=true
		GlobalScript.pause_level_timer()
		$hitbox/CollisionShape2D.disabled=true
		$CollisionShape2D.disabled=true

var dead_effect_timer=0
var stun_timer=0;@export var stun_speed=1200
func stun(delta):
	#if velocity.y>0:
		#velocity.y=0
	#if is_on_floor():
		#anim.play("stun")
	#elif not is_on_floor():
		#anim.play("stun_air")
	if anim.animation=='stun_air' and GlobalScript.health>0:
		disable_input=true
		stun_effect=true
		stop=true
		if anim.flip_h==false:
			velocity=Vector2(stun_speed,0)*delta
		elif anim.flip_h==true:
			velocity=Vector2(-stun_speed,0)*delta
		velocity.y=5000*delta
		move_and_slide()
	elif GlobalScript.health<=0:
		stop=false
	

func play_animations():
	if velocity.x<0:
		$anim.flip_h=false
	elif velocity.x>0:
		$anim.flip_h=true
	if is_on_floor():
		if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
			if anim.animation!='stun_air':
				if move_an_inch_checker>=10:
					if anim.animation!="shoot_run" :
							anim.play("run")
				elif move_an_inch_checker<10:
					if velocity.x!=0:
						$anim.play("move_by_inch")
					elif velocity.x==0:
						if $anim.animation!="shoot_idle" and anim.animation!="whistle_idle":
							$anim.play("idle")
						#MegamanAndItems.charge_timer=0
		
		elif Input.is_action_just_released("shoot")  and $buster_cooldown_timer.time_left<=0:
			if anim.animation!='stun_air':
				if move_an_inch_checker>=10:
					if anim.animation!="shoot_run":
						anim.play("shoot_run")
				if move_an_inch_checker<10:
					if anim.animation!='shoot_idle':
						anim.play("shoot_idle")
				#MegamanAndItems.charge_timer=0

	
	elif not is_on_floor():
		if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
			if $anim.animation!="shoot_in_air" and anim.animation!="stun_air":
				$anim.play("jump")
				#print("jump!")
		elif Input.is_action_just_released("shoot")  and $buster_cooldown_timer.time_left<=0:
			if anim.animation!='shoot_in_air' and anim.animation!='stun_air':
				$anim.play("shoot_in_air")
			#print("shoot")
	
var projectile
func shoot_and_charge():
	if MegamanAndItems.charge_timer==15:
		$all_sounds/charge.play()
	if Input.is_action_pressed("shoot"):
		
		MegamanAndItems.charge_timer+=1

	elif Input.is_action_just_released("shoot"):
		
		$all_sounds/charge.stop()
		if MegamanAndItems.charge_timer<30:#30
			projectile=lemon.instantiate();$all_sounds/shoot.play()
		elif MegamanAndItems.charge_timer>=30 and MegamanAndItems.charge_timer<75+30:
			projectile=chargeshot_lv1.instantiate();$all_sounds/halfcharge.play()
		elif MegamanAndItems.charge_timer>=75+30:
			projectile=chargeshot_lv2.instantiate();$all_sounds/fullcharge.play()
		MegamanAndItems.charge_timer=0

		#if MegamanAndItems.charge_timer<30:
		if projectile!=null:
			get_parent().add_child(projectile)
			if is_on_floor():
				MegamanAndItems.charge_timer=0
				if $anim.flip_h==false:
					#lemon_ins=lemon.instantiate()
					#get_parent().add_child(projectile)
					projectile.direction="left"
					projectile.global_position=$all_proj_spawn_points/ground_left.global_position
				elif $anim.flip_h==true:
					#projectile=lemon.instantiate()
					#get_parent().add_child(projectile)
					projectile.direction="right"
					projectile.global_position=$all_proj_spawn_points/ground_right.global_position
			elif not is_on_floor():
				MegamanAndItems.charge_timer=0
				if $anim.flip_h==false:
					#lemon_ins=lemon.instantiate()
					#get_parent().add_child(projectile)
					projectile.direction="left"
					projectile.global_position=$all_proj_spawn_points/air_left.global_position
				elif $anim.flip_h==true:
					#lemon_ins=lemon.instantiate()
					#get_parent().add_child(projectile)
					projectile.direction="right"
					projectile.global_position=$all_proj_spawn_points/air_right.global_position
			elif climb==true:
				if $anim.flip_h==false:
					#lemon_ins=lemon.instantiate()
					#get_parent().add_child(projectile)
					projectile.direction="left"
					projectile.global_position=$all_proj_spawn_points/air_left.global_position
				elif $anim.flip_h==true:
					#lemon_ins=lemon.instantiate()
					#get_parent().add_child(lemon_ins)
					projectile.direction="right"
					projectile.global_position=$all_proj_spawn_points/air_right.global_position
#
		#elif MegamanAndItems.charge_timer>=30 and MegamanAndItems.charge_timer<75:
			##$all_sounds/halfcharge.play()
			#if is_on_floor():
				#MegamanAndItems.charge_timer=0
				#if $anim.flip_h==false:
					#chargeshot_lv1_ins=chargeshot_lv1.instantiate()
					#get_parent().add_child(chargeshot_lv1_ins)
					#chargeshot_lv1_ins.direction="left"
					#chargeshot_lv1_ins.global_position=$all_proj_spawn_points/ground_left.global_position
				#elif $anim.flip_h==true:
					#chargeshot_lv1_ins=chargeshot_lv1.instantiate()
					#get_parent().add_child(chargeshot_lv1_ins)
					#chargeshot_lv1_ins.direction="right"
					#chargeshot_lv1_ins.global_position=$all_proj_spawn_points/ground_right.global_position
			#elif not is_on_floor():
				#MegamanAndItems.charge_timer=0
				#if $anim.flip_h==false:
					#chargeshot_lv1_ins=chargeshot_lv1.instantiate()
					#get_parent().add_child(chargeshot_lv1_ins)
					#chargeshot_lv1_ins.direction="left"
					#chargeshot_lv1_ins.global_position=$all_proj_spawn_points/air_left.global_position
				#elif $anim.flip_h==true:
					#chargeshot_lv1_ins=chargeshot_lv1.instantiate()
					#get_parent().add_child(chargeshot_lv1_ins)
					#chargeshot_lv1_ins.direction="right"
					#chargeshot_lv1_ins.global_position=$all_proj_spawn_points/air_right.global_position
#
#
		#elif MegamanAndItems.charge_timer>=75:
			#$all_sounds/fullcharge.play()
			#if is_on_floor():
				#MegamanAndItems.charge_timer=0
				#if $anim.flip_h==false:
					#chargeshot_lv2_ins=chargeshot_lv2.instantiate()
					#get_parent().add_child(chargeshot_lv2_ins)
					#chargeshot_lv2_ins.direction="left"
					#chargeshot_lv2_ins.global_position=$all_proj_spawn_points/ground_left.global_position
				#elif $anim.flip_h==true:
					#chargeshot_lv2_ins=chargeshot_lv2.instantiate()
					#get_parent().add_child(chargeshot_lv2_ins)
					#chargeshot_lv2_ins.direction="right"
					#chargeshot_lv2_ins.global_position=$all_proj_spawn_points/ground_right.global_position
			#elif not is_on_floor():
				#MegamanAndItems.charge_timer=0
				#if $anim.flip_h==false:
					#chargeshot_lv2_ins=chargeshot_lv2.instantiate()
					#get_parent().add_child(chargeshot_lv2_ins)
					#chargeshot_lv2_ins.direction="left"
					#chargeshot_lv2_ins.global_position=$all_proj_spawn_points/air_left.global_position
				#elif $anim.flip_h==true:
					#chargeshot_lv2_ins=chargeshot_lv2.instantiate()
					#get_parent().add_child(chargeshot_lv2_ins)
					#chargeshot_lv2_ins.direction="right"
					#chargeshot_lv2_ins.global_position=$all_proj_spawn_points/air_right.global_position
			

var switch_to=0
func shoot_and_charge_ladder():
	pass
	if Input.is_action_pressed("shoot"):
		if MegamanAndItems.charge_timer==1:
			$all_sounds/charge.play()
		MegamanAndItems.charge_timer+=1
	#if Input.is_action_just_released("shoot"):
		#pass
		#$all_sounds/charge.stop()
		#
		#if MegamanAndItems.charge_timer<30:
			#$all_sounds/shoot.play()
			##print("chrge over")
			#if $anim.flip_h==false:
				#lemon_ins=lemon.instantiate()
				#get_parent().add_child(lemon_ins)
				#lemon_ins.direction="left"
				#lemon_ins.global_position=$all_proj_spawn_points/air_left.global_position
			#elif $anim.flip_h==true:
				#lemon_ins=lemon.instantiate()
				#get_parent().add_child(lemon_ins)
				#lemon_ins.direction="right"
				#lemon_ins.global_position=$all_proj_spawn_points/air_right.global_position
			#
		#elif MegamanAndItems.charge_timer>=30 and MegamanAndItems.charge_timer<45:
			#$all_sounds/halfcharge.play()
			#if $anim.flip_h==false:
				#chargeshot_lv1_ins=chargeshot_lv1.instantiate()
				#get_parent().add_child(chargeshot_lv1_ins)
				#chargeshot_lv1_ins.direction="left"
				#chargeshot_lv1_ins.global_position=$all_proj_spawn_points/air_left.global_position
			#elif $anim.flip_h==true:
				#chargeshot_lv1_ins=chargeshot_lv1.instantiate()
				#get_parent().add_child(chargeshot_lv1_ins)
				#chargeshot_lv1_ins.direction="right"
				#chargeshot_lv1_ins.global_position=$all_proj_spawn_points/air_right.global_position
		#elif MegamanAndItems.charge_timer>=45:
			#$all_sounds/fullcharge.play()
			#if $anim.flip_h==false:
				#chargeshot_lv2_ins=chargeshot_lv2.instantiate()
				#get_parent().add_child(chargeshot_lv2_ins)
				#chargeshot_lv2_ins.direction="left"
				#chargeshot_lv2_ins.global_position=$all_proj_spawn_points/air_left.global_position
			#elif $anim.flip_h==true:
				#chargeshot_lv2_ins=chargeshot_lv2.instantiate()
				#get_parent().add_child(chargeshot_lv2_ins)
				#chargeshot_lv2_ins.direction="right"
				#chargeshot_lv2_ins.global_position=$all_proj_spawn_points/air_right.global_position
		#MegamanAndItems.charge_timer=0
		
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
		if Input.is_action_just_pressed("dash") and $dash/Timer.time_left<=0:
			dash.start_dash(dashduration)
			var dash_effect=preload('res://players/effects/dash_effect.tscn')
			var dash_effect_instance=dash_effect.instantiate()
			if anim.flip_h==false:
				dash_effect_instance.global_position=$dash_positions/left.global_position
				get_parent().add_child(dash_effect_instance)
				var direction=-1
				velocity.x=-10000*delta
				move_and_slide()
			elif anim.flip_h==true:

				dash_effect_instance.global_position=$dash_positions/right.global_position
				get_parent().add_child(dash_effect_instance)
				var direction=1
				velocity.x=10000*delta
				move_and_slide()
		if Input.is_action_pressed("dash"):
			if $dash/Timer.time_left>0:
				anim.play("dash")
			#elif $dash/Timer.time_left<=0:
				#velocity.x=0
				#anim.play("idle")

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
	elif MegamanAndItems.charge_timer>=30 and MegamanAndItems.charge_timer<75:
		if MegamanAndItems.charge_timer%10==1:
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif MegamanAndItems.charge_timer%10==5:
			$anim.material.set_shader_parameter("outlinecolor",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif MegamanAndItems.charge_timer>=75:
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
	MegamanAndItems.charge_timer=0
	if Input.is_action_just_pressed("shoot"):
		match GlobalScript.weapon_number:
			1:
				if MegamanAndItems.weapon1energy>0:
					MegamanAndItems.weapon1energy-=3
					rush_coil_instance=rush_coil.instantiate()
					get_parent().add_child(rush_coil_instance)
					if anim.flip_h==true:
						rush_coil_instance.global_position=Vector2(global_position.x+20,global_position.y-50)
					elif anim.flip_h==false:
						rush_coil_instance.global_position=Vector2(global_position.x-20,global_position.y-50)#100
			2:
				if MegamanAndItems.weapon2energy>0:
					MegamanAndItems.weapon2energy-=3
					rush_jet_instance=rush_jet.instantiate()
					get_parent().add_child(rush_jet_instance)
					if anim.flip_h==true:
						rush_jet_instance.global_position=Vector2(global_position.x,global_position.y-100)#+50
						rush_jet_instance.direction='right'
					elif anim.flip_h==false:
						rush_jet_instance.global_position=Vector2(global_position.x,global_position.y-100)
						rush_jet_instance.direction='left'
			3:
				if MegamanAndItems.weapon3energy>0:
					MegamanAndItems.weapon3energy-=2
					const MISSILE = preload("res://players/weapons/missile.tscn")
					var missile_instance=MISSILE.instantiate()
					get_parent().add_child(missile_instance)
					missile_instance.global_position=global_position
					match anim.flip_h:
						true:
							missile_instance.direction="right"
						false:
							missile_instance.direction="left"
func _on_anim_animation_finished():
	match anim.animation:
		"shoot_run":
			$anim.play("run")
		
		"shoot_idle":
			$anim.play("idle")
			
		"shoot_in_air":
			$anim.play("jump")
		"shoot_on_ladder":
			print("done")
			anim.play("climb")
			anim.pause()
		'spawn':
			player_ready=true
			$hitbox/CollisionShape2D.disabled=false
		'stun_air':
			#print(name,':stun_air animation done')
			disable_input=false
			stun_effect=false
			stop=false
			if is_on_floor():anim.play("idle")
			elif not is_on_floor():anim.play('jump')
			#elif climb==tru
	
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
			#GlobalScript.previous_health=GlobalScript.health #previous health used to check increasign health,collects the health of the player
			GlobalScript.health-=area.get_parent().playerdamagevalue#this transfers a value of damage from the enemy to the player  #2,before,the player's health actually gets reduced
			$all_sounds/stun.play()
			#stun_effect=true
			anim.play("stun_air")
			climb=false
	if area.is_in_group("ladders"):
		near_ladder=true
	if area.is_in_group("rushjet"):
		#$anim.play("idle")
		onrush=true
	if area.is_in_group('deathzone'):
		GlobalScript.health=0
	if area.is_in_group('capsules'):
		$all_sounds/energyup.play()
func _on_hitbox_area_exited(area):
	if area.is_in_group("ladders"):
		near_ladder=false
		climb=false
		#print("Megaman:about to leave ladder")

#var 
var ladder_collider:Object
func _on_hitbox_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
	if area.is_in_group("ladders"):
		ladder_collider=area.shape_owner_get_owner(area_shape_index)
		#print(ladder_collider,'of Area:',area)


func _on_hitbox_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	pass





func _on_restart_timer_timeout():
	get_tree().reload_current_scene()


#func change_collisions_old():
	#if anim.animation==("jump"):
		#if anim.flip_h==true:
			#$CollisionShape2D.position=Vector2(10.333,-2.667)
		#elif anim.flip_h==false:
			#$CollisionShape2D.position=Vector2(-8.333,-2.667)
	#else:
		#$CollisionShape2D.position=Vector2(2.667,3.333)


func _on_display_timer_timeout():
	$weapon_display.visible=false
func delete_weapons():
	if GlobalScript.weapon_number!=1:
		get_tree().call_group('rush_coil','delete')
	elif GlobalScript.weapon_number!=2:
		get_tree().call_group('rush_jet','delete')


func _on_timer_switch_cameras_timeout():
	$player_camera.position_smoothing_enabled=false
	stop=false
	trans_left=false;trans_right=false;trans_up=false;trans_down=false
func change_collisions():
	if anim.animation=='dash':
		$AnimationPlayer.play("dash")
	else:
		$AnimationPlayer.play("others")


func _on_start_timer_timeout():
	pass # Replace with function body.
	const SPAWN_IN_EFFECT = preload("res://miscellenaous/effects/spawn_in_effect.tscn")
	var spawn_in_effect_instance=SPAWN_IN_EFFECT.instantiate()
	spawn_in_effect_instance.global_position.x=global_position.x
	spawn_in_effect_instance.global_position.y=global_position.y-500
	get_parent().add_child(spawn_in_effect_instance)


func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.



func _on_animation_player_2_animation_finished(anim_name):
	pass # Replace with function body.
	match anim_name:
		'screen_shake':
			print('Megaman:AnimationPlayer:Screen shake done')


func _on_dash_timer_timeout():
	velocity.x=0


func _on_visible_on_screen_notifier_2d_screen_exited():
	#GlobalScript.health=0
	pass


func _on_bgm_finished():
	pass # Replace with function body.


func _on_trigger_leave_timer_timeout():
	get_tree().change_scene_to_file("res://levels/test stages/end_of_level_score_screen.tscn")


func _on_leave_timer_timeout():
	if$HUD/fade_out_effect/AnimationPlayer.current_animation!='fade_out':
			#$fade_out_effect.visible=true
			$HUD/fade_out_effect/AnimationPlayer.play("fade_out")
			$trigger_leave_timer.start()


func _on_whistle_idle_trigger_timer_timeout():
	anim.play("whistle_idle")
	print(name,"->whistle_timer: with a wait _time of:",$whistle_idle_trigger_timer.get("wait_time"), "::(s) ::timed out")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("spikeTiles"):
		if GlobalScript.playerhasbeenhit==false:
			GlobalScript.playerhasbeenhit=true
			GlobalScript.health-=8
			$all_sounds/stun.play()
			#stun_effect=true
			anim.play("stun_air")
			climb=false


func _on_produce_bubble_timer_timeout() -> void:
	var bubble=preload("res://miscellenaous/effects/bubble_particle.tscn").instantiate()
	bubble.global_position=global_position
	bubble.scale=Vector2(2,2)
	get_parent().add_child(bubble)
