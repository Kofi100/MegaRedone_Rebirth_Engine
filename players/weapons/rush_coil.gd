extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var spawn_in_speed=30000
@export var spawn_back_speed=120000
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var stop_normal_movements:bool=false
var spawn_rush=false
var spawn_back=false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var play=0
func _ready():
	animated_sprite_2d.play("idle")
	spawn_rush=true
var spawn_play=0;var just_landed:bool=false
func _physics_process(delta):
	if is_on_floor() and not just_landed:#reutnr to u later
		$move_back_timer.start()
		just_landed=true
	# Add the gravity.
	if spawn_rush==true:
		stop_normal_movements=true
		spawn_play+=1
		if spawn_play==1:
			$AnimatedSprite2D.play("spawn")
		velocity.y=spawn_in_speed*delta
		#$CollisionShape2D.disabled=true
		$jump_zone/CollisionShape2D.disabled=true
		#if GlobalScript.playerposy==global_position.y:
		if is_on_floor():
			stop_normal_movements=false
			spawn_rush=false
		move_and_slide()
	elif spawn_rush==false and spawn_back==false:
		stop_normal_movements=false
		$CollisionShape2D.disabled=false
		spawn_play=0
	
	if !stop_normal_movements:
		play+=1
		if play==1:
			animated_sprite_2d.play("idle")
		if not is_on_floor():
			velocity.y += gravity * delta
		$CollisionShape2D.disabled=false
		$jump_zone/CollisionShape2D.disabled=false
	
		move_and_slide()
	#print($move_back_timer.time_left)
	#print(GlobalScript.playerposy)
	if spawn_back==true:
		stop_normal_movements=true
		spawn_play+=1
		if spawn_play==1:
			animated_sprite_2d.play("spawn")
		velocity.y=-spawn_back_speed*delta
		$CollisionShape2D.disabled=true
		$jump_zone/CollisionShape2D.disabled=true
		move_and_slide()
	offset()

func offset():
	if animated_sprite_2d.animation=="spawn":
		animated_sprite_2d.offset=Vector2(-3,3)
	else:
		animated_sprite_2d.offset=Vector2.ZERO
func _on_jump_zone_body_entered(body):
	if body.is_in_group("player"):
		body.velocity.y=(-1200/3)
		animated_sprite_2d.play("spring")
		$move_back_timer.start()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation=="spring":
		animated_sprite_2d.play("idle")
		


func _on_move_back_timer_timeout():
	spawn_back=true


func _on_visible_on_screen_notifier_2d_screen_exited():
	#queue_free()
	pass
func delete():queue_free()
