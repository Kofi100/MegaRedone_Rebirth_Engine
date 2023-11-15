extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D


@export var SPEED = 30000.0 #6750
@export var JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	state='walk'
	health=1
	playerdamagevalue=3

func _physics_process(delta):
	if not is_on_floor():
		velocity.y+=gravity*delta
	
	var distance=GlobalScript.playerposx-global_position.x
	if distance<=0:
		velocity.x=-SPEED*delta
	elif distance>0:
		velocity.x=SPEED*delta
	
	if velocity.x<=0:
		animated_sprite_2d.flip_h=false
	elif velocity.x>0:
		animated_sprite_2d.flip_h=true
	
	match state:
		'walk':
			animated_sprite_2d.play("walk")
			if is_on_wall():
				state='jump'
				velocity.y=JUMP_VELOCITY
		'jump':
			if animated_sprite_2d.animation!='jump':
				animated_sprite_2d.play('jump')
			if is_on_floor() and velocity.y>=0:
				state='walk'
		'stop':
			velocity.x=0
	
	if health<=0:
		state='stop'
		#velocity.x=0
		countdown_delete+=1
		$explosion.set_emitting(true)#emit_particle()
		$explosion_container/explosion_hitbox/CollisionShape2D2.disabled=false
		$AnimatedSprite2D.visible=false
		$hitbox/CollisionShape2D.disabled=true
		if countdown_delete==20:
			spawn_collectables()
	move_and_slide()
var countdown_delete=0

func _on_hitbox_body_entered(body):
	if body.is_in_group('player'):
#		health-=1
		pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)
