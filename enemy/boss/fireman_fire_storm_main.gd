extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D


var  SPEED = 7000.0
func _physics_process(delta):
#region Debug Zone
	#debug
	#print("is: ",name,": (f_storm:main :an object?)->",is_class("Object"))
	
#endregion
	playerdamagevalue=7
	match state:
		"left":
			velocity.x=-SPEED*delta
			animated_sprite_2d.flip_h=false
		"right":
			velocity.x=SPEED*delta
			animated_sprite_2d.flip_h=true

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free();
	#print("yesss")


func _on_timer_timeout():
	pass
	#var small_fire=preload("res://enemy/boss/fireman_fire_storm_small.tscn").instantiate()
	#small_fire.position=position
	#get_parent().add_child(small_fire)
