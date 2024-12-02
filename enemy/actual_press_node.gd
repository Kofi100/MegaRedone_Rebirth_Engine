extends enemy
@onready var press = $".."


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var trigger=false;var has_touch_floor=false



var distancex
func _physics_process(delta):
	##
	#print(name,"[trigger,has_touch_floor,$fall_timer.time_left]",[trigger,has_touch_floor,$fall_timer.time_left])
	#print(name,":distancex->",distancex)
	#print(is_on_ceiling())
	#print(name,":$fall_timer.time_left->",$fall_timer.time_left)
	##
	playerdamagevalue=3
	distancex=(GlobalScript.playerposx - global_position.x)
	$chains_Line.set_point_position(1,($distance_RayCast.get_collision_point()-global_position+Vector2(0,16)))
	if abs(distancex)<50: #and $fall_timer.time_left<=0:
		#print(abs(distancex))
		if trigger==false and not is_on_floor() and $fall_timer.time_left<=0:
			trigger=true
	if trigger==true:
		if has_touch_floor==false:
			velocity.y=5000*delta
		if is_on_floor():
			velocity.y=0;has_touch_floor=true
			if has_touch_floor==true:
				#has_touch_floor=false
				velocity.y=-5000*delta
		if is_on_ceiling() and trigger==true: #or (global_position.y<press.global_position.y-20):#or
			trigger=false
			has_touch_floor=false
			$fall_timer.start()
			print("trigger sent to false")
	if $fall_timer.time_left>0 and is_on_ceiling():
		trigger=false
		
	move_and_slide()
