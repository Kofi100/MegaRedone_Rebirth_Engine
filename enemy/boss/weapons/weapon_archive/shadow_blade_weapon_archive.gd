extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D


@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var direction=''

func _ready():
	#$shadow_blade.play()
	playerdamagevalue=3
	match direction:
		'diagonal_left','diagonal_right':
			animated_sprite_2d.play("spawn_upright")
		'move_left','move_right':
			animated_sprite_2d.play("spawn_upright")

func _physics_process(delta):
	if $timers/go_one_way_timer.time_left>0:
		animated_sprite_2d.play('blade_ready')
		match direction:
			'diagonal_left':
				velocity.y=-SPEED*delta
				velocity.x=-SPEED*delta
			'diagonal_right':
				velocity.y=-SPEED*delta
				velocity.x=SPEED*delta
			'move_left':
				velocity.x=-SPEED*delta
			'move_right':
				velocity.x=SPEED*delta
	elif $timers/go_one_way_timer.time_left<=0:
		match direction:
			'diagonal_left':
				velocity.y=SPEED*delta
				velocity.x=SPEED*delta
			'diagonal_right':
				velocity.y=SPEED*delta
				velocity.x=-SPEED*delta
			'move_left':
				velocity.x=SPEED*delta
			'move_right':
				velocity.x=-SPEED*delta
			'diagonal_left,move_left':
				pass
	
	move_and_slide()


func _on_detect_thrower_body_entered(body):
	if body.is_in_group('weapon_archive'):
		if $timers/go_one_way_timer.time_left<=0:
			print('shadow blade collided with weapon archive capsule')
			queue_free()


func _on_stay_timer_timeout():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
