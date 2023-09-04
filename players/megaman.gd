extends CharacterBody2D
var climb=false
var move_an_inch_checker=0
var charge_timer=0
const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var lemon=preload("res://players/projectiles/lemon.tscn")
var lemon_ins
var chargeshot_lv1=preload("res://players/projectiles/chargeshot_lv_1.tscn");var chargeshot_lv1_ins
var chargeshot_lv2=preload("res://players/projectiles/chargeshot_lv_2.tscn");var chargeshot_lv2_ins
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	$charge_timer.text=str(charge_timer)
	
	# Add the gravity.
	

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#print(move_an_inch_checker)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if climb==false:
		if not is_on_floor():
			velocity.y += gravity * delta
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			move_an_inch_checker+=1
			if not is_on_floor():
				velocity.x = direction * SPEED
			else:
				if move_an_inch_checker<10:
					velocity.x=direction *20
				else:
					velocity.x=direction*SPEED
		else:
			move_an_inch_checker=0
			velocity.x = move_toward(velocity.x, 0, SPEED)
		play_animations()
		shoot_and_charge()
		if $anim.animation=="shoot_idle":
			if $anim.flip_h==false:
				$anim.offset.x=-6
			elif $anim.flip_h==true:
				$anim.offset.x=6
		else:
			$anim.offset.x=0
	elif climb==true:
		velocity.x=0
		#print("clim:true")
		if was_leaving==false:
			if Input.is_action_pressed("move_up"):
				$anim.play("climb")
				
			elif Input.is_action_pressed("move_down"):
				#velocity.y=100
				$anim.play_backwards("climb")
#		if $change_climb_detector/CollisionShape2D
		elif was_leaving==true:
			#print("about to leave ladder")
			$anim.play("climb_transition")
			
	#these codes are for playing animations
		if Input.is_action_pressed("move_up"):
			velocity.y=-100
		elif Input.is_action_pressed("move_down"):
			velocity.y=100
		elif not (Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")):
			$anim.pause()
			velocity.y=0
	
	move_and_slide()

func play_animations():
	if is_on_floor():
		if (not Input.is_action_pressed("shoot") or (Input.is_action_pressed("shoot") and not Input.is_action_just_released("shoot"))):
			if move_an_inch_checker>=10:
				if $anim.animation!="shoot_run":
					if velocity.x<0:
						$anim.play("run")
						$anim.flip_h=false
					elif velocity.x>0:
						$anim.play("run")
						$anim.flip_h=true

			elif move_an_inch_checker<10:
				if velocity.x<0:
					$anim.play("move_by_inch")
					$anim.flip_h=false
				elif  velocity.x>0:
					$anim.play("move_by_inch")
					$anim.flip_h=true
				else:
					if $anim.animation!="shoot_idle":
						$anim.play("idle")
		elif Input.is_action_just_released("shoot"):
			if move_an_inch_checker>=10:
				if $anim.animation!="shoot_run":
					if velocity.x<0:
						$anim.play("shoot_run")
						$anim.flip_h=false
					elif velocity.x>0:
						$anim.play("shoot_run")
						$anim.flip_h=true
	
	if is_on_floor(): #this codes check for 
		if velocity.x==0:
#			if  (not Input.is_action_pressed("shoot")): #or (Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot")):
#				$anim.play("idle")
			if Input.is_action_just_released("shoot"):
				if $anim.animation!="shoot_idle":
					$anim.play("shoot_idle")
		elif velocity.x<0:
			if Input.is_action_just_released("shoot"):
				$anim.play("shoot_run")
				$anim.flip_h=false
		elif velocity.x>0:
			if Input.is_action_just_released("shoot"):
				$anim.play("shoot_run")
				$anim.flip_h=true
		
	elif not is_on_floor():
		if not Input.is_action_pressed("shoot"):
			if $anim.animation!="shoot_in_air":
				$anim.play("jump")
				print("jump!")
		elif Input.is_action_pressed("shoot"):
			$anim.play("shoot_in_air")
			print("shoot")
		if velocity.x<0:
			$anim.flip_h=false
		elif velocity.x>0:
			$anim.flip_h=true

func shoot_and_charge():
	if Input.is_action_pressed("shoot"):
		charge_timer+=1
	elif Input.is_action_just_released("shoot"):
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




func _on_anim_animation_finished():
	if $anim.animation=="shoot_run":
		$anim.play("run")
	
	if $anim.animation=="shoot_idle":
		$anim.play("idle")
		
	if $anim.animation=="shoot_in_air":
		$anim.play("jump")

var was_leaving=false
func _on_change_climb_detector_area_entered(area):
	if area.is_in_group("ladders"):
		was_leaving=false


func _on_change_climb_detector_area_exited(area):
	if area.is_in_group("ladders"):
		was_leaving=true
