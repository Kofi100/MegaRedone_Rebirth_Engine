extends StaticBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animated_sprite_2d_2 = $AnimatedSprite2D2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#grepl=Vector4i(255,255,0,255)/255;wrepl=Vector4i(255,0,0,255)/255
	#change_color(animated_sprite_2d,grepl,wrepl)
	if animated_sprite_2d.animation=='open_close':
		if animated_sprite_2d.frame==4:
			$CollisionShape2D.disabled=true
		else:
			$CollisionShape2D.disabled=false
	if GlobalScript.playerposx>$detect_right/CollisionShape2D2.global_position.x:
		if not exited_door:
			animated_sprite_2d.frame=0
			animated_sprite_2d_2.frame=0




func _on_detect_left_body_entered(body):
	if body.is_in_group('player'):
		body.stop=true
		body.door_transition=true
		animated_sprite_2d.play("open_close")
		animated_sprite_2d_2.play("open_close")
		$door_enter_close.play()

var exited_door=false
func _on_detect_right_body_entered(body):
	if body.is_in_group('player'):
		exited_door=true
		animated_sprite_2d.play_backwards("open_close")
		animated_sprite_2d_2.play_backwards("open_close")
		$door_enter_close.play()

func _on_detect_right_body_exited(body):
	if body.is_in_group('player'):
		body.stop=false
		body.door_transition=false
		$detect_right.set_collision_mask_value(2,false)
		body.velocity.x=0
		#$detect_right/CollisionShape2D2.disabled=true
#		$detect_right/CollisionShape2D2.call_deferred('is_disabled',true)#'is_disabled',true)
		#$detect_right/CollisionShape2D2.disabled=true
#var grepl:Vector4;var wrepl:Vector4;#var animated_sprite:AnimatedSprite2D
func change_color(sprite:AnimatedSprite2D,grepl:Vector4,wrepl:Vector4):
	pass
	sprite.material.set_shader_parameter('greyrep',grepl)
	sprite.material.set_shader_parameter('whiterep',wrepl)
	print('Gray new:',grepl,'...,White new:',wrepl)
