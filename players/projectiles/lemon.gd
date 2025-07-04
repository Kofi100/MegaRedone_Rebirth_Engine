extends CharacterBody2D


@export var SPEED = 50000.0
const JUMP_VELOCITY = -400.0
@export var direction="left"
var state="active"
@onready var anim = $anim
var damagevalue=1
func _ready():
	GlobalScript.lemons_on_screen_no+=1
	match direction:
		"left":
			scale.x=-1
		"right":
			pass


func _physics_process(delta):
	match state:
		"active":
			match direction:
				"left":
					velocity.x=-SPEED*delta
				"right":
					velocity.x=SPEED*delta
		"blocked":
			match direction:
				"left":
					velocity=Vector2(SPEED,-SPEED)*delta
				"right":
					velocity=Vector2(-SPEED,-SPEED)*delta
		'stopped':
			velocity.x=0
			$collision_monitor/CollisionShape2D.disabled=true
			$anim.visible=false
	move_and_slide()


func _on_collision_monitor_area_entered(area):
	if area.is_in_group("enemy") and not area.is_in_group("blockables"):
		#print('lemons:works!')
		if state=="active" or state=='blocked':
			area.get_parent().health-=damagevalue#1#area.get_parent().enemyreceivedamagevalue
			state='stopped'
			$hurt_enemy_effect.play()
			GlobalScript.score+=10
			#queue_free()
	if area.is_in_group("blockables"):
		state="blocked"


func _on_collision_monitor_body_entered(body):
	#if body is TileMap:#is_in_group("tilemaps"):
		#queue_free()
	pass


func _on_onscreen_screen_exited():
	queue_free()


func _on_hurt_enemy_effect_finished():
	pass # Replace with function body.
	queue_free()


func _on_tree_exiting():
	GlobalScript.lemons_on_screen_no-=1
