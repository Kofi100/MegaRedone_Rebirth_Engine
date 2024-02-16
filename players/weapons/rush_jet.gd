extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D


@export var SPEED = 13500#100000.0
const JUMP_VELOCITY = -400.0
var state:String="spawn_in"
var direction:String
func _ready():
	state="spawn_in"
	var tween=create_tween()
	tween.tween_property(self,'position',Vector2(GlobalScript.playerposx,GlobalScript.playerposy),1)
	tween.connect('finished',tween_end)
	$CollisionShape2D.disabled=true
func _physics_process(delta):
	# Add the gravity.
	var megaman=get_parent().get_node("megaman")
#	if megaman:
#		print("rush jet:megaman reference:exists!")
	match state:
		"spawn_in":
			#print('spawn in')
			animated_sprite_2d.play("spawn")
			#velocity.y=10000*delta
			#if GlobalScript.playerposx>=global_position.x:
				#state="ready"
				#$AnimatedSprite2D.play("wait")
			move_and_slide()
		"spawn_out":
			animated_sprite_2d.play("spawn")
			velocity.y=-30000*delta
			velocity.x=0
			$CollisionShape2D.disabled=true
			$detect_megaman/CollisionShape2D.disabled=true
			move_and_slide()
		"ready":
			$CollisionShape2D.disabled=false
			if player_on_top and megaman:
				megaman.position=Vector2(global_position.x,global_position.y-10)
			#	megaman.velocity.y=0
				#global_position.x=GlobalScript.playerposx
				#velocity.x=4000*delta
				
				
				#var direction = Input.get_axis("move_left", "move_right")
				#if direction:
					#velocity.x = direction * SPEED *delta
				#else:
					#velocity.x = move_toward(velocity.x, 0, SPEED)
				#move_and_slide()
				var direction2=Input.get_axis("move_up","move_down")
				if direction2:
					velocity.y = direction2 * SPEED *delta
				else:
					velocity.y = move_toward(velocity.y, 0, SPEED)
				match direction:
					'left':
						velocity.x=-3000*delta
						animated_sprite_2d.flip_h=false
					'right':
						velocity.x=3000*delta
						animated_sprite_2d.flip_h=true
				move_and_slide()
				animated_sprite_2d.play("jet")
				if Input.is_action_just_pressed("jump"):
					player_on_top=false
				#play_animations()
			else:
				animated_sprite_2d.play("wait")
var player_on_top=false
func _on_detect_megaman_body_entered(body):
	if body.is_in_group("player"):
		player_on_top=true
	elif body is TileMap:
		print(name,'[rushjet]:collided with tilemap \nleaving tilemap now..')
		player_on_top=false
		state='spawn_out'
		#body.stop=true
		#print("rush jet:player detected")


func _on_detect_megaman_body_exited(body):
	if body.is_in_group("player"):
		player_on_top=false
		#body.stop=false

#func play_animations():
	#if Input.is_action_pressed("move_left"):
		#animated_sprite_2d.flip_h=false
	#elif Input.is_action_pressed("move_right"):
		#animated_sprite_2d.flip_h=true
	#animated_sprite_2d.play("jet")

func delete():queue_free()

func tween_end():
	state="ready"
	$AnimatedSprite2D.play("wait")
