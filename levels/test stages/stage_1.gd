extends Node2D
@onready var player_cam=$megaman/player_camera
@onready var camera_1 = $all_cameras/camera1
@onready var camera_2 = $all_cameras/camera2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$bgm_stage1.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#$ParallaxLayer.motion_offset.x-=100*delta
	pass

func _on_z_1_body_entered(body):
	if body.is_in_group("player"):
		pass
		StageFunctions.switch_camera(player_cam,camera_1)


func _on_z_2_body_entered(body):
	if body.is_in_group("player"):
		pass
		StageFunctions.switch_camera(player_cam,camera_2)
		$megaman/timer_switch_cameras.start()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		#if body.trans_right==false:
		if body.velocity.x>0:
			body.trans_right=true
#		elif body.trans_right==true:
#			body.trans_right=false


func _on_bgm_stage_1_finished():
	$bgm_stage1.play(0)
