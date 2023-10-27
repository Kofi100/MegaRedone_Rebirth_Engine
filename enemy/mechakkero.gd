extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer_to_jump = $timer_to_jump


@export var SPEED = 5000.0
@export var JUMP_VELOCITY = -400.0
var jumped=false #checks if the frog has jumped already/not
# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 980

func _ready():
	state='on_ground'
	playerdamagevalue=3
	health=7
var active=false
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if active==true:
		var distance= GlobalScript.playerposx-global_position.x
		if velocity.x<0:
			animated_sprite_2d.flip_h=false
		elif velocity.x>0:
			animated_sprite_2d.flip_h=true
		

		#state 
		match state:
			'on_ground':
				jumped=false
				velocity.x=0
				if animated_sprite_2d.animation!='on_ground':
					animated_sprite_2d.play("on_ground")
			'jump':
				if animated_sprite_2d.animation!='jump':
					animated_sprite_2d.play("jump")
				if is_on_floor():
					animated_sprite_2d.frame=0
				else:
					animated_sprite_2d.frame=1
				if is_on_floor() and velocity.y>=0:
					state='on_ground'
				if not is_on_floor()  and not jumped:
					jumped=true
					if distance<=0:
						velocity.x=-SPEED*delta
					elif distance>0:
						velocity.x=SPEED*delta
	spawn_collectables()
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	match animated_sprite_2d.animation:
		'on_ground':
			timer_to_jump.start()


func _on_timer_to_jump_timeout():
	velocity.y=JUMP_VELOCITY
	state='jump'


func _on_visible_on_screen_notifier_2d_screen_entered():
	active=true
