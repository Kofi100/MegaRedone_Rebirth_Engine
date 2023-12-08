extends enemy

@onready var animation_player = $Sprite2D/AnimationPlayer

@export var SPEED = 3000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#func _init(delta):
#	pass
#	velocity.x=-SPEED*delta
var timer_wall=0
func _ready():
	#velocity.x=-SPEED*delta
	pass
var timer=0
func _physics_process(delta):
	playerdamagevalue=5
	animation_player.play("electric_gabyoall")
	timer+=1*delta
	velocity.x=SPEED*delta
	if timer<0.1:
		velocity.x=-SPEED*delta
	if not is_on_floor():
		velocity.y+=gravity*delta
	if is_on_wall():
		timer_wall+=1*delta
		if timer_wall>0.1:
			if SPEED==-abs(SPEED):
				SPEED=abs(SPEED)
			elif SPEED==abs(SPEED):
				SPEED=-abs(SPEED)
			timer_wall=0
	if not $RayCast_Left.is_colliding() and not is_on_wall():
		SPEED=abs(SPEED)
	if not $RayCast_Right.is_colliding() and not is_on_wall():
		SPEED=-abs(SPEED)

	move_and_slide()
