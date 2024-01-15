extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var distancex;var distancey;var shooting_activated=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distancex=GlobalScript.playerposx-global_position.x
	distancey=GlobalScript.playerposy-global_position.y
	if abs(distancex)<=200:
		$AnimatedSprite2D.play("default")
		if not shooting_activated:
			$shoot_timer.start();shooting_activated=true
	elif abs(distancex)>200:
		$shoot_timer.stop()
		$AnimatedSprite2D.stop()
		shooting_activated=false
		


func _on_shoot_timer_timeout():
	var projectile=preload('res://enemy/original/original_projs/ceiling_shooter_proj.tscn')
	var projectile_ins=projectile.instantiate()
	var angle=atan2(distancey,distancex)
	projectile_ins.angle_to_go=angle
	get_parent().add_child(projectile_ins)
	projectile_ins.global_position=global_position
	$shoot_audio_effect.play()
