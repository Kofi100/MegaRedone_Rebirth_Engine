extends enemy
#var enemy_class=enemy.new()
var gravity=ProjectSettings.get_setting('physics/2d/default_gravity')
# Called when the node enters the scene tree for the first time.

var player_around:bool=false
var distancex;var distancey;var shooting_activated=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	pass # Replace with function body.
	health=5

func _physics_process(delta):
	playerdamagevalue=4
	#health=5
	spawn_collectables()
	distancex=GlobalScript.playerposx-global_position.x
	distancey=GlobalScript.playerposy-global_position.y
	#enemy_class.playerdamagevalue=4
	if not is_on_floor():velocity.y-=gravity*delta
	if player_around:
		$AnimatedSprite2D.play("default")
		if not shooting_activated:
			$shoot_timer.start();shooting_activated=true
	else:
		$shoot_timer.stop()
		$AnimatedSprite2D.stop()
		shooting_activated=false
		
	move_and_collide(velocity)

func _on_shoot_timer_timeout():
	if is_physics_processing()==true:
		var projectile=preload('res://enemy/original/original_projs/ceiling_shooter_proj.tscn')
		var projectile_ins=projectile.instantiate()
		var angle=atan2(distancey,distancex)
		projectile_ins.angle_to_go=angle
		get_parent().add_child(projectile_ins)
		projectile_ins.global_position=$shoot_position.global_position
		$shoot_audio_effect.play()


func _on_detect_area_2d_area_entered(area):
	pass # Replace with function body.
	if area.is_in_group('player_constants_checker_area2d'):
		player_around=true


func _on_detect_area_2d_area_exited(area):
	pass # Replace with function body.
	if area.is_in_group('player_constants_checker_area2d'):
		player_around=false


func _on_visible_on_screen_notifier_2d_screen_exited():
	pass # Replace with function body.
	queue_free()
