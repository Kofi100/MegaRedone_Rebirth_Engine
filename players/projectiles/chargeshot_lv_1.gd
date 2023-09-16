extends CharacterBody2D

const SPEED = 50000.0
@export var direction="left"
var state="active"
func _ready():
	match direction:
		"left":
			pass
		"right":
			pass
	$anim.play("chargeshot_lv1")
	


func _physics_process(delta):
	match direction:
		"left":
			rotation_degrees=180
			velocity.x=-SPEED*delta
		"right":
			velocity.x= SPEED*delta
	move_and_slide()


func _on_collision_monitor_body_entered(body):
	if body.is_in_group("tilemaps"):
		queue_free()


func _on_collision_monitor_area_entered(area):
	pass # Replace with function body.
