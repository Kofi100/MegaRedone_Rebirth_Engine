extends enemy

@export var direction:String="left"
const SPEED = 3000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move:String
var abouttomove_down=0;var abouttomove_left=0

func _ready():
	playerdamagevalue=2
	health=5

func _physics_process(delta):
	#print("Octopus battery:aboutto_left":abouttomove_left)
	$health.text=str(health)
	spawn_collectables()
	match move:
		"up":
			velocity.y-=SPEED*delta
		"down":
			velocity.y+=SPEED*delta
		"left":
			velocity.x-=SPEED*delta
		"right":
			velocity.x+=SPEED*delta
	match direction:
		"up":
			pass
			if is_on_ceiling():
				abouttomove_down+=1
				if abouttomove_down>=100:
					move="down"
					abouttomove_down=0
			if is_on_floor():
				abouttomove_down+=1
				if abouttomove_down>=100:
					move="up"
					abouttomove_down=0
		"left":
			if is_on_wall():
				if $RayCast2D_left.is_colliding():
					abouttomove_left+=1
					if abouttomove_left>=100:
						move="right"
						abouttomove_left=0
				if $RayCast2D_right.is_colliding():
					abouttomove_left+=1
					if abouttomove_left>=100:
						move="left"
						abouttomove_left=0
	if direction=="up":
		if velocity.y==0:
			play_anim2=0
			play_anim+=1
			if play_anim==1:
				$AnimatedSprite2D.play_backwards("red")
		elif velocity.y!=0:
			play_anim=0
			play_anim2+=1
			if play_anim2==1:
				$AnimatedSprite2D.play("red")
	elif direction=="left":
		if velocity.x==0:
			play_anim2=0
			play_anim+=1
			if play_anim==1:
				$AnimatedSprite2D.play_backwards("red")
		elif velocity.x!=0:
			play_anim=0
			play_anim2+=1
			if play_anim2==1:
				$AnimatedSprite2D.play("red")
	move_and_slide()
var play_anim=0;var play_anim2=0
