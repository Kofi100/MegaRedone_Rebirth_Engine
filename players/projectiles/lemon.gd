extends CharacterBody2D


const SPEED = 50000.0
const JUMP_VELOCITY = -400.0
@export var direction="left"
@onready var anim = $anim

func _ready():
	match direction:
		"left":
			scale.x=-3
		"right":
			pass


func _physics_process(delta):
	match direction:
		"left":
			velocity.x=-SPEED*delta
		"right":
			velocity.x=SPEED*delta
	move_and_slide()


func _on_collision_monitor_area_entered(area):
	pass # Replace with function body.


func _on_collision_monitor_body_entered(body):
	if body.is_in_group("tilemaps"):
		queue_free()
