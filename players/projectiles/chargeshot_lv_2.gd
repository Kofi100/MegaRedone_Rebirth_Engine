extends CharacterBody2D
var state="active"
@export var SPEED = 50000.0
@export var direction="left"

func _ready():
	match direction:
		"left":
			$anim.offset.x=-8
		"right":
			$anim.offset.x=8
	$anim.play("chargeshot_lv2_new2")
	


func _physics_process(delta):
	match state:
		"active":
			match direction:
				"left":
					#rotation_degrees=180
					$anim.flip_h=true
					velocity.x=-SPEED*delta
				"right":
					$anim.flip_h=false
					velocity.x= SPEED*delta
		"blocked":
			match direction:
				"left":
					#rotation_degrees=180
					$anim.flip_h=true
					velocity=Vector2(SPEED,-SPEED)*delta
				"right":
					$anim.flip_h=false
					velocity=Vector2(-SPEED,-SPEED)*delta
		'stopped':
			velocity.x=0
			$collision_monitor/CollisionShape2D.disabled=true
			$anim.visible=false
	move_and_slide()


func _on_collision_monitor_area_entered(area):
	if area.is_in_group("enemy") and not area.is_in_group("blockables"):
		#print('works!')
		if state=="active" or state=='blocked':
			area.get_parent().health-=5
			state='stopped'
			$hurt_enemy_effect.play()
			#queue_free()
	if area.is_in_group("blockables"):
		state="blocked"

func _on_collision_monitor_body_entered(_body):
#	if body.is_in_group("tilemaps"):
#		queue_free()
	pass


func _on_onscreen_screen_exited():
	queue_free()


func _on_hurt_enemy_effect_finished():
	queue_free()
