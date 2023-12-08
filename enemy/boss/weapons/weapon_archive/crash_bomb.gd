extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D
var target_index=0
var angle_to_go_in=0
@export var SPEED = 3000.0
const JUMP_VELOCITY = -400.0
var dis
func _ready():
	dis=GlobalScript.playerposx-global_position.x
	if dis<0:
		animated_sprite_2d.flip_h=true
	elif dis>=0:
		animated_sprite_2d.flip_h=false
	playerdamagevalue=3

func _physics_process(delta):
	# Add the gravity.
	dis=GlobalScript.playerposx-global_position.x
	#print($hitbox/in_air.is_disabled(),',,,',$hitbox/landed.is_disabled())
	if is_on_floor() or is_on_wall():
		velocity.y=0
		velocity.x=0
	if not is_on_floor() and not is_on_wall():
		velocity.y=sin(angle_to_go_in)*80000*delta
		velocity.x=cos(angle_to_go_in)*80000*delta
#		if not direction_bool:
#			direction_bool=true
#			if dis<0:
#				velocity.x=tan(-45)*8000*delta
#			elif dis>0:
#				velocity.x=tan(45)*8000*delta
		animated_sprite_2d.play("in_air")
		$hitbox/in_air.disabled=false;
		$hitbox/landed_right.disabled=true;$hitbox/landed_left.disabled=true
		if velocity.x<0:
			animated_sprite_2d.flip_h=true
		elif velocity.x>=0:
			animated_sprite_2d.flip_h=false
	#if velocity.y>0:
	if is_on_floor() or is_on_wall():
		if not on_surface:
			$hitbox/in_air.disabled=true;
			if animated_sprite_2d.flip_h==false:
				$hitbox/landed_right.disabled=false;$hitbox/landed_left.disabled=true
			elif animated_sprite_2d.flip_h==true:
				$hitbox/landed_right.disabled=true;$hitbox/landed_left.disabled=false
			on_surface=true
			animated_sprite_2d.play("landed")
			$self_destruct_timer.start()
	
	move_and_slide()
var on_surface=false
var direction_bool=false
func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("planted")


func _on_self_destruct_timer_timeout():
	animated_sprite_2d.visible=false
	$explosion_effect.set_emitting(true)
	$destroy_node_timer.start()
	$hitbox/in_air.disabled=true;
	if animated_sprite_2d.flip_h==false:
		$hitbox/landed_right.disabled=false;$hitbox/landed_left.disabled=true
	elif animated_sprite_2d.flip_h==true:
		$hitbox/landed_right.disabled=true;$hitbox/landed_left.disabled=false
		


func _on_destroy_node_timer_timeout():
	queue_free()
