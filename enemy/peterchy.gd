extends enemy


@export var SPEED = 5000
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	playerdamagevalue=3
	health=8
	state='move'
	var distance_to_player=global_position-Vector2(GlobalScript.playerposx,GlobalScript.playerposy)
	if distance_to_player.x<0:
		velocity.x=-SPEED
	elif distance_to_player.x>0:
		velocity.x=SPEED

func _physics_process(delta):
	#uncomment this and enable Label to be visible to see Peterchy's speed
	$Label_Speed.text=str(SPEED);
	#$index.text=str(index)
	var distance=GlobalScript.playerposx-global_position.x
	if not is_on_floor():
		velocity.y += gravity * delta
	if velocity.x<0:animated_sprite_2d.flip_h=false
	elif velocity.x>0:animated_sprite_2d.flip_h=true
	if active:
		match state:
			'move':
				animated_sprite_2d.play("moving")
				if distance<0:velocity.x=-SPEED*delta
				elif distance>=0:velocity.x=SPEED*delta
#				if animated_sprite_2d.frame!=0 and animated_sprite_2d.frame!=1 and animated_sprite_2d.frame!=5:
				
				#if not $check_right_has_ground.is_colliding():#distance<=0:
					#velocity.x=-SPEED*delta
				#elif not $check_left_has_ground.is_colliding():
					#velocity.x=SPEED*delta
#				else:
#					velocity.x=0
			'move_away_left':
				velocity
	spawn_collectables()
	move_and_slide()

var active=false
func _on_visible_on_screen_enabler_2d_screen_entered():
	active=true


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
	#get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)
