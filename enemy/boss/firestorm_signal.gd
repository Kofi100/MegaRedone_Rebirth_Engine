extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state
func _ready():
	#direction='up'
	pass
func _physics_process(delta):
	match state:
		"up":
			velocity.y=-5000*delta
			move_and_slide()
			if is_on_ceiling() and state!='stop':
				state='stop'
				
				#var fs1=
				var fs1=preload("res://enemy/boss/firestorm_signal.tscn").instantiate()
				fs1.state='spread_left'
				fs1.global_position=global_position
				get_parent().add_child(fs1)
				#print("fs1 created")
				var fs2=preload("res://enemy/boss/firestorm_signal.tscn")
		"stop":
			velocity.x=0
			velocity.y=0
		'spread_left':
			
			var distances=[10,20,30,40,50]
			if a==false:
				for number in distances:
					print("spreadign left?")
					var proj=preload("res://enemy/boss/firestorm_signal.tscn")
					var proj_main=proj.instantiate()
					get_parent().add_child(proj_main)
					proj_main.global_position.x=global_position.x -(number*2)
					proj_main.global_position.y=global_position.y
				a=true
var a=false
