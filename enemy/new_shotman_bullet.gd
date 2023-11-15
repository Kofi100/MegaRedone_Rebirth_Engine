extends enemy
var SPEED = 7000.0
var direction=''
var gravity=980
var index_bullet=0
func _ready():
	playerdamagevalue=1

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
			if not is_on_floor():
				velocity.y+=gravity*delta
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free();pass # Replace with function body.
