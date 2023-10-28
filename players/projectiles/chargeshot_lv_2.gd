extends CharacterBody2D
var state="active"
const SPEED = 50000.0
@export var direction="left"

func _ready():
	match direction:
		"left":
			pass
		"right":
			pass
	$anim.play("chargeshot_lv2_new")
	


func _physics_process(delta):
	match state:
		"active":
			match direction:
				"left":
					rotation_degrees=180
					velocity.x=-SPEED*delta
				"right":
					velocity.x= SPEED*delta
		"blocked":
			match direction:
				"left":
					rotation_degrees=180
					velocity=Vector2(SPEED,-SPEED)*delta
				"right":
					velocity=Vector2(-SPEED,-SPEED)*delta
	move_and_slide()


func _on_collision_monitor_area_entered(area):
	if area.is_in_group("enemy") and not area.is_in_group("blockables"):
		#print('works!')
		if state=="active":
			area.get_parent().health-=3
			queue_free()
	if area.is_in_group("blockables"):
		state="blocked"

func _on_collision_monitor_body_entered(_body):
#	if body.is_in_group("tilemaps"):
#		queue_free()
	pass


func _on_onscreen_screen_exited():
	queue_free()
