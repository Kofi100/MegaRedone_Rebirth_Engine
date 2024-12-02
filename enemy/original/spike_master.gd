extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D


const SPEED = 3950.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var initial_direction:String
var active:bool=false
func _process(delta):
	if GlobalScreenTransitionTimer.is_stopped()==false:
		set_physics_process(false)
	elif GlobalScreenTransitionTimer.is_stopped()==true:
		set_physics_process(true)
	#print("any spike master.is_physics_proessing():",is_physics_processing())

func _physics_process(delta):
	
	var distance=GlobalScript.playerposx-global_position.x
	if distance>100 and active==false and not is_on_wall() and is_physics_processing()==true:
		active=true
		animated_sprite_2d.play("activate")
	if active==true:
		$spike_zones/CollisionShape2D.disabled=false
		match initial_direction:
			"left":
				velocity.x=-SPEED*delta
			"right":
				velocity.x=SPEED*delta
			"up":
				pass
		move_and_slide()
	elif active==false:
		$spike_zones/CollisionShape2D.disabled=true
	if is_on_wall():
		active=false
		if animated_sprite_2d.animation!="deactivate" and animated_sprite_2d.animation!="idle":
			animated_sprite_2d.play("deactivate")
		#$spike_zones/CollisionShape2D.disabled=true

func _on_spike_zones_body_entered(body):
	if body.is_in_group("player"):
		GlobalScript.health=0


func _on_detect_player_zone_body_entered(body):
	if body.is_in_group("player"):
		$detect_player_zone/CollisionShape2D.disabled=true
		active=true


func _on_animated_sprite_2d_animation_finished():
	match animated_sprite_2d.animation:
		"activate":
			animated_sprite_2d.play("active")
		"deactivate":
			animated_sprite_2d.play("idle")
