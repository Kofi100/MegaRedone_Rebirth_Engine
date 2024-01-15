extends enemy


@export var SPEED = 3000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	playerdamagevalue=4
	health=5

func _physics_process(delta):
	# Add the gravity.
	spawn_collectables()
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x=SPEED*delta
	
	var distance=GlobalScript.playerposx-global_position.x
	animated_sprite_2d.play("default")
#	if distance<0:
	animated_sprite_2d.flip_h=false;position.x-=10*delta
#	elif distance>0:
#		animated_sprite_2d.flip_h=true;position.x+=10*delta
	move_and_slide()


func _on_move_front_back_timer_timeout():
	if SPEED>0:
		SPEED=-abs(SPEED)
	elif SPEED<0:
		SPEED=abs(SPEED)


func _on_hitbox_block_area_entered(area):
	if area.is_in_group('player_projectiles'):
		area.get_parent().state='blocked'
		print(name,': blocked->',area.get_parent().name)
