extends enemy

@export var number_of_projectiles=8
const SPEED = 4950.0/2
const JUMP_VELOCITY = -400.0
@export var dynamic_distance=32
@export var rotation_speed=500
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var new_projectile
func _ready():
	$Timer.start()
	health =2
	var spacing=2*PI/number_of_projectiles
	for no in range(number_of_projectiles):
		var pos=Vector2(dynamic_distance,0).rotated(spacing * no)
		const ENEMY_2_PROJECTILES = preload("res://enemy/original/original_projs/enemy_2_projectiles.tscn")
		new_projectile=ENEMY_2_PROJECTILES.instantiate()
		new_projectile.position=pos
		$Node2D.add_child(new_projectile)
	var distance=GlobalScript.playerposx-global_position.x
	if distance<0:
		direction="left"
	elif distance>=0:
		direction="right"
var direction;var distance;var distance_not_change=false
func _physics_process(delta):
	distance=GlobalScript.playerposx-global_position.x
	if $VisibleOnScreenNotifier2D.is_on_screen()==false:
		queue_free()
	#print(name,":$Timer.time_left->",$Timer.time_left)
	$Timer.one_shot=false
	playerdamagevalue=3
	#print(direction)
	if distance_not_change==false:
		if distance<0:
			direction="left"
		elif distance>=0:
			direction="right"
		distance_not_change=true
	move_and_slide()
	spawn_collectables()
	match direction:
		"left":
			velocity.x=-SPEED*delta
			$AnimatedSprite2D.frame=0
		"right":
			velocity.x=SPEED*delta
			$AnimatedSprite2D.frame=1
	var distance_x=GlobalScript.playerposx-global_position.x
	#if distance_x<0:
		#$AnimatedSprite2D.frame=0
	#elif distance_x>=0:
		#$AnimatedSprite2D.frame=1
	var new_rotation=$Node2D.rotation_degrees+rotation_speed*delta
	$Node2D.rotation_degrees=fmod(new_rotation,360)
	
	if $Timer.time_left>=$Timer.wait_time/2:
		#dynamic_distance+=10
		$Node2D.scale+=Vector2(.5,.5)*delta
	elif $Timer.time_left<$Timer.wait_time/2:
		dynamic_distance-=10
		$Node2D.scale-=Vector2(.5,.5)*delta#.1
