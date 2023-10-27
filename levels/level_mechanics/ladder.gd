extends Area2D
@onready var topplatforms = $top_platforms


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(on_top)
	#print(topplatforms.get_collision_layer_value(4))
	if in_zone==true:
		pass
	if on_top==true:
		if Input.is_action_just_pressed("move_down"):
			topplatforms.set_collision_layer_value(4,false)
	#print(get_collision_layer_value(4))

func _on_area_entered(_area):
	pass

var in_zone:bool=false
##This function is meeant to detect whether the player has entered the ladder's zone or not.
func _on_body_entered(body):
	if body.is_in_group("player"):
		#collision_shape.disabled=true
		topplatforms.set_collision_layer_value(4,false)
		#collision_shape.position=$Marker2D.position
		if Input.is_action_pressed("move_up")and not body.is_on_floor():
			print("input up pressed near ladder")
			#body.global_position.x=$Marker2D2.global_position.x
			body.climb=true
			
##This function is meeant to detect whether the player has entered the ladder's zone or not.
##Sets the position of the top platform back to its original position originally
func _on_body_exited(body):
	if body.is_in_group("player"):
			#collision_shape.position=$Marker2D2.position
			body.climb=false
			topplatforms.set_collision_layer_value(4,true)
			#collision_shape.disabled=false

var on_top=false
func _on_ontop_body_entered(body):
	if body.is_in_group("player"):
		on_top=true



func _on_ontop_body_exited(body):
	if body.is_in_group("player"):
		on_top=false
