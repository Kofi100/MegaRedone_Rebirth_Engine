extends enemy
#var state:String=""
var timer:int=0
var player_in_zone=false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var shield_hitbox = $shield_hitbox
var bullet=preload("res://enemy/sniper_joe_bullet.tscn");var bullet_ins
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var timer1:int=0
var proj_spawn_timer:int=0

func _ready():
	health=8
	playerdamagevalue=3
	state="defend"
	animated_sprite_2d.flip_h=false
	animated_sprite_2d.offset.x=8
	$shield_hitbox/right.disabled=true
var change=0
func _physics_process(delta):
	spawn_collectables()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play("jump")
	#var player=get_parent().get_parent().get_parent().get_node("megaman")
	#print(player)
	#print(scale.x)
	if player_in_zone:
		#print(player.global_position.x-global_position.x)
		#print("player is in zone")
		if GlobalScript.playerposx-global_position.x<0:
#			if change<5:
#				change+=1
#				if change==1:
#					scale.x=-3
				#print("hello")
				#scale.x=3;change=0
			animated_sprite_2d.flip_h=false
			animated_sprite_2d.offset.x=8
			$shield_hitbox/left.disabled=false
			$shield_hitbox/right.disabled=true
		elif GlobalScript.playerposx-global_position.x>0:
			animated_sprite_2d.flip_h=true
			animated_sprite_2d.offset.x=-8
			$shield_hitbox/left.disabled=true
			$shield_hitbox/right.disabled=false
#			if change<5:
#				change+=1
#				if change==1:
#					if scale.x>0:
#						scale.x=-3
		timer1+=1
		#print('sniper_joe:timer1:',timer1)
		if timer1<60:
			#print("sniper_joe:timer1<60:,working")
			state="defend"
		if timer1>=60 and timer1<=120:
#			if state!="shoot":
				state="shoot"

		if timer1==200:
			timer1=0
	else:
		state="defend"
		change=0
		timer1=0
	match state:
		"defend":
			proj_spawn_timer=0
			animated_sprite_2d.play("defend")
			shield_hitbox.set_collision_layer_value(1,true)
		"shoot":
			animated_sprite_2d.play("shoot")
			shield_hitbox.set_collision_layer_value(1,false)
			if animated_sprite_2d.frame==1:
				
				proj_spawn_timer+=1
				if proj_spawn_timer==10 or proj_spawn_timer==30 or proj_spawn_timer==50:
					$all_sounds/shoot.play()
					if animated_sprite_2d.flip_h==false:
						bullet_ins=bullet.instantiate()
						get_parent().add_child(bullet_ins)
						bullet_ins.direction="left"
						bullet_ins.global_position=$all_shoot_positions/left.global_position
					elif animated_sprite_2d.flip_h==true:
						bullet_ins=bullet.instantiate()
						get_parent().add_child(bullet_ins)
						bullet_ins.direction="right"
						bullet_ins.global_position=$all_shoot_positions/right.global_position
					#insert porj. code here
					#print("shoot proj. here")
		"jump":
			proj_spawn_timer=0
			animated_sprite_2d.play("jump")

	move_and_slide()


func _on_detect_player_body_entered(body):
	if body.is_in_group("player"):
		player_in_zone=true
	


func _on_detect_player_body_exited(body):
	if body.is_in_group("player"):
		player_in_zone=false


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
