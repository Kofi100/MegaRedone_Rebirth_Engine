extends Node2D
@onready var player_camera=$megaman/player_camera
#all stage cameras
@onready var camera=$all_cameras/camera
@onready var camera2=$all_cameras/camera2
@onready var camera_3 = $all_cameras/camera3;@onready var background_music = $bgm
@onready var camera_4 = $all_cameras/camera4
@onready var camera_5 = $all_cameras/camera5
@onready var camera_6 = $all_cameras/camera6

var audio_streams={"shadow_man":preload("res://assets/music/Mega Man 3 (NES) Music - Shadow Man Stage.mp3")}
# Called when the node enters the scene tree for the first time.
func _ready():
	StageFunctions.play_music_audioplayer(background_music,audio_streams.get("shadow_man"),0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$bg/ParallaxLayer/ParallaxLayer2.motion_offset.y+=50*delta
	if background_music.playing:
		if background_music.stream==audio_streams.get("shadow_man"):\
#		if background_music.get_playback_position()>=65:
#			background_music.play(0)
			pass
	#print(get_tree().has_group('player'))
@onready var timer_switch_cameras = $timer_switch_cameras

func _on_zone_body_entered(body):
	if body.is_in_group("player"):
		StageFunctions.switch_camera(player_camera,camera)
		timer_switch_cameras.start()


func _on_zone_2_body_entered(body):
	if body.is_in_group("player"):
		StageFunctions.switch_camera(player_camera,camera2)
		timer_switch_cameras.start()
		player_camera.position_smoothing_enabled=true

func _on_zone_3_body_entered(body):
	if body.is_in_group("player"):
		StageFunctions.switch_camera(player_camera,camera_3)
		timer_switch_cameras.start()
		player_camera.position_smoothing_enabled=true

func _on_zone_4_body_entered(body):
	if body.is_in_group("player"):
		StageFunctions.switch_camera(player_camera,camera_4)
		timer_switch_cameras.start()
		player_camera.position_smoothing_enabled=true

func _on_zone_5_body_entered(body):
	if body.is_in_group("player"):
		StageFunctions.switch_camera(player_camera,camera_5)
		timer_switch_cameras.start()
		player_camera.position_smoothing_enabled=true


func _on_zone_6_body_entered(body):
	if body.is_in_group("player"):
		StageFunctions.switch_camera(player_camera,camera_6)
		timer_switch_cameras.start()
		player_camera.position_smoothing_enabled=true

func _on_timer_switch_cameras_timeout():
	player_camera.position_smoothing_enabled=false


func _on_bgm_finished():
	if background_music.stream==audio_streams.get('shadow_man'):
		background_music.play()
