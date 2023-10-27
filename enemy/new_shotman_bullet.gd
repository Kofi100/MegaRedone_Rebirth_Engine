extends enemy
var SPEED = 7000.0
var direction=''

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
	move_and_slide()
