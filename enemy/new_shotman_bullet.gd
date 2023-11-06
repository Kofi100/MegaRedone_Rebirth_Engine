extends enemy
var SPEED = 7000.0
var direction=''
var gravity=980
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
