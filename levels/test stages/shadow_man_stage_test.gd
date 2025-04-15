extends Node2D
@onready var player_camera=$megaman/player_camera
#all stage cameras
#@onready var camera=$all_cameras/camera
#@onready var camera2=$all_cameras/camera2
#@onready var camera_3 = $all_cameras/camera3;
@onready var background_music = $bgm
#@onready var camera_4 = $all_cameras/camera4
#@onready var camera_5 = $all_cameras/camera5
#@onready var camera_6 = $all_cameras/camera6
#@onready var camera_7 = $all_cameras/camera7
#@onready var camera_8 = $all_cameras/camera8
#@onready var camera_9 = $all_cameras/camera9

var greyrep=Vector4(240,188,60,255)/255
var whiterep=Vector4(252,252,252,255)/255
var audio_streams={"shadow_man":preload("res://assets/music/Mega Man 3 (NES) Music - Shadow Man Stage.mp3")}
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.set_stage_name("SHADOWMAN\n STAGE TEST")
	StageFunctions.play_music_audioplayer(background_music,audio_streams.get("shadow_man"),0)
	print(greyrep,'....',whiterep)
	#$megaman.global_position=$Marker2D2.global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Door.
	#Door.change_color($all_doors/door/AnimatedSprite2D,greyrep,whiterep);
	#Door.
	#Door.change_color($all_doors/door/AnimatedSprite2D2,greyrep,whiterep)
	######## moving missile codes #########
	#var new_pos=move_toward($missile.global_position.x,GlobalScript.playerposx,100*delta)
	#var new_pos2=move_toward($missile.global_position.y,GlobalScript.playerposy,100*delta)
	#$missile.global_position.x=new_pos;$missile.global_position.y=new_pos2
	##################
	# code to find size of map and map it accordingly
	#print($TileMap.get_used_rect())
	#var tilesize=$TileMap.get_used_rect()
	#var tsize=tilesize.size
	#print($TileMap.get_used_rect().size/Vector2i($megaman/HUD/map.get_size()))
	$megaman/HUD/map/player.position=Vector2(GlobalScript.playerposx/(13440/200),GlobalScript.playerposy/(5527/100))
	#var mega=get_parent().get_node("megaman")
#	if mega:
	if $timer_switch_cameras.time_left>0:
		$TileMap.set_process(true)
		if $megaman.velocity.y>0:
			$megaman.trans_down=true
	elif $timer_switch_cameras.time_left==0:
		$TileMap.set_process(false)
	if GlobalScript.health<=0:
		background_music.stop()
	#if GlobalScreenTransitionTimer
	
	$bg/ParallaxLayer/ParallaxLayer2.motion_offset.y+=50*delta
	if background_music.playing:
		if background_music.stream==audio_streams.get("shadow_man"):\
#		if background_music.get_playback_position()>=65:
#			background_music.play(0)
			pass
#	if timer_switch_cameras.time_left>0:
#		GlobalScript.spawn_enemy=false
#	elif timer_switch_cameras.time_left==0:
#		GlobalScript.spawn_enemy=true
	#print(get_tree().has_group('player'))
@onready var timer_switch_cameras = $timer_switch_cameras

#func _on_zone_body_entered(body):
#	if body.is_in_group("player"):
#		StageFunctions.switch_camera(player_camera,camera)
#		timer_switch_cameras.start()


#func _on_zone_2_body_entered(body):
	#if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera,camera2)
		#timer_switch_cameras.start()
		#player_camera.position_smoothing_enabled=true
#
#func _on_zone_3_body_entered(body):
	#if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera,camera_3)
		#timer_switch_cameras.start()
		#player_camera.position_smoothing_enabled=true
#
#func _on_zone_4_body_entered(body):
	#if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera,camera_4)
		#timer_switch_cameras.start()
		#player_camera.position_smoothing_enabled=true
#
#func _on_zone_5_body_entered(body):
	#if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera,camera_5)
		#timer_switch_cameras.start()
		#player_camera.position_smoothing_enabled=true
#
#
#func _on_zone_6_body_entered(body):
	#if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera,camera_6)
		#timer_switch_cameras.start()
		#player_camera.position_smoothing_enabled=true

func _on_timer_switch_cameras_timeout():
	player_camera.position_smoothing_enabled=false
	$megaman.trans_down=false
	$megaman.stop=false


func _on_bgm_finished():
	if background_music.stream==audio_streams.get('shadow_man'):
		background_music.play()


#func _on_zone_7_body_entered(body):
	#if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera,camera_7)
		#timer_switch_cameras.start()
		#player_camera.position_smoothing_enabled=true
#
#
#func _on_zone_8_body_entered(body):
	#if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera,camera_8)
		#timer_switch_cameras.start()
		#player_camera.position_smoothing_enabled=true
#
#
#func _on_zone_9_body_entered(body):
	#if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera,camera_9)
		#timer_switch_cameras.start()
		#player_camera.position_smoothing_enabled=true
