extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var animated_sprite_template:AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	#connect("body_entered",change_gravity_to_less)

func change_gravity_to_less():
	pass
var player_previous_gravity:float=0
func _on_body_entered(body):
	if body.is_in_group("player"):
		player_previous_gravity=body.gravity
		body.gravity=500
		if body.anim!=null:
			body.anim.speed_scale=0.5#8
		body.isInWater=true
		#animated_sprite_template.pl
		#print("dey playyy")
 


func _on_body_exited(body):
	if body.is_in_group("player"):
		body.gravity=player_previous_gravity
		if body.anim!=null:
			body.anim.speed_scale=1.0
		body.isInWater=false
