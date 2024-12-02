extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var targetx=0;var targety=0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var active=false
var direction
func _ready():
	for i in get_tree().current_scene.get_children():
		if i is enemy :
			#var closest_x=mini(i.global_position.x,i.global_position.x)
			if abs(i.global_position-Vector2(GlobalScript.playerposx,GlobalScript.playerposy))<Vector2(100,100):
				active=true
				var targetx=i.global_position.x
				var targety=i.global_position.y
func _physics_process(delta):
	# Add the gravity.
	#for i in get_tree().current_scene.get_children():
		#if i is enemy :
			##var closest_x=mini(i.global_position.x,i.global_position.x)
			#if abs(i.global_position-Vector2(GlobalScript.playerposx,GlobalScript.playerposy))<Vector2(100,100):
	if active==true:
			#targetx=i.global_position.x
			#targety=i.global_position.y
			var movex=move_toward(global_position.x,targetx,50*delta)
			var movey=move_toward(global_position.y,targety,50*delta)
			global_position.x=movex;global_position.y=movey
			look_at(Vector2(movex,movey))
			
		#else:
			#velocity.x=3000*delta
	else:
		if direction=="left":
			velocity.x=-3000*delta
		elif direction=="right":
			velocity.x=3000*delta
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
