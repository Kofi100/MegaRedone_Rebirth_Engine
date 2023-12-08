extends enemy

@export_category('Values')
@export var SPEED = 300.0
@export var direction=''
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	playerdamagevalue=3

func _physics_process(delta):
	animated_sprite_2d.play("ice_slasher")
	match direction:
		'left':
			velocity.x=-SPEED*delta
			animated_sprite_2d.flip_h=false
		'right':
			velocity.x=SPEED*delta
			animated_sprite_2d.flip_h=true

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
