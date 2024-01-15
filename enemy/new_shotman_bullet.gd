extends enemy
@export_category('Variables')
@export var SPEED = 7000.0
@export var direction=''
var gravity=980
var index_bullet=0
var dis_x;var dis_y;var angle_to_shoot
func _ready():
	playerdamagevalue=1
	dis_x=GlobalScript.playerposx-global_position.x
	dis_y=GlobalScript.playerposy-global_position.y
	angle_to_shoot=atan2(dis_y,dis_x)

func _physics_process(delta):
	match direction:
		'left':
			velocity.x=-SPEED*delta
		'right':
			velocity.x=SPEED*delta
		'shoot-up':
			velocity.x=-SPEED*delta
			velocity.y=SPEED*delta
		'gravity':
#			if not is_on_floor():
#				velocity.y+=gravity*delta
			velocity.y=sin(angle_to_shoot)*SPEED*delta
			velocity.x=cos(angle_to_shoot)*gravity*delta
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free();pass # Replace with function body.
