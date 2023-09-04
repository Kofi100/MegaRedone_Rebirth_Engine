extends Area2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_zone==true:
		pass
	if on_top==true:
		if Input.is_action_pressed("move_down"):
			collision_shape.position=$Marker2D.position
		else:
			collision_shape.position=$Marker2D2.position


func _on_area_entered(area):
	pass

var in_zone:bool=false
func _on_body_entered(body):
	if body.is_in_group("player"):
		#collision_shape.disabled=true
		collision_shape.position=$Marker2D.position
		if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") and not body.is_on_floor():
			print("input up pressed near ladder")
			body.global_position.x=$Marker2D2.global_position.x
			body.climb=true
			


func _on_body_exited(body):
	if body.is_in_group("player"):
			collision_shape.position=$Marker2D2.position
			body.climb=false
			#collision_shape.disabled=false

var on_top=false
func _on_ontop_body_entered(body):
	if body.is_in_group("player"):
		on_top=true



func _on_ontop_body_exited(body):
	if body.is_in_group("player"):
		on_top=false
