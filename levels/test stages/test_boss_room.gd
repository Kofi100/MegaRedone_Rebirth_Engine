extends Node2D
@export var boss_music_stream={}
var stream_number=0
@onready var player_camera=$megaman/player_camera
@onready var background_boss_music = $background_boss_music

#all cameras
@onready var camera = $all_cameras/camera

# Called when the node enters the scene tree for the first time.
func _ready():
	background_boss_music.stream=boss_music_stream[stream_number]
	background_boss_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$megaman/HUD/map.visible=false
#	if $weapon_archive_boss!=null:
#		$weapon_archive_boss.active=true


func _on_background_boss_music_finished():
	background_boss_music.play()


func _on_area_body_entered(body):
	pass # Replace with function body.
	if body.is_in_group('player'):
		StageFunctions.switch_camera(player_camera,camera)
