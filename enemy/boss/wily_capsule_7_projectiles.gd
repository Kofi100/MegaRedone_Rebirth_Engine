extends enemy


var SPEED = 7000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var angle_to_go
var got_player_position=false;var posx;var posy;
var current_player_pos_x;var current_player_pos_y;
#var 
func _ready():
	state="trackPlayer"
func _physics_process(delta):
	calculate_player_distance()
	playerdamagevalue=7
	match state:
		"trackPlayer":
			if got_player_position==false:#get last player pos
				current_player_pos_x=GlobalScript.playerposx-global_position.x
				current_player_pos_y=GlobalScript.playerposy-global_position.y
				got_player_position=true
			angle_to_go=atan2(current_player_pos_y,current_player_pos_x)
			velocity.y=sin(angle_to_go)*SPEED*delta
			velocity.x=cos(angle_to_go)*SPEED*delta
			#posx=move_toward(global_position.x,current_player_pos_x,300*delta)
			#posy=move_toward(global_position.y,current_player_pos_y,300*delta)
			#global_position=Vector2(posx,posy)
			if is_on_floor() or is_on_ceiling() or is_on_wall():
				$CollisionShape2D.disabled=true
		"gotoGround":
			if not is_on_floor():
				velocity.y=3000*delta
			if is_on_floor():
				velocity.x=3000*delta
				velocity.y=0
			if is_on_wall():
				$CollisionShape2D.disabled=true
				queue_free()

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
